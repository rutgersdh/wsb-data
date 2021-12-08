<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">
    
    <!-- identity transform: -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="teiHeader">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <xsl:element name="standOff">
            <listPerson>
                <xsl:for-each-group select="//body//persName" group-by="@key">
                    <xsl:sort select="current-grouping-key()"/>
                    <xsl:variable name="names" select="tokenize(lower-case(normalize-space(@key)), '\W+')" />
                    <xsl:variable name="names_upper" select="tokenize(normalize-space(@key), '\W+')"/>
                    <person xml:id="psn-{string-join((substring($names[2], 1, 1), substring($names[3], 1, 1), substring($names[1], 1, 3)), '')}">
                        <persName type="display"><xsl:value-of select="normalize-space(string-join(($names_upper[position() gt 1], $names_upper[position() eq 1]), ' '))"/></persName>
                        <persName type="sort"><xsl:value-of select="normalize-space(@key)"/></persName>
                        <state><p><xsl:value-of select="@role"/></p></state>
                        <birth when-custom="{@from | @from-iso}"><xsl:value-of select="@from | @from-iso"/></birth>
                        <death when-custom="{@to | @to-iso}"><xsl:value-of select="@to | @to-iso"/></death>
                        <note>
                            <xsl:if test="@ref">
                                <list type="links">
                                    <item>
                                        <ref target="{@ref}"><title/></ref>
                                    </item>
                                </list>
                            </xsl:if>
                        </note>
                    </person>
                </xsl:for-each-group>
            </listPerson>
            <listPlace>
                <xsl:for-each-group select="//body//placeName" group-by="@key">
                    <xsl:sort select="current-grouping-key()"/>
                    <xsl:variable name="place_names" select="tokenize(lower-case(normalize-space(@key)), '\W+')" />
                    <place xml:id="pla-{string-join((substring($place_names[1], 1, 5), substring($place_names[2], 1, 2), substring($place_names[3], 1, 1)), '')}"> 
                        <placeName>
                            <xsl:value-of select="@key"/>
                        </placeName>
                        <location>
                            <geo sameAs="{@ref}"></geo>
                        </location>
                        <note/>
                    </place>
                </xsl:for-each-group>
            </listPlace>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>