/*
 * This file is part of mlm.
 *
 * Copyright 2013-2014 Canek Peláez Valdés
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

    [GtkTemplate (ui = "/mx/unam/MLM/reencoding-dialog.ui")]
    public class ReencodingDialog : Gtk.Dialog {

        [GtkChild]
        private Gtk.Label label;

        [GtkChild]
        private Gtk.ProgressBar progress_bar;
        public Gtk.ProgressBar bar { get { return progress_bar; } }

        private string source;
        private string destination;

        public ReencodingDialog(string source, string destination) {
            this.source = source;
            this.destination = destination;

            label.label = _("Reencoding '%s'\ninto '%s'... ").printf(
                source, destination);

            show_all();
        }
    }
}
