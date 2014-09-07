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

    public abstract class Media : GLib.Object {

        protected Gst.Pipeline pipe;
        public bool working { get; protected set; }

        public Media() {
            set_pipeline();

            var bus = pipe.get_bus();
            bus.add_signal_watch();
            bus.message.connect((b,m) => { message_received(m); });
        }

        protected abstract void set_pipeline();

        protected abstract void message_received(Gst.Message message);

        public double get_completion(out int64 duration = null,
                                     out int64 position = null) {
            duration = -1;
            position = -1;

            if (!pipe.query_duration(Gst.Format.TIME, out duration))
                return -1;
            if (!pipe.query_position(Gst.Format.TIME, out position))
                return -1;

            return (double)position/duration;
        }
    }
}

        