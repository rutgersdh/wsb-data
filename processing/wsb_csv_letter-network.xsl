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
            <xd:p><xd:b>Author:</xd:b> Francesca Giannetti</xd:p>
            <xd:p>To turn a letter anthology with correspDesc nodes into a CSV file for network applications.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="text" encoding="UTF-8" />
    
    <xsl:template match="/">
        <xsl:text>letter-id,source-location-id,destination-location-id,date-sent,sender-name,addressee-name</xsl:text>
        <xsl:apply-templates select="//correspDesc"/>
    </xsl:template>
    
    <xsl:template match="correspDesc">
        <xsl:text>&#x0a;</xsl:text>
        <xsl:value-of select="@xml:id"/><xsl:text>,</xsl:text>
        <xsl:value-of select="correspAction[@type='sent']/placeName/@ref/substring-after(., '#')"/><xsl:text>,</xsl:text>
        <xsl:value-of select="correspAction[@type='received']/placeName/@ref/substring-after(., '#')"/><xsl:text>,</xsl:text>
        <xsl:value-of select="correspAction[@type='sent']/date/@when"/><xsl:text>,</xsl:text>
        <xsl:value-of select="correspAction[@type='sent']/persName"/><xsl:text>,</xsl:text>
        <xsl:value-of select="correspAction[@type='received']/persName"/>
    </xsl:template>
</xsl:stylesheet>