/*
 * This file is part of mlm.
 *
 * Copyright © 2016-2018 Canek Peláez Valdés
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */

namespace MLM {

    /**
     * Class for warning dialogs.
     */
    [GtkTemplate (ui = "/mx/unam/MLM/warning.ui")]
    public class WarningDialog : Gtk.Dialog {

        [GtkChild]
        private unowned Gtk.Label message_label;

        /**
         * Initializes a shortcuts window.
         */
        public WarningDialog(Gtk.Window window, string message) {
            GLib.Object(use_header_bar: 1);
            transient_for = window;
            message_label.label = message;
        }
    }
}
