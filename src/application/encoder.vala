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

    public class Encoder : Media {

        private string source;
        private string target;

        public Encoder(string source, string target) {
            base();
            this.source = source;
            this.target = target;

            var src = pipe.get_by_name("src");
            src.set_property("location", source);
            var sink = pipe.get_by_name("sink");
            sink.set_property("location", target);
        }

        protected override void set_pipeline() {
            try {
                pipe = (Gst.Pipeline)
                Gst.parse_launch(
                    "filesrc name=src                         ! " +
                    "decodebin                                ! " +
                    "audioconvert                             ! " +
                    "rglimiter                                ! " +
                    "audioconvert                             ! " +
                    "lamemp3enc target=1 bitrate=128 cbr=true ! " +
                    "filesink name=sink");
            } catch (GLib.Error e) {
                stderr.printf("%s\n", e.message);
            }
        }

        protected override void message_received(Gst.Message message) {
            switch (message.type) {
            case Gst.MessageType.EOS:
                pipe.set_state(Gst.State.PAUSED);
                break;
            case Gst.MessageType.STATE_CHANGED:
                var state = Gst.State.NULL;
                var pending = Gst.State.NULL;
                pipe.get_state(out state, out pending, 100);
                if (state == Gst.State.PAUSED &&
                    pending == Gst.State.VOID_PENDING) {
                    pipe.set_state(Gst.State.READY);
                } else if (state == Gst.State.READY &&
                           pending == Gst.State.VOID_PENDING) {
                    pipe.set_state(Gst.State.NULL);
                    working = false;
                }
                break;
            }
        }

        public void encode() {
            pipe.set_state(Gst.State.PLAYING);
            working = true;
        }

        public void cancel() {
            pipe.set_state(Gst.State.NULL);
        }
    }
}
