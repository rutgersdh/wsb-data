<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 23, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b> Francesca</xd:p>
            <xd:p>This stylesheet takes any single letter anthology in the War Service Bureau project and generates a table of the people mentioned in the letters, absent the correspondents themselves.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Create a variable identifying the correpondents in the file. We'll filter these folks out later.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="correspondentsIds" select="distinct-values(/TEI/teiHeader//correspDesc//persName/@ref) ! tokenize(normalize-space(.), '\s') ! substring-after(., '#')"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Create an HTML document with a table and table header.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <html>
            <head>War Service Bureau</head>
            <body>
                <div>
                    <br/>        
                    <section id="table">
                        <br/>
                        <h3>Information about People Mentioned in the Letters of <xsl:value-of select="//teiHeader//title"/></h3>
                        <table>
                            <tr>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Birth and Death Dates</th>
                                <th>Source</th>
                            </tr>
                            <xsl:apply-templates select="//listPerson" mode="table"/>
                        </table>
                    </section>      
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Populate the rows of the table. Note that we filter out the correspondents with an if test. Some folks have multiple sources in the <xd:gi>listPerson</xd:gi> element, so a for loop is added to handle those.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="person" mode="table">
        <xsl:if test="not(@xml:id = $correspondentsIds)">
        <tr>
            <td>
                <xsl:value-of select="normalize-space(persName[@type eq 'display'])" />      
            </td>
            <td>
                <xsl:value-of select="normalize-space(state)" />
            </td>
            <td>
                <xsl:value-of select="birth | death" separator=" - "/>
            </td>
            <td>
                <xsl:for-each select="note//item">
                    <xsl:choose>
                    <xsl:when test="position() eq 1">
                        <a href="{ref/@target}"><xsl:value-of select="ref/title"/></a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> | </xsl:text>
                        <a href="{ref/@target}"><xsl:value-of select="ref/title"/></a>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </td>
        </tr>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>