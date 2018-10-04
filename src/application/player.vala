/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2018 Canek Peláez Valdés
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
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 *    Canek Peláez Valdés <canek@ciencias.unam.mx>
 */

namespace MLM {

    public class Player : Media {

        public enum Status {
            RESET,
            PLAYING,
            PAUSED;
        }

        public signal void status_changed(Player.Status status);

        public Player(string filename) {
            base();

            var src = pipe.get_by_name("src");
            src.set_property("location", filename);

            pipe.set_state(Gst.State.PAUSED);
        }

        protected override void set_pipeline() {
            try {
                pipe = (Gst.Pipeline)
                    Gst.parse_launch(
                        "filesrc name=src ! " +
                        "decodebin        ! " +
                        "autoaudiosink");
            } catch (GLib.Error e) {
                stderr.printf("There was an error while creating the play pipeline.\n");
            }
        }

        protected override void message_received(Gst.Message message) {
            switch (message.type) {
            case Gst.MessageType.EOS:
                pipe.seek_simple(Gst.Format.TIME, Gst.SeekFlags.FLUSH, 0);
                pipe.set_state(Gst.State.PAUSED);
                status_changed(Status.RESET);
                break;
            case Gst.MessageType.STATE_CHANGED:
                var state = Gst.State.NULL;
                var pending = Gst.State.NULL;
                pipe.get_state(out state, out pending, 100);
                switch (state) {
                case Gst.State.PLAYING:
                    status_changed(Status.PLAYING);
                    working = true;
                    break;
                case Gst.State.PAUSED:
                    working = false;
                    break;
                case Gst.State.READY:
                    working = false;
                    break;
                case Gst.State.NULL:
                    break;
                case Gst.State.VOID_PENDING:
                    break;
                }
                break;
            }
        }

        public void play() {
            pipe.set_state(Gst.State.PLAYING);
        }

        public void pause() {
            pipe.set_state(Gst.State.PAUSED);
            working = false;
        }

        public bool seek(double percentage) {
            int64 duration = -1;
            if (!pipe.query_duration(Gst.Format.TIME, out duration))
                return false;
            if (duration == 0)
                return false;
            int64 nsecs = (int64)(duration * percentage);
            pipe.seek_simple(Gst.Format.TIME,
                             Gst.SeekFlags.ACCURATE|Gst.SeekFlags.FLUSH,
                             nsecs);
            return true;
        }
    }
}
