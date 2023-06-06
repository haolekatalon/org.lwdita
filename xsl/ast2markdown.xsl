<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ast="com.elovirta.dita.markdown"
                exclude-result-prefixes="xs ast"
                version="2.0">

  <xsl:variable name="linefeed" as="xs:string" select="'&#xA;'"/>

  <!-- Table tags -->
  <xsl:variable name="table-start" as="xs:string" select="'&lt;table&gt;'"/>
  <xsl:variable name="table-end" as="xs:string" select="'&lt;&#47;table&gt;'"/>
  <xsl:variable name="tbody-start" as="xs:string" select="'&lt;tbody&gt;'"/>
  <xsl:variable name="tbody-end" as="xs:string" select="'&lt;&#47;tbody&gt;'"/>
  <xsl:variable name="th-start" as="xs:string" select="'&lt;th&gt;'"/>
  <xsl:variable name="th-end" as="xs:string" select="'&lt;&#47;th&gt;'"/>
  <xsl:variable name="tr-start" as="xs:string" select="'&lt;tr&gt;'"/>
  <xsl:variable name="tr-end" as="xs:string" select="'&lt;&#47;tr&gt;'"/>
  <xsl:variable name="td-start" as="xs:string" select="'&lt;td&gt;'"/>
  <xsl:variable name="td-end" as="xs:string" select="'&lt;&#47;td&gt;'"/>

  <!-- tablecell mode to process table contents ############################-->

  <xsl:template match="pandoc" mode="tablecontent">
    <xsl:apply-templates mode="tablecontent"/>
  </xsl:template>

  <xsl:template match="div" mode="tablecontent">
    <xsl:if test="@admonition">
      <xsl:choose>
        <xsl:when test="@admonition='note'">
          <xsl:text>&lt;Callout  type="info" emoji="ℹ️"&gt;</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:when test="@admonition='imporant'">
          <xsl:text>&lt;Callout type="info" emoji="✅"&gt;</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:when test="@admonition='tip'">
          <xsl:text>&lt;Callout emoji="💡"&gt;</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:when test="@admonition='attention'">
          <xsl:text>&lt;Callout type="warning" emoji="⚠️"&gt;</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&lt;Callout type="info" emoji="ℹ️"&gt;</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    
    <xsl:apply-templates mode="tablecontent"/>

    <xsl:if test="@callout">
      <xsl:text>&lt;&#47;Callout&gt;</xsl:text>
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$linefeed"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="para" mode="tablecontent">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:text>&lt;p&gt;</xsl:text>
    <xsl:call-template name="process-table-contents"/>
    <xsl:text>&lt;&#47;p&gt;</xsl:text>
    <!-- <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/> -->
  </xsl:template>

  <xsl:template match="plain" mode="tablecontent">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <!-- XXX; why is indent here? -->
    <!-- <xsl:value-of select="$indent"/> -->
    <xsl:call-template name="process-table-contents"/>
    <!-- <xsl:value-of select="$linefeed"/> -->
    <xsl:if test="parent::li and following-sibling::*[not(self::bulletlist | self::orderedlist)]">
      <!-- <xsl:value-of select="$linefeed"/> -->
    </xsl:if>
  </xsl:template>

  <xsl:template match="bulletlist" mode="tablecontent">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:variable name="nested" select="ancestor::bulletlist or ancestor::orderedlist"/>
    <xsl:variable name="lis" select="li"/>
    
    <xsl:text>&lt;ul&gt;</xsl:text>
    <xsl:apply-templates select="$lis" mode="tablecontent"/>
    <xsl:text>&lt;&#47;ul&gt;</xsl:text>
    <xsl:if test="not($nested)">
      <!-- <xsl:value-of select="$linefeed"/> -->
      <!-- because last li will not write one -->
    </xsl:if>

  </xsl:template>

  <xsl:template match="orderedlist" mode="tablecontent">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:variable name="nested" select="ancestor::bulletlist or ancestor::orderedlist"/>
    <xsl:variable name="lis" select="li"/>
    
    <xsl:text>&lt;ul&gt;</xsl:text>
    <xsl:apply-templates select="$lis" mode="tablecontent"/>
    <xsl:text>&lt;&#47;ul&gt;</xsl:text>
    <xsl:if test="not($nested)">
      <!-- <xsl:value-of select="$linefeed"/> -->
      <!-- because last li will not write one -->
    </xsl:if>

  </xsl:template>

  <xsl:template match="li" mode="tablecontent">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <!-- <xsl:value-of select="$indent"/> -->
    <xsl:text>&lt;li&gt;</xsl:text>
    <xsl:apply-templates select="*[1]" mode="tablecontent">
      <!-- <xsl:with-param name="indent" tunnel="yes" select="''"/> -->
    </xsl:apply-templates>
    <xsl:apply-templates select="*[position() ne 1]" mode="tablecontent">
      <!-- <xsl:with-param name="indent" tunnel="yes" select="concat($indent, $default-indent)"/> -->
    </xsl:apply-templates>
    <!--xsl:if test="following-sibling::li">
      <xsl:value-of select="$linefeed"/>
    </xsl:if-->
    <xsl:text>&lt;&#47;li&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="definitionlist" mode="tablecontent">
    <xsl:apply-templates mode="ast"/>
  </xsl:template>

  <xsl:template match="dlentry" mode="tablecontent">
    <xsl:apply-templates mode="ast"/>
  </xsl:template>

  <xsl:template match="dt" mode="tablecontent">
    <xsl:call-template name="process-inline-contents"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>

  <xsl:template match="dd" mode="tablecontent">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>:   </xsl:text>
    <xsl:apply-templates select="*[1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="''"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="*[position() ne 1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="concat($indent, $default-indent)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="codeblock" mode="tablecontent">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <!-- <xsl:value-of select="$indent"/> -->
    <xsl:text>&lt;pre&gt;&lt;code&gt;</xsl:text>
    <!-- no process outputclass -->
    <!-- <xsl:choose>
      <xsl:when test="empty(@id) and @class and not(contains(@class, ' '))">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="ast-attibutes"/>
      </xsl:otherwise>
    </xsl:choose> -->
    <!-- <xsl:value-of select="$linefeed"/> -->
    <xsl:call-template name="process-table-contents"/>
    <!-- <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$indent"/> -->
    <xsl:text>&lt;&#47;code&gt;&lt;&#47;pre&gt;</xsl:text>
    <!-- <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/> -->
  </xsl:template>
  
  <xsl:template match="blockquote" mode="tablecontent">
    <xsl:param name="prefix" tunnel="yes" as="xs:string?" select="()"/>
    <xsl:text>&lt;codeblock&gt;</xsl:text>
      <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;codeblock&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="strong" mode="tablecontent">
    <xsl:text>&lt;strong&gt;</xsl:text>
    <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;strong&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="emph" mode="tablecontent">
    <xsl:text>&lt;em&gt;</xsl:text>
    <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;em&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="cite" mode="tablecontent">
    <xsl:text>&lt;em&gt;</xsl:text>
    <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;em&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="code" mode="tablecontent">
    <xsl:text>&lt;code&gt;</xsl:text>
    <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;code&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="link[empty(@href | @keyref)]" mode="tablecontent">
    <xsl:apply-templates mode="tablecontent"/>
  </xsl:template>

  <xsl:template match="link[@href]" mode="tablecontent">
    <xsl:text>&lt;a href="</xsl:text>
    <xsl:value-of select="@href"/>
    <xsl:text>" &gt;</xsl:text>
    <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;a&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template match="link[empty(@href) and @keyref]" mode="tablecontent">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="@keyref"/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="image" mode="tablecontent">
    <xsl:text>&lt;img src="</xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@href, 'doc_images')">
        <xsl:value-of select="concat('/doc_images', substring-after(@href, 'doc_images'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@href"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>" </xsl:text>
    <!-- if there's width -->
    <xsl:if test="@width">
      <xsl:text>width={</xsl:text>
      <xsl:value-of select="@width"/>
      <xsl:text>} </xsl:text>
    </xsl:if>
    <!-- if there's alt -->
    <xsl:if test="@alt">
      <xsl:text>alt="</xsl:text>
      <xsl:value-of select="translate(@alt, '&quot;', '')"/>
      <xsl:apply-templates mode="ast"/>
      <xsl:text>" </xsl:text>
    </xsl:if>
    <xsl:text>&#47;&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="span" mode="tablecontent">
    <xsl:text>&lt;span&gt;</xsl:text>
      <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;span&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template match="linebreak" mode="tablecontent">
    <xsl:text>&lt;&#47;br&gt;</xsl:text>
  </xsl:template>

  <!-- Escape special characters -->
  <xsl:template match="text()" mode="tablecontent"
                name="texttablecontent">
    <xsl:param name="text" select="." as="xs:string"/>
    <xsl:variable name="head" select="substring($text, 1, 1)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="contains('{', $head)">
        <xsl:text><![CDATA[&#10100;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains('}', $head)">
        <xsl:text><![CDATA[&#10101;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains('_', $head)">
        <xsl:text><![CDATA[&#95;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains('>', $head)">
        <xsl:text><![CDATA[&gt;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains(translate($head, '&lt;', '*'), '*')">
        <!-- variable contains "<" character -->
        <xsl:text><![CDATA[&lt;]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$head"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="tail" select="substring($text, 2)" as="xs:string"/>
    <xsl:if test="string-length($tail) gt 0">
      <xsl:call-template name="texttablecontent">
        <xsl:with-param name="text" select="substring($text, 2)" as="xs:string"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <!-- Escape special characters for frontmatter -->
  <xsl:template match="text()" mode="metdata"
                name="textmetadata">
    <xsl:param name="text" select="." as="xs:string"/>
    <xsl:variable name="head" select="substring($text, 1, 1)" as="xs:string"/>
    <!-- Edit: removed forward angle -->
    <xsl:choose>
      <xsl:when test="contains('\`*_{}[]()#|', $head)">
        <xsl:value-of select="$head"/>       
      </xsl:when>
      <xsl:when test="contains('>', $head)">
        <xsl:text><![CDATA[&gt;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains(translate($head, '&lt;', '*'), '*')">
        <!-- variable contains "<" character -->
        <xsl:text><![CDATA[&lt;]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$head"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="tail" select="substring($text, 2)" as="xs:string"/>
    <xsl:if test="string-length($tail) gt 0">
      <xsl:call-template name="text">
        <xsl:with-param name="text" select="substring($text, 2)" as="xs:string"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- END OF TABLECONTENT MODE #######################################-->

  <!-- Block -->

  <xsl:template match="pandoc" mode="ast">
    <xsl:apply-templates mode="ast"/>
  </xsl:template>

  <xsl:template match="div" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:if test="@admonition">
      <xsl:value-of select="$indent"/>
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$indent"/>
      <xsl:choose>
        <xsl:when test="@admonition='note'">
          <xsl:text>:::note</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:when test="@admonition='imporant'">
          <xsl:text>:::caution</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:when test="@admonition='tip'">
          <xsl:text>:::tip</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:when test="@admonition='attention'">
          <xsl:text>:::caution</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>:::note</xsl:text>
          <xsl:value-of select="$linefeed"/>
          <xsl:value-of select="$linefeed"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    
    <xsl:apply-templates mode="ast"/>

    <xsl:if test="@admonition">
      <xsl:value-of select="$indent"/>
      <xsl:text>:::</xsl:text>
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$linefeed"/>
    </xsl:if>
  </xsl:template>

  <!-- <xsl:template match="div[@class='callout']" mode="ast">
    <xsl:text>&lt;Callout&gt;</xsl:text>
    <xsl:apply-templates mode="ast"/>
    <xsl:text>&lt;&#47;Callout&gt;</xsl:text>
  </xsl:template> -->

  <xsl:template match="para" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:call-template name="process-inline-contents"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>

  <xsl:template match="plain" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <!-- XXX; why is indent here? -->
    <xsl:value-of select="$indent"/>
    <xsl:call-template name="process-inline-contents"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:if test="(parent::li or parent::li1) and (following-sibling::*[not(self::bulletlist | self::orderedlist)] or following-sibling::*[not(self::bulletlist1 | self::orderedlist)])">
      <xsl:value-of select="$linefeed"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="header" mode="ast">
    <!-- Custom: Add imports -->
    <!-- <xsl:if test="@level='1'">
      <xsl:text>import Image from '@theme/IdealImage';</xsl:text>
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$linefeed"/>
    </xsl:if> -->
    <xsl:for-each select="1 to xs:integer(@level)">#</xsl:for-each>
    <xsl:text> </xsl:text>
    <!--xsl:apply-templates mode="ast"/-->
    <xsl:call-template name="process-inline-contents"/>
    <xsl:call-template name="ast-attibutes"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>
  
  <xsl:template name="ast-attibutes">
    <xsl:if test="@id or @class">
      <xsl:text> {</xsl:text>
      <xsl:if test="@id">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="@id"/>
      </xsl:if>
      <xsl:for-each select="tokenize(@class, '\s+')">
        <xsl:text> .</xsl:text>
        <xsl:value-of select="."/>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="bulletlist | orderedlist" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:variable name="nested" select="ancestor::bulletlist or ancestor::orderedlist"/>
    <xsl:variable name="lis" select="li"/>
    <!-- <xsl:if test="./@type"> -->
    
    <!-- <xsl:if test="@issteps">
      <xsl:text>&lt;Steps&gt;</xsl:text>
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$linefeed"/> 
    </xsl:if> -->
    <!-- </xsl:if> -->
    <!-- <xsl:text>Stepss starts&#10;</xsl:text> -->
    <xsl:apply-templates select="$lis" mode="ast"/>
    <xsl:if test="not($nested)">
      <xsl:value-of select="$linefeed"/><!-- because last li will not write one -->
    </xsl:if>
    <!-- <xsl:if test="@issteps">
      <xsl:text>&lt;&#47;Steps&gt;</xsl:text>
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$linefeed"/> 
    </xsl:if> -->
  </xsl:template>

  <xsl:variable name="default-indent" select="'    '" as="xs:string"/>
  <!-- Process li, may also process task/step -->
  <xsl:template match="li" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:value-of select="$indent"/>
    <xsl:choose>
      <xsl:when test="parent::bulletlist">
        <xsl:text>-   </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="label" select="concat(position(), '.')" as="xs:string"/>
        <xsl:value-of select="$label"/>
        <xsl:value-of select="substring($default-indent, string-length($label) + 1)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="*[1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="''"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="*[position() ne 1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="concat($indent, $default-indent)"/>
    </xsl:apply-templates>
    <!--xsl:if test="following-sibling::li">
      <xsl:value-of select="$linefeed"/>
    </xsl:if-->
  </xsl:template>
  
  <xsl:template match="definitionlist" mode="ast">
    <xsl:apply-templates mode="ast"/>
  </xsl:template>

  <xsl:template match="dlentry" mode="ast">
    <xsl:apply-templates mode="ast"/>
  </xsl:template>

  <xsl:template match="dt" mode="ast">
    <xsl:call-template name="process-inline-contents"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>

  <xsl:template match="dd" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>:   </xsl:text>
    <xsl:apply-templates select="*[1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="''"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="*[position() ne 1]" mode="ast">
      <xsl:with-param name="indent" tunnel="yes" select="concat($indent, $default-indent)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="codeblock" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>```</xsl:text>
    <xsl:choose>
      <xsl:when test="empty(@id) and @class and not(contains(@class, ' '))">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="ast-attibutes"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$linefeed"/>
    <xsl:call-template name="process-inline-contents"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>```</xsl:text>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>
  
  <xsl:template match="blockquote" mode="ast">
    <xsl:param name="prefix" tunnel="yes" as="xs:string?" select="()"/>
    <xsl:apply-templates mode="ast">
      <xsl:with-param name="prefix" tunnel="yes" select="concat($prefix, '> ')"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template name="process-inline-contents">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:param name="prefix" tunnel="yes" as="xs:string?" select="()"/>
    <xsl:variable name="contents" as="xs:string">
      <xsl:value-of>
        <xsl:apply-templates mode="ast"/>
      </xsl:value-of>
    </xsl:variable>
    <xsl:variable name="idnt" select="if (ancestor-or-self::tablecell) then () else $indent" as="xs:string?"/>
    <xsl:for-each select="tokenize($contents, '\n')">
      <xsl:value-of select="$idnt"/>  
      <xsl:value-of select="$prefix"/>
      <xsl:value-of select="."/>
      <xsl:if test="position() ne last()">
        <xsl:value-of select="$linefeed"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="process-table-contents">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:param name="prefix" tunnel="yes" as="xs:string?" select="()"/>
    <xsl:variable name="contents" as="xs:string">
      <xsl:value-of>
        <xsl:apply-templates mode="tablecontent"/>
      </xsl:value-of>
    </xsl:variable>
    <xsl:variable name="idnt" select="if (ancestor-or-self::tablecell) then () else $indent" as="xs:string?"/>
    <xsl:for-each select="tokenize($contents, '\n')">
      <xsl:value-of select="$idnt"/>  
      <xsl:value-of select="$prefix"/>
      <xsl:value-of select="."/>
      <xsl:if test="position() ne last()">
        <xsl:value-of select="$linefeed"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="table" mode="ast">
    <xsl:param name="indent" tunnel="yes" as="xs:string" select="''"/>
    <xsl:value-of select="$indent"/>
    <xsl:value-of select="$table-start"/>

    <xsl:for-each select="thead">
      <xsl:for-each select="tr">
        <xsl:value-of select="$tr-start"/>

        <xsl:for-each select="tablecell">
          <xsl:value-of select="$th-start"/>

          <xsl:call-template name="process-table-contents"/>

          <xsl:value-of select="$th-end"/>
        </xsl:for-each>

        <xsl:value-of select="$tr-end"/>
      </xsl:for-each>
    </xsl:for-each>
    
    <xsl:for-each select="tbody">
      <xsl:value-of select="$tbody-start"/>

      <xsl:for-each select="tr">
        <xsl:value-of select="$tr-start"/>

        <xsl:for-each select="tablecell">
          <!--xsl:apply-templates mode="ast"/-->
          <!-- td can contain colspan and rowspan -->
          <xsl:choose>
            <xsl:when test="@colspan or @rowspan">
              <xsl:text>&lt;td </xsl:text>
              <xsl:if test="@colspan">
                <xsl:text> colspan="</xsl:text>
                <xsl:value-of select="@colspan"/>
                <xsl:text>" </xsl:text>
              </xsl:if>
              <xsl:if test="@rowspan">
                <xsl:text> rowspan="</xsl:text>
                <xsl:value-of select="@rowspan"/>
                <xsl:text>" </xsl:text>
              </xsl:if>
              <xsl:text> td&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$td-start"/>
            </xsl:otherwise>
          </xsl:choose>
          
          <xsl:call-template name="process-table-contents"/>
          
          <xsl:value-of select="$td-end"/>
        </xsl:for-each>

        <xsl:value-of select="$tr-end"/>
      </xsl:for-each>
      <xsl:value-of select="$indent"/>
      <xsl:value-of select="$tbody-end"/>
    </xsl:for-each>
    

    <xsl:value-of select="$table-end"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>
  
  <!-- Inline -->
  
  <xsl:template match="strong" mode="ast">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates mode="ast"/>
    <xsl:text>**</xsl:text>
  </xsl:template>

  <xsl:template match="emph" mode="ast">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates mode="ast"/>
    <xsl:text>*</xsl:text>
  </xsl:template>

  <xsl:template match="cite" mode="ast">
    <xsl:text>*</xsl:text>
    <xsl:apply-templates mode="ast"/>
    <xsl:text>*</xsl:text>
  </xsl:template>

  <xsl:template match="code" mode="ast">
    <xsl:text>&lt;code&gt;</xsl:text>
    <xsl:apply-templates mode="tablecontent"/>
    <xsl:text>&lt;&#47;code&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="link[empty(@href | @keyref)]" mode="ast">
    <xsl:apply-templates mode="ast"/>
  </xsl:template>

  <xsl:template match="link[@href]" mode="ast">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates mode="ast"/>
    <xsl:text>]</xsl:text>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="@href"/>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xsl:template match="link[empty(@href) and @keyref]" mode="ast">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="@keyref"/>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template match="image" mode="ast">
    <xsl:text>&lt;img src="</xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@href, 'doc_images')">
        <xsl:value-of select="concat('/doc_images', substring-after(@href, 'doc_images'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@href"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>" </xsl:text>
    <!-- if there's width -->
    <xsl:if test="@width">
      <xsl:text>width={</xsl:text>
      <xsl:value-of select="@width"/>
      <xsl:text>} </xsl:text>
    </xsl:if>
    <!-- if there's alt -->
    <xsl:if test="@alt">
      <xsl:text>alt="</xsl:text>
      <xsl:value-of select="translate(@alt, '&quot;', '')"/>
      <!-- alt text is processed differently -->
      <xsl:apply-templates mode="ast"/>
      <xsl:text>" </xsl:text>
    </xsl:if>
    <xsl:text>&#47;&gt;</xsl:text>

    <!-- <xsl:text>![</xsl:text>
    <xsl:value-of select="@alt"/>
    <xsl:apply-templates mode="ast"/>
    <xsl:text>]</xsl:text>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="@href"/>
    <xsl:if test="@title">
      <xsl:text> "</xsl:text>
      <xsl:value-of select="@title"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <xsl:text>)</xsl:text> -->

    <!-- <xsl:text>&lt;Screenshot src="</xsl:text>
    <xsl:value-of select="@href"/>
    <xsl:text>" alt="</xsl:text>
    <xsl:value-of select="@alt"/>
    <xsl:apply-templates mode="ast"/>
    <xsl:text>" &#47;&gt;</xsl:text> -->
    <xsl:if test="@placement = 'break'">
      <xsl:value-of select="$linefeed"/>
      <xsl:value-of select="$linefeed"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="image[empty(@href) and @keyref]" mode="ast">
    <xsl:text>![</xsl:text>
    <xsl:value-of select="@keyref"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="span" mode="ast">
    <xsl:apply-templates mode="ast"/>
  </xsl:template>
  
  <xsl:template match="linebreak" mode="ast">
    <xsl:text>  </xsl:text>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>
  
  <!-- Escape special characters -->
  <xsl:template match="text()" mode="ast"
                name="text">
    <xsl:param name="text" select="." as="xs:string"/>
    <xsl:variable name="head" select="substring($text, 1, 1)" as="xs:string"/>
    <!-- Edit: removed forward angle -->
    <xsl:choose>
      <xsl:when test="contains('\`*_{}[]()#|', $head)">
        <xsl:text>\</xsl:text>
        <xsl:value-of select="$head"/>       
      </xsl:when>
      <xsl:when test="contains('>', $head)">
        <xsl:text><![CDATA[&gt;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains(translate($head, '&gt;', '*'), '*')">
        <!-- variable contains "<" character -->
        <xsl:text><![CDATA[&gt;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains(translate($head, '&lt;', '*'), '*')">
        <!-- variable contains "<" character -->
        <xsl:text><![CDATA[&lt;]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$head"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="tail" select="substring($text, 2)" as="xs:string"/>
    <xsl:if test="string-length($tail) gt 0">
      <xsl:call-template name="text">
        <xsl:with-param name="text" select="substring($text, 2)" as="xs:string"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="code/text()" mode="ast" priority="10">
    <xsl:param name="text" select="." as="xs:string"/>
    <xsl:variable name="head" select="substring($text, 1, 1)" as="xs:string"/>
    <!-- Edit: removed forward angle -->
    <xsl:choose>
      <xsl:when test="contains(translate($head, '&#123;', '*'), '*')">
        <xsl:text><![CDATA[&#123;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains('}', $head)">
        <xsl:text><![CDATA[&#125;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains('_', $head)">
        <xsl:text><![CDATA[&#95;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains(translate($head, '&gt;', '*'), '*')">
        <!-- variable contains "<" character -->
        <xsl:text><![CDATA[&gt;]]></xsl:text>
      </xsl:when>
      <xsl:when test="contains(translate($head, '&lt;', '*'), '*')">
        <!-- variable contains "<" character -->
        <xsl:text><![CDATA[&lt;]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$head"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="tail" select="substring($text, 2)" as="xs:string"/>
    <xsl:if test="string-length($tail) gt 0">
      <xsl:call-template name="text">
        <xsl:with-param name="text" select="substring($text, 2)" as="xs:string"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="codeblock/text()"
                mode="ast" priority="10">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="node()" mode="ast" priority="-10">
    <xsl:message>ERROR: Unsupported AST node <xsl:value-of select="name()"/></xsl:message>
    <xsl:apply-templates mode="ast"/>
  </xsl:template>
  
  <!-- Whitespace cleanup -->
  
  <xsl:template match="text()"
                mode="ast-clean">
    <xsl:variable name="normalized" select="normalize-space(.)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$normalized">
        <xsl:if test="preceding-sibling::node() and matches(., '^\s') and $normalized">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="$normalized"/>
        <xsl:if test="following-sibling::node() and matches(., '\s$') and $normalized">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="preceding-sibling::node() and following-sibling::node()">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="pandoc/text() |
                       div/text() |
                       bulletlist/text() |
                       orderedlist/text() |
                       definitionlist/text() |
                       dlentry/text() |
                       table/text() |
                       thead/text() |
                       tbody/text() |
                       tr/text()"
                mode="ast-clean" priority="10">
    <!--xsl:value-of select="normalize-space(.)"/-->
  </xsl:template>
  
  <xsl:template match="codeblock//text()"
                mode="ast-clean" priority="20">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="div[@class = 'p']" mode="ast-clean">
    <xsl:choose>
      <xsl:when test="every $i in node() satisfies ast:is-block($i) and $i/self::*">
        <xsl:apply-templates select="node()" mode="#current"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@* | node()" mode="ast-clean"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <xsl:template match="@* | node()"
                mode="ast-clean" priority="-10">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="ast-clean"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Flatten -->
  
  <xsl:function name="ast:is-container-block" as="xs:boolean">
    <xsl:param name="node" as="node()"/>
    <xsl:sequence select="$node/self::rawblock or
      $node/self::blockquote or
      (:$node/self::orderedlist or
      $node/self::bulletlist or:)
      $node/self::li or
      (:$node/self::definitionlist or $node/self::dt or:) $node/self::dd or
      (:$node/self::table or $node/self::thead or $node/self::tbody or $node/self::tr or $node/self::tablecell or:)
      $node/self::div or
      $node/self::null"/>
  </xsl:function>
  
  <xsl:function name="ast:is-block" as="xs:boolean">
    <xsl:param name="node" as="node()"/>
    <xsl:sequence select="$node/self::plain or
      $node/self::para or
      $node/self::codeblock or
      $node/self::rawblock or
      $node/self::blockquote or
      $node/self::orderedlist or
      $node/self::bulletlist or
      $node/self::definitionlist or $node/self::dlentry or $node/self::dt or $node/self::dd or
      $node/self::header or
      $node/self::horizontalrule or
      $node/self::table or $node/self::thead or $node/self::tbody or $node/self::tr or $node/self::tablecell or
      $node/self::div or
      $node/self::null"/>
  </xsl:function>
  
  <xsl:template match="@* | node()" mode="flatten" priority="-1000">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="flatten"/>
    </xsl:copy>
  </xsl:template>
  
  
  <!--xsl:template match="*[contains(@class, ' task/step ') or
                         contains(@class, ' task/substep ')]" mode="flatten" priority="100">
    <xsl:copy>
      <xsl:apply-templates select="@* | *" mode="flatten"/>
    </xsl:copy>
  </xsl:template-->
  
  <xsl:template match="para" mode="flatten" priority="100">
    <xsl:choose>
      <xsl:when test="empty(node())"/>
      <xsl:when test="count(*) eq 1 and
                      (*[ast:is-container-block(.)]) and 
                      empty(text()[normalize-space(.)])">
        <xsl:apply-templates mode="flatten"/>
      </xsl:when>
      <xsl:when test="descendant::*[ast:is-block(.)]">
        <xsl:variable name="current" select="." as="element()"/>
        <xsl:variable name="first" select="node()[1]" as="node()?"/>
        <xsl:for-each-group select="node()" group-adjacent="ast:is-block(.)">
          <xsl:choose>
            <xsl:when test="current-grouping-key()">
              <xsl:apply-templates select="current-group()" mode="flatten"/>
            </xsl:when>
            <xsl:when test="count(current-group()) eq 1 and current-group()/self::text() and not(normalize-space(current-group()))"/>
            <xsl:when test="parent::li and $first is current-group()[1]">
              <plain>
                <xsl:apply-templates select="current-group()" mode="flatten"/>
              </plain>
            </xsl:when>
            <xsl:otherwise>
              <para gen="1">
                <xsl:apply-templates select="$current/@* except $current/@id | current-group()" mode="flatten"/>
              </para>
            </xsl:otherwise>  
          </xsl:choose>
        </xsl:for-each-group>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@* | node()" mode="flatten"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- wrapper elements -->
  <xsl:template match="*[ast:is-container-block(.)]" mode="flatten" priority="10">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="flatten"/>
      <xsl:variable name="first" select="node()[1]" as="node()?"/>
      <xsl:for-each-group select="node()" group-adjacent="ast:is-block(.)">
        <xsl:choose>
          <xsl:when test="current-grouping-key()">
            <xsl:apply-templates select="current-group()" mode="flatten"/>
          </xsl:when>
          <xsl:when test="count(current-group()) eq 1 and current-group()/self::text() and not(normalize-space(current-group()))"/>
          <xsl:when test="parent::li and $first is current-group()[1]">
            <plain>
              <xsl:apply-templates select="current-group()" mode="flatten"/>
            </plain>
          </xsl:when>
          <xsl:otherwise>
            <para>
              <xsl:apply-templates select="current-group()" mode="flatten"/>
            </para>
          </xsl:otherwise>  
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>

  <!-- YAML -->

  <xsl:template match="head" mode="ast">
    <xsl:text>---&#xA;</xsl:text>
    <xsl:apply-templates select="*" mode="#current"/>
    <xsl:text>---&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="map" mode="ast">
    <xsl:for-each select="entry">
      <xsl:value-of select="@key"/>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates mode="metadata"/>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="array" mode="ast">
    <xsl:text>[</xsl:text>
    <xsl:for-each select="entry">
      <xsl:if test="position() ne 1">, </xsl:if>
      <xsl:apply-templates mode="#current"/>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>