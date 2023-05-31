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
<xsl:template match="file[@format = 'image']/@result" name="change-result-image">
  <xsl:attribute name="{local-name()}" select="concat('doc_images/', .)"/>
</xsl:template>

<!-- Replace all dots with underscore, except for the extension dot -->
<xsl:template match="file[@format = 'dita']/@result">
<!--   <xsl:variable name="newFileName" select="concat(translate(substring-before(., '.dita'), '.', '_'), '.dita')"/>
  <xsl:attribute name="{local-name()}" select="$newFileName"/> -->
  <xsl:variable name="filename" select="translate(tokenize(substring-before(., '.dita'), '/')[last()], '.', '_')"/>
  <xsl:variable name="parentFile" select=".." />
  <xsl:variable name="externalData" select="document(substring-after($parentFile/@src, 'file:'))" />
  <xsl:variable name="topic-id" select="$externalData/node()/@id"/>
  <xsl:attribute name="{local-name()}" select="concat('docs/', $topic-id, '.dita')"/>
</xsl:template>

<!-- Replace all dots with underscore, except for the extension dot -->
<xsl:template match="file[@format = 'ditamap']/@result">
<!--   <xsl:variable name="newFileName" select="concat(translate(substring-before(., '.ditamap'), '.', '_'), '.ditamap')"/>
  <xsl:attribute name="{local-name()}" select="$newFileName"/> -->
  <xsl:variable name="filename" select="translate(tokenize(substring-before(., '.ditamap'), '/')[last()], '.', '_')"/>
  <xsl:variable name="parentFile" select=".." />
  <xsl:variable name="externalData" select="document(substring-after($parentFile/@src, 'file:'))" />
  <xsl:variable name="topic-id" select="$externalData/node()/@id"/>
  <xsl:attribute name="{local-name()}" select="concat('docs/', $topic-id, '.ditamap')"/>
</xsl:template>

</xsl:stylesheet>