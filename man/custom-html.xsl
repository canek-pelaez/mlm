<?xml version='1.0' encoding='utf-8'?> <!--*-nxml-*-->

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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl"/>

  <xsl:template match="citerefentry[not(@project)]">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of
        select="refentrytitle"/><xsl:text>.html</xsl:text>
      </xsl:attribute>
      <xsl:call-template name="inline.charseq"/>
    </a>
  </xsl:template>

  <xsl:template match="refsect1/title|refsect1/info/title">
    <h2>
      <xsl:attribute name="id">
        <xsl:call-template name="inline.charseq"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <a>
        <xsl:attribute name="class">
          <xsl:text>headerlink</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>Permalink to this headline</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:call-template name="inline.charseq"/>
        </xsl:attribute>
        <xsl:text>¶</xsl:text>
      </a>
    </h2>
  </xsl:template>

  <xsl:template match="refsect2/title|refsect2/info/title">
    <h3>
      <xsl:attribute name="id">
        <xsl:call-template name="inline.charseq"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <a>
        <xsl:attribute name="class">
          <xsl:text>headerlink</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>Permalink to this headline</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:call-template name="inline.charseq"/>
        </xsl:attribute>
        <xsl:text>¶</xsl:text>
      </a>
    </h3>
  </xsl:template>

  <xsl:template match="varlistentry">
    <dt>
      <xsl:attribute name="id">
        <xsl:call-template name="inline.charseq">
          <xsl:with-param name="content">
            <xsl:copy-of select="term[position()=1]" />
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="term"/>
      <a>
        <xsl:attribute name="class">
          <xsl:text>headerlink</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>Permalink to this term</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:call-template name="inline.charseq">
            <xsl:with-param name="content">
              <xsl:copy-of select="term[position()=1]" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:text>¶</xsl:text>
      </a>
    </dt>
    <dd>
      <xsl:apply-templates select="listitem"/>
    </dd>
  </xsl:template>


  <xsl:template name="user.header.content">
    <style>
    body {
      width: 900px;
      font-family: sans-serif;
    }

    a.headerlink {
      color: #c60f0f;
      font-size: 0.8em;
      padding: 0 4px 0 4px;
      text-decoration: none;
      visibility: hidden;
    }

    a.headerlink:hover {
      background-color: #c60f0f;
      color: white;
    }

    h1:hover > a.headerlink, h2:hover > a.headerlink, h3:hover > a.headerlink, dt:hover > a.headerlink {
      visibility: visible;
    }
    </style>
    <span style="float:right">
      <xsl:text>mlm </xsl:text>
      <xsl:value-of select="$mlm.version"/>
    </span>
  </xsl:template>

  <xsl:template match="literal">
    <xsl:text>"</xsl:text>
    <xsl:call-template name="inline.monoseq"/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:output method="html" encoding="UTF-8" indent="no"/>

</xsl:stylesheet>
