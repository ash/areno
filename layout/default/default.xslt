<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/page">
    <html>
        <head>
            <title>Default page</title>
        </head>
        <body>
            <h1>
                <xsl:value-of select="manifest/date/@rfc"/>
            </h1>
            <xsl:apply-templates select="content"/>
        </body>
    </html>
</xsl:template>

<xsl:template match="content/test">
    <p>
        <xsl:value-of select="text()"/>
    </p>
</xsl:template>

</xsl:stylesheet>
