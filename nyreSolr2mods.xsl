<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="3.0">
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
        <xsl:variable name="names_list" select="distinct-values(arr[@name = 'items']/str)"/>
        <xsl:result-document href="data/mods/{str[@name = 'call_number']}_mods.xml">
            <mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd">
                <mods:identifier type="local">
                    <xsl:value-of select="str[@name = 'call_number']"/>
                </mods:identifier>
                <!-- name for each unique company name value (company/str) -->
                <!--   <xsl:for-each select="$names_list">
                        <mods:name type="corporate">
                            <mods:namePart>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:namePart>
                        </mods:name>
                    </xsl:for-each>
                    -->
                <!--
                    <mods:name type="personal" authorityURI="http://id.loc.gov/authorities/names"
                        valueURI="http://id.loc.gov/authorities/names/no2010120768">
                        <mods:namePart>Biggert, Robert</mods:namePart>
                        <mods:role>
                            <mods:roleTerm authority="marcrelator" type="text"
                                >Collector</mods:roleTerm>
                        </mods:role>
                        <mods:role>
                            <mods:roleTerm type="code" authority="marcrelator">col</mods:roleTerm>
                        </mods:role>
                    </mods:name>
                    -->
                <!-- take first company name for use in title -->
                <mods:titleInfo>
                    <mods:title>
                        <xsl:value-of select="str[@name = 'project_name']/text()"/>
                        <xsl:value-of select="addresses[following-sibling::str[@name = 'project_name'][not(text())]][1]"/>
                    </mods:title>
                </mods:titleInfo>
                <mods:physicalDescription>
                    <mods:form authority="aat">
                        <xsl:text>XXXXXXXXXX</xsl:text>
                    </mods:form>
                    <mods:digitalOrigin>reformatted digital</mods:digitalOrigin>
                </mods:physicalDescription>
                <!--
                <mods:originInfo>
                    <mods:dateOther>
                        <xsl:value-of select="display_date"/>
                    </mods:dateOther>
                    start/end dates if display_date contains a '-' 
                    <xsl:apply-templates select="display_date[contains(., '-')]"
                        mode="dateRange"/>
                     single key date if display_date does not contains a '-' 
                    <xsl:apply-templates select="display_date[not(contains(., '-'))]"
                        mode="singleDate"/>
                </mods:originInfo>
                -->
                <mods:language>
                    <mods:languageTerm authority="iso639-2b">eng</mods:languageTerm>
                </mods:language>
                <xsl:apply-templates select="str[@name = 'state_name'] | str[@name = 'city_name'] | str[@name = 'borough_name']"></xsl:apply-templates>
                <!-- subject/name for each unique company name value (company/str) -->
          <!--     <xsl:for-each select="$names_list">
                    <mods:subject>
                        <mods:geographic>
                                <xsl:value-of select="normalize-space(.)"/>
                        </mods:geographic>
                    </mods:subject>
                </xsl:for-each>
              -->
                <!-- subject/geographic element for each unique city_state value 
                    <xsl:for-each select="distinct-values(current-group()//city_state/str)">
                        <mods:subject>
                            <mods:geographic>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:geographic>
                        </mods:subject>
                    </xsl:for-each>
                    -->
                <mods:subject authority="lcsh">
                    <mods:topic>Buildings</mods:topic>
                </mods:subject>
                <mods:typeOfResource>still image</mods:typeOfResource>
                <!-- mods:note for each note 
                    <xsl:apply-templates select="current-group()//notes"/>-->
                <!-- relatedItem @constituent = 'part' for each side/str -->
                <!-- Ben does not need/want this -->
                <!-- <xsl:apply-templates select="current-group()//side"/> -->
                <mods:location>
                    <mods:physicalLocation>Avery Architectural &amp; Fine Arts Library, Columbia University</mods:physicalLocation>
                    <mods:physicalLocation authority="marcorg">NNC-A</mods:physicalLocation>
                    <mods:url access="object in context">
                        <xsl:text>https://nyre.cul.columbia.edu/items/view/</xsl:text>
                        <xsl:value-of select="str[@name = 'project_id']"/>
                    </mods:url>
                    <mods:holdingSimple>
                        <mods:copyInformation>
                            <mods:subLocation>Avery Classics Collection</mods:subLocation>
                        </mods:copyInformation>
                    </mods:holdingSimple>
                </mods:location>
                <mods:relatedItem type="host" displayLabel="Project">
                    <mods:titleInfo>
                        <mods:title>The New York Real Estate Brochure Collection</mods:title>
                    </mods:titleInfo>
                    <mods:location>
                        <mods:url>http://www.columbia.edu/cgi-bin/cul/resolve?clio7363386</mods:url>
                    </mods:location>
                </mods:relatedItem>
                <mods:recordInfo>
                    <mods:recordIdentifier>
                        <xsl:text>ldpd_</xsl:text>
                        <xsl:value-of select="access_id"/>
                    </mods:recordIdentifier>
                    <mods:recordCreationDate>
                        <xsl:value-of select="current-dateTime()"/>
                    </mods:recordCreationDate>
                    <mods:recordContentSource authority="marcorg">NNC</mods:recordContentSource>
                    <mods:recordOrigin>Created and edited in general conformance to MODS Guideline (Version 3).</mods:recordOrigin>
                </mods:recordInfo>
            </mods:mods>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="medium/str[. = 'Letter']">
        <xsl:text>correspondence</xsl:text>
    </xsl:template>
    <xsl:template match="medium/str[. != 'Letter']">
        <xsl:text>printed ephemera</xsl:text>
    </xsl:template>
    <xsl:template match="display_date" mode="dateRange">
        <mods:dateOther keyDate="yes" encoding="w3cdtf" point="start">
            <xsl:value-of select="substring-before(., '-')"/>
        </mods:dateOther>
        <mods:dateOther encoding="w3cdtf" point="end">
            <xsl:value-of select="substring-after(., '-')"/>
        </mods:dateOther>
    </xsl:template>
    <xsl:template match="display_date" mode="singleDate">
        <mods:dateOther keyDate="yes" encoding="w3cdtf">
            <xsl:value-of select="."/>
        </mods:dateOther>
    </xsl:template>
    <xsl:template match="notes">
        <mods:note>
            <xsl:value-of select="str"/>
        </mods:note>
    </xsl:template>
    <xsl:template match="side">
        <mods:relatedItem type="constituent">
            <mods:titleInfo>
                <mods:title>
                    <xsl:value-of select="."/>
                </mods:title>
            </mods:titleInfo>
        </mods:relatedItem>
    </xsl:template>
    <xsl:template match="company/str" mode="subject">
        <mods:subject>
            <mods:name type="corporate">
                <mods:namePart>
                    <xsl:value-of select="."/>
                </mods:namePart>
            </mods:name>
        </mods:subject>
    </xsl:template> 
        <xsl:template match="str[@name = 'state_name'] | str[@name = 'city_name'] | str[@name = 'borough_name']">
           <mods:subject>
               <mods:geographic>
                   <xsl:value-of select="normalize-space(.)"/>
               </mods:geographic>
           </mods:subject>
    </xsl:template>

</xsl:stylesheet>
