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

    /**
     * Class for players.
     */
    public class Player : Media {

        /**
         * The “state-changed” signal.
         *
         * The ''::state-changed'' signal will be emitted when the state of the
         * player changes.
         * @param state the new state.
         */
        public signal void state_changed(Gst.State state);

        /**
         * The state.
         */
        public Gst.State state { get { return obtain_state(); } }

        /* The last state. */
        private Gst.State last_state;

        /**
         * Initializes the player.
         * @param filename the filename.
         */
        public Player(string filename) {
            base();
            var src = pipe.get_by_name("src");
            src.set_property("location", filename);
            pipe.set_state(Gst.State.PAUSED);
            last_state = Gst.State.PAUSED;
        }

        /**
         * Sets the pipeline.
         */
        protected override void set_pipeline() {
            try {
                pipe = (Gst.Pipeline)
                    Gst.parse_launch(
                        "filesrc name=src ! " +
                        "decodebin        ! " +
                        "autoaudiosink");
            } catch (GLib.Error e) {
                stderr.printf("Error while creating the play pipeline.\n");
            }
        }

        /**
         * Handles the message received.
         * @param message the message.
         */
        protected override void message_received(Gst.Message message) {
            switch (message.type) {
            case Gst.MessageType.EOS:
                pipe.seek_simple(Gst.Format.TIME, Gst.SeekFlags.FLUSH, 0);
                pipe.set_state(Gst.State.PAUSED);
                break;
            case Gst.MessageType.STATE_CHANGED:
                var new_state = Gst.State.NULL;
                var pending = Gst.State.NULL;
                pipe.get_state(out new_state, out pending, 100);
                if (last_state != new_state) {
                    state_changed(new_state);
                    last_state = new_state;
                }
                if (new_state == Gst.State.PAUSED &&
                    pending == Gst.State.VOID_PENDING) {
                    working = false;
                } else if (new_state == Gst.State.PLAYING &&
                           pending == Gst.State.VOID_PENDING) {
                    working = true;
                } else if (new_state == Gst.State.READY &&
                           pending == Gst.State.VOID_PENDING) {
                    pipe.set_state(Gst.State.NULL);
                    working = false;
                }
                break;
            }
        }

        /**
         * Plays the player.
         */
        public void play() {
            pipe.set_state(Gst.State.PLAYING);
        }

        /**
         * Pauses the player.
         */
        public void pause() {
            pipe.set_state(Gst.State.PAUSED);
        }

        /**
         * Finishes the player.
         */
        public void finish() {
            pipe.set_state(Gst.State.READY);
        }

        /**
         * Seeks a position in the player.
         * @para percentage the percentage position.
         */
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

        /**
         * Returns the current state.
         * @return the current state.
         */
        private Gst.State obtain_state() {
            var new_state = Gst.State.NULL;
            var pending = Gst.State.NULL;
            pipe.get_state(out new_state, out pending, 100);
            return new_state;
       }
    }
}
