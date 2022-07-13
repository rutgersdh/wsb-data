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
            <xd:p><xd:b>Created on:</xd:b> Dec 30, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> Francesca Giannetti</xd:p>
            <xd:p>This stylesheet will create a .js file with a FeatureCollection of LineStrings for use in Leaflet. I can't get the position stuff to work for some reason, so the end of the file needs to be fixed manually. Still infinitely better than assembly by hand.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Output is text. Strip space is a nostrum and I have no idea if it is doing anything.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:strip-space elements="*"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Create a variable named correspLines. This part only needs to be included once at the top of the file.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:text>var correspLines = { "type": "FeatureCollection", 
        "features": [
        </xsl:text>
        <xsl:apply-templates select="//correspDesc"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Loop through all the letters and grab the location information for senders and recipients. Lines are formed by putting sender coords first, followed by recipient coords. If a location is unknown, then nothing will be grabbed and the line should be deleted manually.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="//correspDesc">
        <xsl:variable name="letterId" select="@xml:id"/>
            <xsl:variable name="senderLocId" select="correspAction[@type='sent']/placeName/@ref/substring-after(., '#')"/>
            <xsl:variable name="recipientLocId" select="correspAction[@type='received']/placeName/@ref/substring-after(., '#')"/>
        <xsl:variable name="locId" select="ancestor::TEI/standOff/listPlace/place/@xml:id"/>
        <xsl:for-each-group select="$letterId" group-by="$letterId">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:choose>
                <xsl:when test="$senderLocId = $locId [position() lt last()]"> 
                <xsl:variable name="senderCoords" select="tokenize(normalize-space(ancestor::TEI//place[@xml:id = $senderLocId]/location/geo), '\s+')" />
                <xsl:text>{"type": "Feature",
                                    "geometry": {
                                    "type": "LineString",
                                    "coordinates": [[</xsl:text>
                <xsl:value-of select="$senderCoords[2]"/><xsl:text>, </xsl:text>
                <xsl:value-of select="$senderCoords[1]"/><xsl:text>],</xsl:text>
                <xsl:if test="$recipientLocId = $locId">
                    <xsl:variable name="recipCoords" select="tokenize(normalize-space(ancestor::TEI//place[@xml:id = $recipientLocId]/location/geo), '\s+')"/>
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="$recipCoords[2]"/><xsl:text>, </xsl:text>
                    <xsl:value-of select="$recipCoords[1]"/>
                    <xsl:text>]]},</xsl:text>
                    <xsl:text>"properties": { "name": "</xsl:text>
                    <xsl:value-of select="$letterId"/>
                    <xsl:text>"}</xsl:text>
                    <xsl:text>&#x0a;},</xsl:text>
                </xsl:if>
                </xsl:when>
<!--                <xsl:when test="$senderLocId = $locId [position() eq last()]">
                    <xsl:text>]};</xsl:text>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:text>]};</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>