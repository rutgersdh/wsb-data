<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all">
    
    <xsl:output encoding="UTF-8" method="text"/>
    
    <xsl:template match="/">
        <xsl:text>&lt;div id="subject-filters"&gt;</xsl:text>
        <xsl:text>&#xa;&lt;button class="btn active" role="btn" onclick="filterLetters(&apos;all&apos;)"&gt;All&lt;/button&gt;</xsl:text>
        <xsl:apply-templates select="//keywords"/>
        <xsl:text>&lt;/div&gt;</xsl:text> <!-- close the div -->
    </xsl:template>
    
    <xsl:template match="//keywords">
        <xsl:for-each select="term">
            <xsl:sort select="@xml:id" data-type="text" order="ascending" />
            <xsl:text>&#xa;&lt;button class="btn" role="btn" onclick="filterLetters(&apos;</xsl:text>
            <xsl:value-of select="@xml:id"/>
            <xsl:text>&apos;)"&gt;</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>&lt;/button&gt;</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>