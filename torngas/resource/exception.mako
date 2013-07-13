<%
    import traceback
    import sys
    import os
    import tornado
    type, value, tback = sys.exc_info()
%>

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <title>HTTP Status ${status_code}  &raquo; Tornado v${ tornado.version }</title>

    <style type="text/css" media="screen">
        body {
            font-family: Helvetica;
            margin: 0;
            padding: 0 4px;
            font-size: 10pt;
            background: #F6F6F6;
        }

        .showtitle {
            background: #e0ebff;
            margin: -5px -5px 20px -5px;
            padding: 20px 10px 10px 10px;
            border-bottom: 1px solid #DDDDDD;
        }

        h1 {

            font-weight: normal;
            /*border-bottom: 1px solid #ff9309;*/
            margin: 0;
            padding: 5px;
        }

        table {
            margin-left: -6px;
            margin-right: -6px;
        }

        .foot {
            border-top: 1px solid rgb(221, 221, 221);
            background: none repeat scroll 0% 0% rgb(238, 238, 238);
            padding: 20px 10px 10px;
            margin: 20px -5px -5px;
        }

        h2 {
            font-weight: normal;
            color: #666666;
            /*border-bottom: 1px solid #ff9309;*/
            margin: 0;
            margin-bottom: 1em;
            padding: 5px;
        }

        h3 {
            border-bottom: 1px solid #eee;
            margin: 0.5em 0;
            padding-bottom: 0.5em;
        }

        hr {
            background: #eee;
            border: none;
            height: 1px;
            margin: 0.25em 0;
        }

        .traceback-frame-header td {
            background: #eee;
            padding: 5px;
            border: 1px solid #DDDDDD;
        }

        .traceback-frame-header h4 {
            cursor: pointer;
            margin: 0;

        }

        .traceback-frame.first .traceback-frame-header td {
            background: #eee;
            border: 1px solid #DDDDDD;

        }

        table td.key {
            background: #dfdfdf;
            padding: 4px 8px;
        }

        table td.value {
            padding: 4px;
            background: #fefefe;
            /*border: 1px solid #dfdfdf;*/
        }

        table td.value.alt {
            background: #fefefe;
        }
    </style>
</head>

<body>

    % if status_code!=404:
        <%
            style='background:#ffc;'
        %>
    % endif
<div class="showtitle" style="${style}">
    <h1>HTTP Status ${ status_code }</h1>

    % if exception :
        <%
            traceback_list = traceback.extract_tb(tback)
        %>
            <h2>Application raised ${ exception.__class__.__name__ }: ${ exception }.</h2>
        <%
            filepath, line, method, code = traceback_list[-1]
        %>
        </div>

        <table class="traceback-frame first">
            <tr class="traceback-frame-header">
                <td width="100%" nowrap>
                <%
                    filp=os.path.basename(filepath)
                %>
                    <h4>on line <span class="line-no">${ line }</span> of <span class="method">${ method }</span>
                        in ${filp}
                    </h4>
                </td>
                <td nowrap>File: <strong>${filepath} </strong></td>
            </tr>
        <tr class="traceback-frame-extended">
        <td colspan="2">
        <%
            extension = os.path.splitext(filepath)[1][1:]
        %>

        % if extension in ['py', 'html', 'htm']:
                <pre class="brush: ${os.path.splitext(filepath)[1][1:]}  ; ruler: true; toolbar: false; smart-tabs: true; first-line: ${ line-4 }; highlight: ${ line };">
                ${get_snippet(filepath, line, 10)|h }

                </pre>
        % else:
                <p>Cannot load file, type not supported.</p>
        % endif
        </td>
        </tr>
        </table>
        <br/>

        <h3>Full Traceback</h3>
        <sup>click each row to view full detail and source code snippet.</sup>

        <div id="full-traceback">
            % for filepath, line, method, code in traceback_list :
            <table class="traceback-frame">
                <tr class="traceback-frame-header">
                    <td width="100%" nowrap>
                        <h4>on line <span class="line-no">${ line }</span> of <span class="method">${ method }</span>
                            in ${os.path.basename(filepath) }</h4>
                    </td>
                    <td nowrap>File: <strong>${ filepath }</strong></td>
                </tr>
            <tr class="traceback-frame-extended">
            <td colspan="2">
                % if os.path.splitext(filepath)[1][1:]  in ['py', 'html', 'htm'] :
                    <pre class="brush: ${ os.path.splitext(filepath)[1][1:] }; ruler: true; toolbar: false; smart-tabs: true; first-line: ${ line-4 }; highlight: ${ line };">
                    ${ get_snippet(filepath, line, 10)|h }
                    </pre>
                % else:
                    <p>Cannot load file, type not supported.</p>
                % endif
            </td>
            </tr>
            </table>
                <br/>
            % endfor
        </div>

        <h3>Request Headers</h3>

        <p>
        <table width="100%">
            % for hk, hv in handler.request.headers.iteritems() :
                <tr>
                    <td class="key" nowrap>${hk} </td>
                    <td class="value" width="100%">${ hv }</td>
                </tr>
            % endfor
        </table>
        </p>

        <br/>

        <h3>Response Headers</h3>

        <p>
        <table width="100%">
            % for hk, hv in handler._headers.iteritems() :
                <tr style="margin:0;padding: 0;border: 0px ">
                    <td class="key" nowrap>${ hk }</td>
                    <td class="value" width="100%">${ hv }</td>
                </tr>
            % endfor
        </table>
        </p>
    % endif
<br/>
<br/>
<hr/>

<p class="foot">
    Powered by Tornado v${ tornado.version } | python ${sys.version}
</p>
<link href="http://alexgorbatchev.com/pub/sh/current/styles/shThemeDefault.css" rel="stylesheet" type="text/css"/>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" type="text/javascript"
        charset="utf-8"></script>
<script src="http://alexgorbatchev.com/pub/sh/current/scripts/shCore.js" type="text/javascript"></script>
<script src="http://alexgorbatchev.com/pub/sh/current/scripts/shBrushPython.js" type="text/javascript"></script>
<script src="http://alexgorbatchev.com/pub/sh/current/scripts/shBrushXml.js" type="text/javascript"></script>
<script type="text/javascript" charset="utf-8">
    SyntaxHighlighter.all();
</script>
<script type="text/javascript" charset="utf-8">
    $(document).ready(function (e) {
        $('#full-traceback .traceback-frame-extended').hide();
        $('#full-traceback .traceback-frame-header').click(function (e) {
            $(e.currentTarget).siblings('.traceback-frame-extended').toggle();
        });
    })
</script>
</body>
</html>