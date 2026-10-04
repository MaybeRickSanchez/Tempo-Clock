#!/usr/bin/env python3
"""Tempo Clock - a native GTK window hosting the clock UI (WebKitGTK)."""
import os
import sys

import gi

gi.require_version("Gtk", "3.0")
try:
    gi.require_version("WebKit2", "4.1")
except ValueError:
    gi.require_version("WebKit2", "4.0")
from gi.repository import Gdk, GLib, Gtk, WebKit2

APP_ID = "org.tempoclock.App"
HERE = os.path.dirname(os.path.realpath(__file__))
INDEX = os.path.join(HERE, "www", "index.html")
if not os.path.exists(INDEX):  # running from the source tree
    INDEX = os.path.join(HERE, "..", "src", "www", "index.html")


class ClockApp(Gtk.Application):
    def __init__(self):
        super().__init__(application_id=APP_ID)
        self.win = None

    def do_activate(self):
        if self.win:
            self.win.present()
            return

        data = os.path.join(GLib.get_user_data_dir(), "tempo-clock")
        cache = os.path.join(GLib.get_user_cache_dir(), "tempo-clock")
        manager = WebKit2.WebsiteDataManager(base_data_directory=data,
                                             base_cache_directory=cache)
        context = WebKit2.WebContext.new_with_website_data_manager(manager)
        view = WebKit2.WebView.new_with_context(context)

        settings = view.get_settings()
        settings.set_property("enable-developer-extras", False)
        settings.set_property("media-playback-requires-user-gesture", False)
        settings.set_property("enable-page-cache", False)
        view.connect("context-menu", lambda *a: True)  # no browser menu
        view.connect("decide-policy", self.on_policy)

        self.win = Gtk.ApplicationWindow(application=self, title="Tempo Clock")
        self.win.set_default_size(1120, 740)
        self.win.set_size_request(620, 480)
        self.win.set_icon_name("tempo-clock")
        self.win.add(view)
        self.win.show_all()
        view.load_uri(GLib.filename_to_uri(os.path.abspath(INDEX), None))

    @staticmethod
    def on_policy(view, decision, dtype):
        # Keep the app on its own page; block navigation to anywhere else.
        if dtype == WebKit2.PolicyDecisionType.NAVIGATION_ACTION:
            uri = decision.get_navigation_action().get_request().get_uri()
            if not uri.startswith("file://"):
                decision.ignore()
                return True
        return False


if __name__ == "__main__":
    GLib.set_prgname("tempo-clock")
    GLib.set_application_name("Tempo Clock")
    sys.exit(ClockApp().run(sys.argv))
