<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
    version="2.0">

    <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <style>
                    
                    .tooltip {
                    display:inline-block;
                    position:relative;
                    border-bottom:1px dotted #666;
                    text-align:left;
                    }
                    
                    .tooltip .top {
                    min-width:200px; 
                    top:-20px;
                    left:50%;
                    transform:translate(-50%, -100%);
                    padding:10px 20px;
                    color:#444444;
                    background-color:#EEEEEE;
                    font-weight:normal;
                    font-size:13px;
                    border-radius:8px;
                    position:absolute;
                    z-index:99999999;
                    box-sizing:border-box;
                    box-shadow:0 1px 8px rgba(0,0,0,0.5);
                    display:none;
                    }
                    
                    .tooltip:hover .top {
                    display:block;
                    }
                    
                    .tooltip .top i {
                    position:absolute;
                    top:100%;
                    left:50%;
                    margin-left:-12px;
                    width:24px;
                    height:12px;
                    overflow:hidden;
                    }
                    
                    .tooltip .top i::after {
                    content:'';
                    position:absolute;
                    width:12px;
                    height:12px;
                    left:50%;
                    transform:translate(-50%,-50%) rotate(45deg);
                    background-color:#EEEEEE;
                    box-shadow:0 1px 8px rgba(0,0,0,0.5);
                    }
                    
                </style>
            </head>
            <body>
                <div style="text-align: center;">
                    <h2>
                        <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/title"/>
                    </h2>
                    <h4>
                        <xsl:value-of
                            select="/TEI/teiHeader/fileDesc/publicationStmt/authority"/>
                        <br/>
                        <xsl:text>URL: </xsl:text>
                        <a href="{/TEI/teiHeader/fileDesc/publicationStmt/idno[@type='URI']}" target="_blank">
                            <xsl:value-of
                                select="/TEI/teiHeader/fileDesc/publicationStmt/idno[@type='URI']"
                            />
                        </a>
                    </h4>
                </div>
                <hr/>
               <xsl:for-each select="/TEI/text/body/div[@type='letter']">
                   <xsl:variable name="current_div" select="."/>
                    <h3>
                        <xsl:variable name="letter_id" select="$current_div/substring-after(@decls, '#')"/>
                        <xsl:for-each select="/TEI/teiHeader/profileDesc/correspDesc">
                            <xsl:variable name="current_correspDesc" select="."/>
                            <xsl:if test="$letter_id eq $current_correspDesc/@xml:id">
                                <xsl:value-of select="$current_correspDesc/correspAction[@type='sent']/persName"/>
                                <xsl:text> to </xsl:text>
                                <xsl:value-of select="$current_correspDesc/correspAction[@type='received']/persName"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="$current_correspDesc/correspAction[@type='sent']/date"/>
                            </xsl:if>
                        </xsl:for-each>
                    </h3>
                    <p id="{@decls}">
                        <xsl:apply-templates/>
                    </p>
                    <hr style="border-top: 1px dotted #8c8b8b;"/>
                </xsl:for-each>
                
                <h3>Key:</h3>
                <ul>
                    <li style="color:blue;text-decoration:none;">Individual</li>
                    <li style="color:#00CC00;text-decoration:none;">Location</li>
                    <li style="color:red;text-decoration:none;">Claim</li>
                </ul>
              
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="head | note[@type='letterhead']">
        <div style="text-align: center;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="opener/dateline">
        <div style="text-align: right;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="opener/salute">
        <div style="text-align: left;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="lb | addrLine">
        <xsl:apply-templates/><br/>
    </xsl:template>
    <xsl:template match="closer/salute">
        <div style="margin-left: 1.5em;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="closer/signed">
        <div style="margin-left: 2.5em;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="unclear">
        <i>
            <xsl:apply-templates/>
            <xsl:text> [?]</xsl:text>
        </i>
    </xsl:template>
    <xsl:template match="del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="persName | name[@type='person']">
        <a style="color:blue;text-decoration:none;" href="{@ref}"
            title="{@key}&#013;({@from | @from-iso}-{@to | @to-iso})&#013;{@role}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="placeName">
        <a style="color:#00CC00;text-decoration:none;" href="{@ref}" title="{@key}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="seg">
        <a style="color:red;text-decoration:none;" class="btn btn-primary tooltip"><xsl:apply-templates/>
            <span class="top">
                <xsl:variable name="interp_id" select="current()/@xml:id"/>
                <xsl:if test="$interp_id eq current()/substring-after(following-sibling::note[1]/@target, '#')">
                    <xsl:if test="following-sibling::note[1]/p">
                        <xsl:value-of select="following-sibling::note[1]/p/text()"/>
                    </xsl:if>
                    <xsl:if test="following-sibling::note[1]/quote">
                        <xsl:text>&apos;</xsl:text>
                        <xsl:value-of select="following-sibling::note[1]/quote/text()"/>
                        <xsl:text>&apos;</xsl:text>
                    </xsl:if>
                </xsl:if>
            </span>
        </a>
    </xsl:template>
    
    <xsl:template match="note[not(@type='letterhead')]"/> <!-- ignore editorial notes -->
    
    <xsl:template match="pb">
        <h4>Page: <xsl:value-of select="@n"/></h4>
        <br/>
    </xsl:template>
</xsl:stylesheet>
