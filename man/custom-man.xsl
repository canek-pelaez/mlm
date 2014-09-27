<?xml version='1.0' encoding='UTF-8'?> <!--*-nxml-*-->

<!--
  This file is part of mlm.

  Copyright 2013-2014 Canek Peláez Valdés

  mlm is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2.1 of the License, or
  (at your option) any later version.

  mlm is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with mlm; If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl"/>

<xsl:template name="top.comment" />

<xsl:template name="TH.title.line">
  <xsl:param name="title"/>
  <xsl:param name="section"/>
  <xsl:param name="extra1"/>
  <xsl:param name="extra2"/>
  <xsl:param name="extra3"/>

  <xsl:call-template name="mark.subheading"/>
  <xsl:text>.TH "</xsl:text>
  <xsl:call-template name="string.upper">
    <xsl:with-param name="string">
      <xsl:value-of select="normalize-space($title)"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>" "</xsl:text>
  <xsl:value-of select="normalize-space($section)"/>
  <xsl:text>" "" "mlm </xsl:text>
  <xsl:value-of select="$mlm.version"/>
  <xsl:text>" "</xsl:text>
  <xsl:value-of select="normalize-space($extra3)"/>
  <xsl:text>"&#10;</xsl:text>
  <xsl:call-template name="mark.subheading"/>
</xsl:template>

<xsl:template match="literal">
  <xsl:if test="$man.hyphenate.computer.inlines = 0">
    <xsl:call-template name="suppress.hyphenation"/>
  </xsl:if>
  <xsl:text>"</xsl:text>
  <xsl:call-template name="inline.monoseq"/>
  <xsl:text>"</xsl:text>
</xsl:template>

</xsl:stylesheet>
