<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Transforms a context-free menu into one annotated based on the
       supplied context (ie, place in the menu structure). -->

  <xsl:import href="../../../stylesheets/defaults.xsl" />

  <!-- Make a simple copy of everything except the menu data. -->
  <xsl:template match="/aggregation/*">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="/aggregation/xmm:root" priority="100">
    <div type="menu">
      <ul>
        <xsl:apply-templates select="xmm:menu" mode="menu" />
      </ul>
    </div>
    <div type="breadcrumbs">
      <ul>
        <xsl:choose>
          <xsl:when test=".//*[@href=$xmg:path]">
            <xsl:apply-templates mode="breadcrumbs"
                                 select=".//xmm:menu[descendant::*[@href=$xmg:path]]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="breadcrumbs"
                                 select=".//xmm:menu[starts-with($xmg:path, @path)]" />
          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="xmm:menu | xmm:item" mode="menu">
    <li>
      <!-- Active item. -->
      <xsl:if test="@href = $xmg:path">
        <xsl:attribute name="class" select="'active-menu-item'" />
      </xsl:if>
      <a>
        <xsl:if test="@href">
          <xsl:attribute name="href" select="@href" />
        </xsl:if>
        <xsl:value-of select="@label" />
      </a>
      <!-- Sub-items. -->
      <xsl:if test="child::*">
        <ul>
          <xsl:apply-templates mode="menu" />
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="xmm:menu" mode="breadcrumbs">
    <li>
      <a href="{@href}">
        <xsl:value-of select="@label" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="xmm:menu[not(@root)]" mode="breadcrumbs" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
