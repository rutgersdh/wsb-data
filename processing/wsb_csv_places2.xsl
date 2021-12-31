<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> July 17, 2018</xd:p>
            <xd:p><xd:b>Updated on:</xd:b> December 28, 2021 for <gi>standOff</gi>element.</xd:p>
            <xd:p><xd:b>Author:</xd:b> Francesca Giannetti</xd:p>
            <xd:p>To turn a letter anthology with listPlace nodes into a CSV file with locations and coordinates. Formatted for use in D3 + Leaflet.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="text" encoding="UTF-8" />
    
    <xd:doc>
        <xd:desc>
            <xd:p>Create header row with five variables</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:text>location-id,label,latitude,longitude,description</xsl:text>
        <xsl:apply-templates select="//place"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Populate rows with values. Start with carriage return.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="place">
        <xsl:text>&#x0a;</xsl:text>
        <xsl:value-of select="@xml:id"/><xsl:text>,</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="placeName"/><xsl:text>",</xsl:text>
        <xsl:variable name="coords" select="tokenize(normalize-space(location/geo), '\s+')" />
        <xsl:text>"</xsl:text><xsl:value-of select="$coords[1]"/><xsl:text>", "</xsl:text><xsl:value-of select="$coords[2]"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="note/p"/><xsl:text>"</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>