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
            <xd:p><xd:b>Updated again on:</xd:b> July 6, 2023 to add columns for type, letters, and mentions.</xd:p>
            <xd:p><xd:b>Author:</xd:b> Francesca Giannetti</xd:p>
            <xd:p>To turn a letter anthology with listPlace nodes into a CSV file with locations and coordinates. Formatted for use in D3 + Leaflet. Accompanies the wsb_json_corresplines.xsl for the correspondent edges. A note on the letters column: the XSLT relies upon the information in the <gi>correspAction</gi> to match places to letters. Therefore, if a place is not a correspondent location, but a place mentioned in the body of a letter, this script won't catch it. Encoders are not reliably tagging places within individual letters, so trying to fish out mentions that way will fail. A further note on the mentions column: the XSLT below counts the number of times a place appears as the sender or recipient location. It does not count the number of times a place is mentioned in the text of a letter, which isn't reliably encoded anyway. I'm making a blanket assumption that location mentions only appear once for the dumb reason that the Leaflet map uses math to calculate the area of circle markers and I don't want any multiplication by zero.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="text" encoding="UTF-8" />
    
    <xd:doc>
        <xd:desc>
            <xd:p>Create a variable identifying the correpondent locations in the file. We'll filter for these later.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="correspondentLocationIds" select="distinct-values(/TEI/teiHeader//correspDesc//placeName/@ref) ! tokenize(normalize-space(.), '\s') ! substring-after(., '#')"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Create header row with eight variables</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:text>location-id,label,latitude,longitude,description,type,letters,mentions</xsl:text>
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
        <xsl:text>"</xsl:text><xsl:value-of select="note/p"/><xsl:text>"</xsl:text><xsl:text>,</xsl:text>
        <xsl:choose>
            <xsl:when test="@xml:id = $correspondentLocationIds">
                <xsl:text>"correspondent-location",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"mentioned",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:for-each select="placeName"> <!-\- code that falsely assumed reliably tagged locations in letter texts -\->
            <xsl:variable name="currentplaceName" select="."/>
            <xsl:choose>
                <xsl:when test="count(ancestor::TEI/text/body//placeName[@key = $currentplaceName]/ancestor::div/@decls) eq 1">
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="ancestor::TEI/text/body//placeName[@key = $currentplaceName]/ancestor::div/@decls"/>
                    <xsl:text>",</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>"</xsl:text>
                        <xsl:value-of select="ancestor::TEI/text/body//placeName[@key = $currentplaceName]/ancestor::div/@decls"/>
                        <xsl:text>",</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>-->
          <xsl:for-each select="@xml:id">
            <xsl:variable name="currentplaceId" select="."/>
              <xsl:text>"</xsl:text><xsl:value-of select="ancestor::TEI//correspAction/placeName[substring-after(@ref, '#') eq $currentplaceId]/ancestor::correspDesc/@xml:id"/><xsl:text>",</xsl:text>
            <xsl:choose>
                <xsl:when test="count(ancestor::TEI/teiHeader/profileDesc/correspDesc/correspAction/placeName[substring-after(@ref, '#') = $currentplaceId]) gt 0"> <!-- as long as a place is mentioned once or more -->
                    <!-- count the mentions -->
                    <xsl:text>"</xsl:text><xsl:value-of select="count(ancestor::TEI/teiHeader/profileDesc/correspDesc/correspAction/placeName[substring-after(@ref, '#') = $currentplaceId])"/><xsl:text>"</xsl:text> 
                </xsl:when>
                <xsl:otherwise> <!-- if a place is mentioned zero times, that means it's a mention in the body of the letter and not a correspondent location and we're just going to assume a singular mention for practical reasons -->
                    <xsl:text>"</xsl:text><xsl:value-of select="count(ancestor::TEI/teiHeader/profileDesc/correspDesc/correspAction/placeName[substring-after(@ref, '#') = $currentplaceId]) + 1"/><xsl:text>"</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>