<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="html" />
    <xsl:strip-space elements="*" />        <!-- - Root match -->
    <xsl:template match="/">
        <html>
            <head>
                <title>HTML version of XML resource</title>
                <link rel="stylesheet" type="text/css" href="frs-jaxdoc.css" />
            </head>
            <body>
                <xsl:apply-templates>
                    <xsl:with-param name="indent" select="0" />
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <!-- - Processes XML elements - 
         - param indent indentation count 
         - param ancestorsNamespaces concatenation of all namespace URIs from all parents, 
                                     which is used to determine if a namespace has already 
                                     been declared in 
        - a parent XML element. -->
    <xsl:template match="node()[name()]">


        <xsl:param name="indent" select="0" />
        <xsl:param name="ancestorsNamespaces" select="''" />


        <xsl:variable name="hasChildren" select="count(child::node()) > 0" />
        <xsl:variable name="hasTextNode" select="count(child::text()) > 0" />


        <!-- Format opening of XML element -->
        <xsl:if test="$indent &gt; 0">
            <br />
        </xsl:if>
        <xsl:call-template name="pad">
            <xsl:with-param name="indent" select="$indent * 2" />
        </xsl:call-template>
        <span class="xmlElement">
            &lt;
            <xsl:value-of select="name()" />
        </span>                <!-- Add namespaces to XML element -->
        <xsl:variable name="selfNamespaces">
            <xsl:for-each select="namespace::node()">
                <xsl:value-of select="." />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="hasAttributes" select="count(@*) &gt; 0" />
        <xsl:for-each select="namespace::node()">
            <xsl:if test="contains($ancestorsNamespaces, .) = false()">
                <xsl:if test="position() = 1">
                    &#160;
                </xsl:if>
                <xsl:if test="position() &gt; 1">
                    <br />
                    <xsl:call-template name="pad">
                        <xsl:with-param name="indent"
                            select="($indent+1) * 2" />
                    </xsl:call-template>
                </xsl:if>
                <span class="xmlNamespacePrefix">
                    xmlns:
                    <xsl:value-of select="name()" />
                </span>
                =
                <span class="xmlNamespaceUri">
                    "
                    <xsl:value-of select="." />
                    "
                </span>
                <xsl:if test="position()=last() and $hasAttributes">
                    <br />
                    <xsl:call-template name="pad">
                        <xsl:with-param name="indent"
                            select="($indent+1) * 2" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>                <!-- Add attributes to XML element -->
        <xsl:apply-templates select="@*" />                <!-- Close opening XML element tag, with special handling for element without 
            children node -->
        <span class="xmlElement">
            <xsl:if test="$hasChildren = false()">
                /
            </xsl:if>
            &gt;
        </span>


        <!-- Add children to XML element -->
        <xsl:apply-templates select="node()">
            <xsl:with-param name="indent" select="$indent + 1" />
            <xsl:with-param name="ancestorsNamespaces"
                select="concat($ancestorsNamespaces,$selfNamespaces)" />
        </xsl:apply-templates>


        <!-- Close XML element, but only if not already closed with XML element 
            abbreviation -->
        <xsl:if test="$hasChildren = true()">
            <xsl:if test="$hasTextNode = false()">
                <br />
                <xsl:call-template name="pad">
                    <xsl:with-param name="indent" select="$indent * 2" />
                </xsl:call-template>
            </xsl:if>
            <span class="xmlElement">
                &lt;/
                <xsl:value-of select="name()" />
                &gt;
            </span>
        </xsl:if>


    </xsl:template>


    <!-- - XML text -->
    <xsl:template match="text()">
        <xsl:variable name="nodeValue" select="." />
        <xsl:if test="string-length($nodeValue) > 0">
            <span class="xmlText">
                <xsl:copy-of select="$nodeValue" />
            </span>
        </xsl:if>
    </xsl:template>


    <!-- - XML attributes -->
    <xsl:template match="@*">
        <xsl:if test="position() > 0">
            &#160;
        </xsl:if>
        <span class="xmlAttr">
            <xsl:value-of select="name()" />
        </span>
        =
        <span class="xmlAttrValue">
            "
            <xsl:value-of select="." />
            "
        </span>
    </xsl:template>


    <!-- - Padding for HTML output, used for indentation purposes -->
    <xsl:template name="pad">
        <xsl:param name="indent" select="0" />


        <xsl:if test="$indent > 0">
            &#160;
            <xsl:call-template name="pad">
                <xsl:with-param name="indent" select="$indent - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>