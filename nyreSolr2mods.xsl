<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 23, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> thc4</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="response">
        <xsl:apply-templates select="result"/>
    </xsl:template>
    <xsl:template match="result">
        <!-- create group for each set of doc elements with the same access_id -->
        <xsl:apply-templates select="doc"/>
    </xsl:template>
    <xsl:template match="doc">
        <!-- create list of unique items -->
        <xsl:variable name="item_id" select="str[@name = 'call_number']"/>
        <xsl:variable name="names_list" select="distinct-values(arr[@name = 'items']/str)"/>
      <!--  <xsl:message>
            <xsl:for-each select="$names_list">
                <xsl:value-of select="$item_id"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="format-number(position(),'000')"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
        </xsl:message>
        -->
        <xsl:result-document
            href="data/mods/{$item_id}_mods.xml">
            <mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
                <mods:identifier type="local">
                    <xsl:value-of select="$item_id"/>
                </mods:identifier>
                <xsl:apply-templates select="arr[@name = 'architects']/str[text()]"/>
                <xsl:apply-templates select="arr[@name = 'owneragents']/str[text()]"/>
                <mods:titleInfo>
                    <mods:title>
                        <xsl:value-of 
                            select="arr[@name = 'addresses']/str[1]"
                        />
                        <xsl:apply-templates select="str[@name = 'project_name'][text()]" mode="title"/>
                    </mods:title>
                </mods:titleInfo>
                <mods:physicalDescription>
                    <mods:form authority="aat" valueURI="http://vocab.getty.edu/aat/300264821">printed ephemera</mods:form>
                    <mods:form authority="marcform">electronic</mods:form>
                    <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
                    <xsl:apply-templates select="str[@name = 'itemcount']"/>
                </mods:physicalDescription>
                <mods:originInfo>
                    <mods:dateIssued>between 1920 and 1979</mods:dateIssued>
                    <mods:dateIssued keydate="yes" point="start" encoding="w3cdtf" qualifier="inferred">1920</mods:dateIssued>
                    <mods:dateIssued point="end" encoding="w3cdtf">1979</mods:dateIssued>
                </mods:originInfo>
                <mods:note><xsl:text>Date based on the earliest and latest date of the New York Real Estate Brochure Collection.</xsl:text></mods:note>
                <mods:language>
                    <mods:languageTerm authority="iso639-2b">eng</mods:languageTerm>
                </mods:language>
                <xsl:apply-templates select="str[@name = 'public_notes']"/>
                <xsl:apply-templates select="str[@name = 'project_name'][text()]" mode="subject"/>
                <xsl:apply-templates
                    select="str[@name = 'state_name'] | str[@name = 'city_name'] | str[@name = 'borough_name']"/>
                <xsl:apply-templates select="arr[@name = 'neighborhoods']/str[text()]"/>
                <mods:subject authority="lcsh">
                    <mods:topic valueURI="http://id.loc.gov/authorities/subjects/sh85017769">Buildings</mods:topic>
                </mods:subject>
                <mods:typeOfResource>still image</mods:typeOfResource>
                <mods:location>
                    <mods:physicalLocation>Avery Architectural &amp; Fine Arts Library, Columbia University</mods:physicalLocation>
                    <mods:physicalLocation authority="marcorg">NNC-A</mods:physicalLocation>
                    <mods:url access="object in context">
                        <xsl:text>http://nyre.cul.columbia.edu/projects/view/</xsl:text>
                        <xsl:value-of select="str[@name = 'project_id']"/>
                    </mods:url>
                    <mods:holdingSimple>
                        <mods:copyInformation>
                            <mods:subLocation>Avery Classics Collection</mods:subLocation>
                            <mods:shelfLocator><xsl:value-of select="$item_id"/></mods:shelfLocator>
                        </mods:copyInformation>
                    </mods:holdingSimple>
                </mods:location>
                <mods:relatedItem type="host" displayLabel="Project">
                    <mods:titleInfo>
                        <mods:nonSort>The&#xA0;</mods:nonSort>
                        <mods:title>New York Real Estate Brochure Collection</mods:title>
                    </mods:titleInfo>
                    <mods:location>
                        <mods:url>http://www.columbia.edu/cgi-bin/cul/resolve?clio7363386</mods:url>
                    </mods:location>
                </mods:relatedItem>
                <mods:relatedItem type="host" displayLabel="Collection">
                    <mods:titleInfo>
                        <mods:nonSort>The&#xA0;</mods:nonSort>
                        <mods:title>New York real estate brochure collection</mods:title>
                    </mods:titleInfo>
                    <mods:identifier type="CLIO">CLIO_8595802</mods:identifier>
                </mods:relatedItem>
                <mods:recordInfo>
                    <mods:recordIdentifier>
                        <xsl:text>ldpd_</xsl:text>
                        <xsl:value-of select="$item_id"/>
                    </mods:recordIdentifier>
                    <mods:recordCreationDate>
                        <xsl:value-of select="current-dateTime()"/>
                    </mods:recordCreationDate>
                    <mods:recordContentSource authority="marcorg">NNC</mods:recordContentSource>
                    <mods:recordOrigin>Created and edited in general conformance to MODS Guidelines (Version 3).</mods:recordOrigin>
                </mods:recordInfo>
            </mods:mods>
        </xsl:result-document>
        <xsl:apply-templates select="arr[@name = 'items']/str">
            <xsl:with-param name="item_id" select="$item_id"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="arr[@name = 'items']/str">
        <xsl:param name="item_id"/>
        <xsl:variable name="asset_id" select="concat($item_id, '.',format-number(position(), '000'))"/>
        <xsl:result-document
            href="data/mods/{$asset_id}_mods.xml">
            <mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
                <mods:identifier type="local">
                    <xsl:value-of select="$asset_id"/>
                </mods:identifier>
               
                <mods:titleInfo>
                    <mods:title><xsl:value-of select="."/></mods:title>
                </mods:titleInfo>
                <mods:recordInfo>
                    <mods:recordIdentifier>
                        <xsl:text>ldpd_</xsl:text>
                        <xsl:value-of select="$asset_id"/>
                    </mods:recordIdentifier>
                    <mods:recordCreationDate>
                        <xsl:value-of select="current-dateTime()"/>
                    </mods:recordCreationDate>
                    <mods:recordContentSource authority="marcorg">NNC</mods:recordContentSource>
                    <mods:recordOrigin>Created and edited in general conformance to MODS Guidelines (Version 3).</mods:recordOrigin>
                </mods:recordInfo>
            </mods:mods>
        </xsl:result-document>
    </xsl:template>
    <xsl:template
        match="str[@name = 'state_name'] | str[@name = 'city_name'] | str[@name = 'borough_name']">
        <mods:subject>
            <mods:geographic>
                <xsl:value-of select="normalize-space(.)"/>
            </mods:geographic>
        </mods:subject>
    </xsl:template>
    <xsl:template match="arr[@name = 'architects']/str">
        <mods:name>
            <mods:namePart>
                <xsl:value-of select="."/>
            </mods:namePart>
            <mods:role>
                <mods:roleTerm type="code" authority="marcrelator">arc</mods:roleTerm>
                <mods:roleTerm type="text" authority="marcrelator">architect</mods:roleTerm>
            </mods:role>
        </mods:name>
    </xsl:template>
    <xsl:template match="arr[@name = 'owneragents']/str">
        <mods:name>
            <mods:namePart>
                <xsl:value-of select="."/>
            </mods:namePart>
            <mods:role>
                <mods:roleTerm type="text">owner/agent</mods:roleTerm>
            </mods:role>
        </mods:name>
    </xsl:template>
    <xsl:template match="doc/str[@name = 'project_name']" mode="title">
        <xsl:text>&#160;</xsl:text>
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="doc/str[@name = 'project_name']" mode="subject">
        <mods:subject authority="local">
            <xsl:value-of select="."/>
        </mods:subject>
    </xsl:template>
    <xsl:template match="arr[@name = 'neighborhoods']/str">
        <mods:subject>
            <mods:geographic>
                <xsl:value-of select="normalize-space(.)"/>
            </mods:geographic>
        </mods:subject>
    </xsl:template>
    <xsl:template match="str[@name = 'public_notes']">
        <mods:note><xsl:value-of select="."/></mods:note>
    </xsl:template>
    <xsl:template match="str[@name = 'itemcount']">
        <mods:extent><xsl:value-of select="."/><xsl:text> item</xsl:text><xsl:if test=". != '1'"><xsl:text>s</xsl:text></xsl:if></mods:extent>
    </xsl:template>
</xsl:stylesheet>
