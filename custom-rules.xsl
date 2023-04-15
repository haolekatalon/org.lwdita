<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="ditamsg">


<xsl:template match="node() | @*">
  <xsl:copy>
    <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
</xsl:template>

<!-- move all images into one folder -->
<xsl:template match="file[@format = 'image']/@result">
  <xsl:attribute name="{local-name()}" select="concat('images/', .)"/>
</xsl:template>

<!-- Replace all dots with underscore, except for the extension dot -->
<xsl:template match="file[@format = 'dita']/@result">
  <xsl:variable name="newFileName" select="concat(translate(substring-before(., '.dita'), '.', '_'), '.dita')"/>
  <xsl:attribute name="{local-name()}" select="$newFileName"/>
</xsl:template>

</xsl:stylesheet>