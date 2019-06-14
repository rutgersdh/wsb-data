<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <title>Schematron constraints for the Rutgers War Service Bureau correspondence</title>
    <ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>

    <pattern>
        <rule context="tei:TEI//@who | tei:TEI//tei:note/@target | tei:TEI//tei:note/@resp | tei:TEI//tei:div/@decls">
            <assert test="starts-with(., '#')">
                ERROR: The @who, @target and @resp (inside note), and @decls (inside div) attributes must begin with a hashtag
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:publicationStmt/child::tei:idno">
            <assert test="@type">
                ERROR: The idno element should have a @type attribute, i.e. @type="URI"
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:correspDesc">
            <assert test="@xml:id">
                ERROR: Every correspDesc element must have an @xml:id attribute formed with the filename and the letter number separated by an underscore, i.e. voorheesjb_01 is letter #1 in the voorheesjb file
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:interp">
            <assert test="@xml:id">
                ERROR: Every interp element must have an @xml:id attribute
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:correspDesc | tei:interp">
            <report test="matches(@xml:id, '\s+')">
                ERROR: @xml:id values may NOT contain white spaces!
            </report>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:div">
            <assert test="@type">
                ERROR: The div element should have a @type attribute, i.e. @type="letter"
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:pb">
            <assert test="@n">
                ERROR: Please include an @n attribute with the page number
            </assert>
<!--            <assert test="@facs">
                ERROR: Please include the @facs attribute with a relative path to your images file, i.e. "images/rucore00000002350_01.png"
            </assert>
            <assert test="ends-with(@facs, '.png')">
                All @facs values must point to a locally stored image with the file extension .png
            </assert>-->
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:TEI/tei:text/tei:body/tei:div//tei:placeName/@ref | tei:TEI/tei:text/tei:body/tei:div//tei:persName/@ref">
            <assert test="starts-with(.,'http:') or starts-with(.,'https:')">
                ERROR: All @ref attributes must point to a public URL beginning with http: or https:
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:TEI//tei:note">
            <assert test="@type">
                ERROR: All note elements must contain a @type attribute, e.g. "letterhead", "annotation", or "gloss"
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:TEI/tei:text/tei:body/tei:div//tei:persName | tei:TEI/tei:text/tei:body/tei:div//tei:placeName">
            <assert test="@key">
                ERROR: All persName and placeName elements need a @key attribute, which contains a regularized version of their
                name, i.e. Lastname, Firstname, or location, i.e., New Brunswick, New Jersey
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:correspAction">
            <assert test="@type">
                ERROR: All correspAction elements must contain a @type attribute containing, e.g., "sent", "received", or "transmitted"
            </assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="tei:date">
            <assert test="@when">
                ERROR: All date elements must contain a @when attribute with an ISO 8601 formated date, e.g. YYYY-MM-DD
            </assert>
        </rule>
    </pattern>
</schema>
