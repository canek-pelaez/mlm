/*
 * This file is part of mlm.
 *
 * Copyright 2013 Canek Peláez Valdés
 *
 * mlm is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * mlm is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with mlm. If not, see <http://www.gnu.org/licenses/>.
 */

namespace MLM {

    public class Application : Gtk.Application {

        private ApplicationWindow window;

        public Application() {
            application_id = "mx.unam.MLM";
            flags |= GLib.ApplicationFlags.HANDLES_OPEN;

            var action = new GLib.SimpleAction("about", null);
            action.activate.connect(() => about());
            add_action(action);

            action = new GLib.SimpleAction("quit", null);
            action.activate.connect(() => quit());
            add_action(action);
        }

        public override void startup() {
            base.startup();
            var menu = new GLib.Menu();
            menu.append(_("About"), "app.about");
            menu.append(_("Quit"), "app.quit");
            set_app_menu(menu);
        }

        public override void activate() {
            base.activate();

            if (window == null)
                window = new ApplicationWindow(this);

            window.present();
        }

        public override void open(GLib.File[] files, string hint) {
            activate();
        }

        private void about() {
            string[] authors = { "Canek Peláez Valdés <canek@ciencias.unam.mx>" };
            Gtk.show_about_dialog(
                window,
                "authors", authors,
                "comments", _("A Gtk+ based music library maintainer"),
                "copyright", "Copyright 2013 Canek Peláez Valdés",
                "license-type", Gtk.License.GPL_3_0,
                "logo-icon-name", "gqpe",
                "version", Config.PACKAGE_VERSION,
                "website", "http://github.com/canek-pelaez/mlm",
                "wrap-license", true);
        }
    }
}
