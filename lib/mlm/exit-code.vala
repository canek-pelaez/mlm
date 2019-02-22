/*
 * This file is part of mlm.
 *
 * Copyright © 2013-2019 Canek Peláez Valdés
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
     * Exit code enumeration.
     */
    public enum ExitCode {
        A_OK                = 0,
        COPY_ERROR          = 100,
        IMAGE_FOR_MANY      = 101,
        INVALID_ARGUMENT    = 102,
        INVALID_DESTINATION = 103,
        INVALID_DISC        = 104,
        INVALID_GENRE       = 105,
        INVALID_IMAGE_FILE  = 106,
        INVALID_OUTPUT_DIR  = 107,
        INVALID_TRACK       = 108,
        INVALID_YEAR        = 109,
        MISSING_ARGUMENT    = 110,
        MISSING_FILES       = 111,
        MISSING_OUTPUT_DIR  = 112,
        NOT_ENOUGH_INFO     = 113,
        NO_ID3_PICTURE      = 114,
        NO_ID3_TAGS         = 115,
        NO_IMAGE_FILE       = 116,
        NO_SUCH_FILE        = 117,
        READING_ERROR       = 118,
        WRITING_ERROR       = 119;
    }
}
