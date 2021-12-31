<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all">

    <!-- Adapted from Alex Gil's tei-to-ed stylesheet at https://raw.githubusercontent.com/minicomp/ed/master/optional/tei-to-ed/tei-to-ed.xsl -->

    <xsl:output encoding="UTF-8" method="text"/>
    <xsl:strip-space elements="*"/>

    <!-- for replacements of curly quotes in source -->
    <xsl:param name="doubleQuotePat">’</xsl:param>
    <xsl:param name="doubleQuoteRep">&apos;</xsl:param>

    <xsl:param name="singleQuotePat">‘</xsl:param>
    <xsl:param name="singleQuoteRep">&apos;</xsl:param>

    <!-- global variables for letter metadata -->
    <xsl:variable name="letter_id" select="//correspDesc/@xml:id"/>
    <xsl:variable name="title">
        <xsl:for-each select="$letter_id">
            <xsl:variable name="targetLetterId" select="."/>
            <xsl:variable name="sender" select="/TEI/teiHeader/profileDesc/correspDesc[@xml:id=$targetLetterId]/correspAction[@type='sent']/persName"/>
            <xsl:variable name="addressee" select="/TEI/teiHeader/profileDesc/correspDesc[@xml:id=$targetLetterId]/correspAction[@type='received']/persName"/>
            <xsl:variable name="date_sent" select="/TEI/teiHeader/profileDesc/correspDesc[@xml:id=$targetLetterId]/correspAction[@type='sent']/date"/>
            <xsl:text>&#xa; - </xsl:text>
            <xsl:value-of select="$sender"/><xsl:text> to </xsl:text><xsl:value-of select="$addressee"/><xsl:text>, </xsl:text><xsl:value-of select="$date_sent"/>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">

        <xsl:variable name="alumnus_id" select="substring-before(//correspDesc[1]/@xml:id, '_')"/>
        <xsl:result-document method="text" encoding="utf-8" href="_texts/{$alumnus_id}-annotated.md"
            omit-xml-declaration="yes">

            <xsl:text>---&#x0A;layout: narrative&#x0A;</xsl:text>
            <xsl:text>title: </xsl:text>
            <xsl:value-of select="normalize-space(/TEI/teiHeader/fileDesc/titleStmt/title)"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>author: various</xsl:text>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>mode: annotated</xsl:text>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>editor: </xsl:text>
            <xsl:apply-templates select="/TEI/teiHeader/fileDesc/titleStmt/respStmt" mode="toc"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>rights: </xsl:text>
            <xsl:value-of
                select="normalize-space(/TEI/teiHeader/fileDesc/publicationStmt/availability)"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>toc: </xsl:text>
            <xsl:apply-templates select="$title" mode="toc"/>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:text>---&#x0A;&#x0A;</xsl:text>
            <xsl:text>Mss: </xsl:text>
            <xsl:for-each select="/TEI/teiHeader/fileDesc/publicationStmt/idno[@type='URI']">
                <xsl:text>&lt;a href="</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>" target="_blank"&gt;</xsl:text>
                <xsl:text>&lt;img src="../../assets/photo-icon.png" alt="Manuscript pages" style="display:inline-block; margin-bottom:-3px;"&gt; </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>&lt;/a&gt;</xsl:text>
                <xsl:text>&lt;br&gt;</xsl:text>
            </xsl:for-each>
            <xsl:text>&#x0A;* * *</xsl:text>

            <xsl:apply-templates/> <!-- close the div -->

        </xsl:result-document>
    </xsl:template>

    <xsl:template match="teiHeader"/> <!-- do nothing with teiHeader -->

    <!-- check to see if multiple editors -->
    <xsl:template mode="toc" match="//respStmt">
        <xsl:if test="position() eq 1">
            <xsl:value-of select="name/normalize-space(text())"/>
        </xsl:if>
        <xsl:if test="position() &gt; 1">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="name/normalize-space(text())"/>
        </xsl:if>
    </xsl:template>

    <!-- generate toc in YAML header 
    <xsl:template mode="toc" match="$title">
        <xsl:text>&#xa; - </xsl:text>
        <xsl:apply-templates />
    </xsl:template> 
    -->

    <!-- retrieve title and body for each letter -->
    <xsl:template match="/TEI/text/body/div">
        <xsl:for-each select=".">
            <xsl:variable name="targetDivId" select="substring-after(@decls, '#')"/>
            <xsl:text>&#xa;## </xsl:text>
            <xsl:value-of
                select="/TEI/teiHeader/profileDesc/correspDesc[@xml:id=$targetDivId]/correspAction[@type='sent']/persName"/>
            <xsl:text> to </xsl:text>
            <xsl:value-of
                select="/TEI/teiHeader/profileDesc/correspDesc[@xml:id=$targetDivId]/correspAction[@type='received']/persName"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="/TEI/teiHeader/profileDesc/correspDesc[@xml:id=$targetDivId]/correspAction[@type='sent']/date"/>
            <xsl:text>&#xa;&#xa;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&#x0A;* * * &#x0A;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <!-- sanitize text nodes for kramdown -->
    <xsl:template match="text()">
        <xsl:value-of select="replace(replace(., '-', '—'), '\s+', ' ')"/>
    </xsl:template>

    <xsl:template match="lb | addrLine">
        <xsl:apply-templates/>
        <xsl:text>&lt;br&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="head | note[@type='letterhead']">
        <xsl:text>&lt;p class="centered large"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="opener/dateline">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="right"&gt;</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="opener/salute">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="left"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="closer/salute">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="indent-1"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="closer/signed">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:text>&lt;p class="indent-2"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="p">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&#x0A;</xsl:text>
    </xsl:template>
    <xsl:template match="unclear">
        <xsl:if test="not(text())">
            <xsl:text>_[?]_</xsl:text>
        </xsl:if>
        <xsl:if test="text()">
            <xsl:text>_</xsl:text>
            <xsl:apply-templates/>
            <xsl:text> [?]_</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="choice"> <!-- take normalized text where available -->
        <xsl:text>[</xsl:text>
        <xsl:value-of select="corr | reg | expan"/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="del"> <!-- handle deletions of text -->
        <xsl:text>&lt;del&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/del&gt;</xsl:text>
    </xsl:template>
    <xsl:template match="list[@rend = 'numbered']">
        <xsl:for-each select="item">
            <xsl:text>&lt;br /&gt;</xsl:text>
            <xsl:number value="position()"/>
            <xsl:text>.&#x20;&#x20;</xsl:text>
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="figure">
        <xsl:text>&lt;p class="small"&gt;</xsl:text>
        <xsl:text>&lt;i&gt;[</xsl:text><xsl:value-of select="figDesc"/><xsl:text>]&lt;/i&gt;</xsl:text>
        <xsl:text>&lt;br /&gt;</xsl:text>
        <xsl:value-of select="head"/>
        <xsl:text>&lt;/p&gt;&#x0A;</xsl:text>
    </xsl:template>

    <xsl:template match="hi[@rend = 'italic']">
        <xsl:text>*</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>*</xsl:text>
    </xsl:template>

    <xsl:template match="hi[@rend = 'bold']">
        <xsl:text>**</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>**</xsl:text>
    </xsl:template>
    
    <xsl:template match="hi[@rend = 'superscript'] | add[@place = 'above']">
        <xsl:text>&lt;sup&gt;</xsl:text><xsl:apply-templates/><xsl:text>&lt;/sup&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="sic">
        <xsl:text>*</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>* [sic]</xsl:text>
    </xsl:template>
    
    <!-- make marginal additions centered, smaller; use add class to pick up green text color -->
    <xsl:template match="add[@place = 'margin']">
        <xsl:text>&lt;p class="centered small add"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;</xsl:text>
    </xsl:template>
    
    <!-- render postmarks as monotype (this picks up stuff defined in _ed.scss) -->
    <xsl:template match="ab[@type = 'postmark']">
        <xsl:text>&lt;p class="pre-printed centered"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/p&gt;</xsl:text>
    </xsl:template>
    <!-- render pre-printed forms using span because handwriting usually follows and I don't want to start a newline when that happens -->
    <xsl:template match="ab[@type = 'pre-printed']">
        <xsl:text>&lt;span class="pre-printed"&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&lt;/span&gt;</xsl:text>
    </xsl:template>
    
    <!-- justify addresses correctly -->
    <xsl:template match="address">
        <xsl:choose>
            <xsl:when test='@style="text-align: right;"'>
                <xsl:text>&lt;p class="right"&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&lt;/p&gt;</xsl:text>
            </xsl:when>
            <xsl:when test='@style="text-align: center;"'>
                <xsl:text>&lt;p class="centered"&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&lt;/p&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&lt;p class="left"&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&lt;/p&gt;</xsl:text> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- add page numbers, fg suspending for now, 2021-11-24  -->
<!--    <xsl:template match="pb">
        <xsl:text>&#x0A;&lt;p class="small centered"&gt; [Page: </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>] &lt;/p&gt;&#x0A;&#x0A;</xsl:text>
    </xsl:template>-->

    <!-- data balloons for names of people and places -->
    <xsl:template match="persName">
        <xsl:text>&lt;button data-balloon-pos="up" data-balloon-length="large" data-balloon="</xsl:text>
        <xsl:value-of disable-output-escaping="yes"
            select="@key[1]/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
        <xsl:text> | Born: </xsl:text>
        <xsl:value-of select="@from | @from-iso"/>
        <xsl:text>. Died: </xsl:text>
        <xsl:value-of select="@to | @to-iso"/>
        <xsl:text>.&#10;</xsl:text>
        <xsl:value-of select="@role"/>
        <xsl:text>."&gt;</xsl:text>
        <!--        <xsl:text>&lt;a href=&apos;</xsl:text>
        <xsl:value-of select="@ref"/>
        <xsl:text>&apos;&gt;</xsl:text>-->
        <xsl:apply-templates/>
        <!--        <xsl:text>&lt;/a&gt;&#160;</xsl:text>-->
        <xsl:text>&lt;/button&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="placeName">
        <xsl:text>&lt;button data-balloon-pos="up" data-balloon-length="large" data-balloon="</xsl:text>
        <xsl:value-of disable-output-escaping="yes"
            select="@key[1]/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
        <xsl:text>"&gt;</xsl:text>
        <xsl:text>&lt;a href=&apos;</xsl:text>
        <xsl:value-of select="@ref"/>
        <xsl:text>&apos;&gt;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&lt;/a&gt;</xsl:text>
        <xsl:text>&lt;/button&gt;</xsl:text>
    </xsl:template>

    <!-- data balloons for seg element -->
    <xsl:template match="seg">
        <xsl:text>&lt;button data-balloon-pos="up" data-balloon-length="large" data-balloon="</xsl:text>
        <xsl:variable name="interp_id" select="current()/@xml:id"/>
        <xsl:if test="$interp_id eq current()/substring-after(following-sibling::note[1]/@target, '#')">
            <xsl:if test="following-sibling::note[1]/p">
                <xsl:value-of disable-output-escaping="yes" select="following-sibling::note[1]/p/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
            </xsl:if>
            <xsl:if test="following-sibling::note[1]/quote">
                <xsl:text>&apos;</xsl:text>
                <xsl:value-of disable-output-escaping="yes" select="following-sibling::note[1]/quote/replace(replace(replace(replace(., '-', '—'), '\s+', ' '), $doubleQuotePat, $doubleQuoteRep), $singleQuotePat, $singleQuoteRep)"/>
                <xsl:text>&apos;</xsl:text>
            </xsl:if>
            <xsl:if test="following-sibling::note[1]/ref/text()"> <!-- if note has text in ref element -->
                <xsl:text> | From: </xsl:text>
                <xsl:value-of select="following-sibling::note[1]//ref"/> <!-- grab text and -->
                <xsl:text>&quot;&gt; &lt;a href=&quot;</xsl:text>
                <xsl:value-of select="following-sibling::note[1]//ref/@target"/> <!-- include link -->
                <xsl:text>&quot;&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&lt;/a&gt; &lt;/button&gt;</xsl:text>
            </xsl:if>
            <xsl:if test="following-sibling::note[1][not(ref)]"> <!-- if note has no child ref, close double quote -->
                <xsl:text>&quot;&gt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&lt;/button&gt;</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="//note[not(@type='letterhead')]"/> <!-- ignore text of editorial notes -->
    <xsl:template match="//standOff"/> <!-- ignore standOff element -->

</xsl:stylesheet>
