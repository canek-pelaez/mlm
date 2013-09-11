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

[CCode (prefix = "", lower_case_cprefix = "", cheader_filename = "config.h")]
namespace Config
{
	/* Package information */
	public const string PACKAGE_NAME;
	public const string PACKAGE_STRING;
	public const string PACKAGE_VERSION;

	/* Gettext package */
	public const string GETTEXT_PACKAGE;

	/* Configured paths - these variables are not present in config.h, they are
	 * passed to underlying C code as cmd line macros. */
	public const string LOCALEDIR;  /* /usr/local/share/locale */
	public const string PKGDATADIR; /* /usr/local/share/quick-photo-editor */
	public const string PKGLIBDIR;  /* /usr/local/lib/quick-photo-editor   */
}
