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

/**
 * Namespace for configuration time variables.
 */
[CCode (lower_case_cprefix = "", cheader_filename = "config.h")]
namespace Config {

	/**
     * The package name.
     */
	public const string PACKAGE_NAME;

	/**
     * The package name string.
     */
	public const string PACKAGE_STRING;

	/**
     * The package version.
     */
	public const string PACKAGE_VERSION;

	/**
     * The gettext package.
     */
	public const string GETTEXT_PACKAGE;

	/* Configured paths - these variables are not present in config.h, they are
	 * passed to underlying C code as cmd line macros. */

    /**
     * The locale dir.
     */
	public const string LOCALEDIR;

    /**
     * The package data dir.
     */
	public const string PKGDATADIR;

    /**
     * The package library dir.
     */
    public const string PKGLIBDIR;
}
