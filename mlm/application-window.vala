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

    [GtkTemplate (ui = "/mx/unam/MLM/mlm.ui")]
    public class ApplicationWindow : Gtk.ApplicationWindow {

        [GtkChild]
        private Gtk.Entry genre;
        [GtkChild]
        private Gtk.ListStore genre_model;
        //[GtkChild]
        //private Gtk.EntryCompletion completion;
        [GtkChild]
        private Gtk.Adjustment year_adjustment;

        private Application app;

        public ApplicationWindow(Gtk.Application application) {
            GLib.Object(application: application);
            app = application as Application;

            Gtk.Window.set_default_icon_name("mlm");
            var provider = new Gtk.CssProvider();
            try {
                var file = GLib.File.new_for_uri("resource:///mx/unam/MLM/mlm.css");
                provider.load_from_file(file);
            } catch (GLib.Error e) {
                GLib.warning("There was a problem loading 'mlm.css'");
            }
            Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(),
                                                      provider, 999);
            var date_time = new GLib.DateTime.now_local();
            year_adjustment.upper = date_time.get_year();

            /* Stupid GtkBuilder */
            genre.completion = new Gtk.EntryCompletion();
            genre.completion.model = genre_model;
            genre.completion.text_column = 0;
        }

        [GtkCallback]
        public void on_window_destroy() {
            application.quit();
        }
    }
}
