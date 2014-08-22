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

    public class Encoder {

        private string source;
        private string dest;
        private Gst.Pipeline pipe;

        public bool encoding { get; private set; }

        public Encoder(string source, string dest) {
            this.source = source;
            this.dest = dest;

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
            } catch(Error e) {
                stderr.printf("%s\n", e.message);
            }

            var src = pipe.get_by_name("src");
            src.set_property("location", source);
            var sink = pipe.get_by_name("sink");
            sink.set_property("location", dest);

            var bus = pipe.get_bus();
            bus.add_signal_watch();
            bus.message.connect((b,m) => { message_received(m); });
        }

        private void message_received(Gst.Message message) {
            if (message.type == Gst.MessageType.EOS)
                if (change_pipeline_state(Gst.State.NULL))
                    encoding = false;
        }

        private bool change_pipeline_state(Gst.State new_state) {
            pipe.set_state(new_state);
            Gst.State state = Gst.State.NULL;
            Gst.State pending;

            Gst.StateChangeReturn r;

            do {
                r = pipe.get_state(out state, out pending, 100);
                if (r == Gst.StateChangeReturn.FAILURE)
                    return false;
            } while (state != new_state);

            return true;
        }

        public bool encode() {
            if (!change_pipeline_state(Gst.State.PLAYING))
                return false;
            encoding = true;
            return true;
        }

        public void cancel() {
            change_pipeline_state(Gst.State.NULL);
            encoding = false;
        }

        public double get_completion_percentage() {
            Gst.State state;
            Gst.State pending;

            pipe.get_state(out state, out pending, 100);

            if (state != Gst.State.PLAYING)
                return 1.0;

            int64 duration = -1;
            Gst.Format format = Gst.Format.TIME;
            while (duration == -1)
                if (!pipe.query_duration(format, out duration))
                    duration = -1;

            int64 pos = -1;
            while (pos == -1)
                if (!pipe.query_position(format, out pos))
                    pos = -1;

            return (double)pos / (double)duration;
        }
    }
}
