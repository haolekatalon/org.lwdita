<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="ditamsg">

<xsl:template match="node() | @*">
  <xsl:copy>
    <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="file[@format = 'image']/@result">
  <xsl:message terminate="no">Debug message: Processing node {local-name()}</xsl:message>
  <xsl:variable name="currentNode" select="{local-name()}"/>
  <xsl:message terminate="no"><xsl:value-of select="$currentNode"/></xsl:message>
  <xsl:attribute name="{local-name()}" select="concat('images/', .)"/>
</xsl:template>

<xsl:template match="file[@format = 'topic']/@result">
  <xsl:attribute name="{local-name()}" select="concat('images/', .)"/>
</xsl:template>

</xsl:stylesheet>