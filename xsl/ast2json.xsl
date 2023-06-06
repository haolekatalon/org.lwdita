<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ast="com.elovirta.dita.markdown"
                exclude-result-prefixes="xs ast"
                version="2.0">

  <xsl:variable name="linefeed" as="xs:string" select="'&#xA;'"/>

  <xsl:template match="headerSidebar" mode="ast">
    <xsl:text> </xsl:text>
    <!--xsl:apply-templates mode="ast"/-->
    <!-- <xsl:text>Sidebar:</xsl:text>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/> -->
  </xsl:template>

  <xsl:template match="header1" mode="ast">
    <!-- Custom: Add imports -->
    <!-- <xsl:if test="@level='1'">
      <xsl:text>import Image from '@theme/IdealImage';</xsl:text>
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$linefeed"/>
    </xsl:if> -->
    <!-- <xsl:for-each select="1 to xs:integer(@level)">#</xsl:for-each> -->
    <!-- <xsl:text> </xsl:text> -->
    <!--xsl:apply-templates mode="ast"/-->
    <xsl:call-template name="process-inline-contents"/>
    <xsl:call-template name="ast-attibutes"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>

  <xsl:template match="bulletlist1" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:variable name="li1s" select="li1"/>
    <xsl:variable name="nested" select="ancestor::bulletlist1"/>
    <xsl:text>[</xsl:text>
      <xsl:apply-templates select="$li1s" mode="ast">
        <xsl:with-param name="totalCount" select="count($li1s)" tunnel="yes"/>
      </xsl:apply-templates>
    <xsl:text>]</xsl:text>
    <xsl:if test="not($nested)">
      <xsl:value-of select="$linefeed"/><!-- because last li will not write one -->
    </xsl:if>
  </xsl:template>

  <xsl:variable name="default-indent" select="'    '" as="xs:string"/>

  <xsl:template match="li1" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:param name="totalCount" tunnel="yes"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>{</xsl:text>
    <!-- If this is only a doc reference -->
    <xsl:if test="link1 and not(bulletlist1)">
      <xsl:text>"type":"doc","label":"</xsl:text>
      <xsl:value-of select="link1[1]/text()"/>
      <xsl:text></xsl:text>
      <xsl:text>","id":"</xsl:text>
      <xsl:value-of select="substring-before(link1/@href, '.mdx')"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <!-- If this is a doc reference with children topic -->
    <xsl:if test="link1 and bulletlist1">
      <xsl:text>"type":"doc","label":"</xsl:text>
      <xsl:value-of select="link1[1]/text()"/>
      <xsl:text></xsl:text>
      <xsl:text>","id":"</xsl:text>
      <xsl:value-of select="substring-before(link1/@href, '.mdx')"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <!-- If this is a section (category) -->
    <xsl:if test="not(link1) and bulletlist1">
      <xsl:text>"type":"category","label":"</xsl:text>
      <xsl:value-of select="text()"/>
      <xsl:text></xsl:text>
      <xsl:text>","items":</xsl:text>
      <xsl:apply-templates select="bulletlist1" mode="ast"/>
    </xsl:if>
    <!-- <xsl:apply-templates select="*[1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="''"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="*[position() ne 1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="concat($indent, $default-indent)"/>
    </xsl:apply-templates> -->
    <!--xsl:if test="following-sibling::li">
      <xsl:value-of select="$linefeed"/>
    </xsl:if-->
    <xsl:text>}</xsl:text>
    <!-- Check if the current element is the last one -->
    <xsl:variable name="position" select="position()"/>
    <xsl:variable name="isLast" select="$position = $totalCount"/>
    <xsl:if test="not($isLast)">
      <!-- If not the last one, then put a comma -->
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>