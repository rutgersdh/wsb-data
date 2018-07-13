<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <!-- remember to uncheck box next to "Expand attribute defaults" in Saxon settings in Oxygen before using this transformation -->

    <!-- identity transform: -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- find unique place keys and use them to create a placeography in a back element -->
    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <xsl:element name="back">
            <listPlace>
                <xsl:for-each
                    select="distinct-values(//placeName/@key)">
                    <place>
                        <placeName>
                            <xsl:value-of select="."/>
                        </placeName>
                        <location>
                            <geo>
                                <![CDATA[]<!--Latitude followed by longitude, separated by a white space like this:
              53.226658 -0.541254
              -->]]>
                            </geo>
                        </location>
                    </place>
                </xsl:for-each>
            </listPlace>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
