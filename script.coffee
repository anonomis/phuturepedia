j = require("jquery2")
_ = require("lodash")

dataResource = 
  wikipedia: (page) ->
    d = j.Deferred()
    j.ajax { 
      url: "http://en.wikipedia.org/w/api.php?action=parse&page=" + page + "&format=json",
      dataType: 'jsonp'
      success: (data) ->
        d.resolve data.parse.text["*"]        
    }
    return d


dataResource.wikipedia("Stockholm").then ->
  
style = """
.sq {
  position: absolute;
  -webkit-transition: width 0.5s, height 0.5s, left 0.5s, right 0.5s, -webkit-transform 0.5s;
  transition: width 0.5s, height 0.5s, left 0.5s, right 0.5s, transform 0.5s;
}
.top {
  position: absolute;
  top: 0;
  right: 0;
  left: 0;
  height: 5px;
}
.top .line {
  position: absolute;
  top: 3px;
  bottom: 3px;
  right: 3px;
  left: 3px;
  height: 1px;
  background-color: #44a;
}
.bottom {
  position: absolute;
  bottom: 0;
  right: 0;
  left: 0;
  height: 5px;
}
.bottom .line {
  position: absolute;
  bottom: 3px;
  right: 2px;
  left: 3px;
  height: 1px;
  background-color: #44a;
}

.left {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  width: 5px;
}
.left .line {
  position: absolute;
  top: 3px;
  bottom: 3px;
  right: 3px;
  left: 3px;
  width: 1px;
  background-color: #44a;
}
.right {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 5px;
}
.right .line {
  position: absolute;
  top: 3px;
  bottom: 3px;
  right: 3px;
  left: 3px;
  width: 1px;
  background-color: #44a;
}
.content {
  position: absolute;
  bottom: 5px;
  right: 5px;
  left: 5px;
  top: 5px;
  background-color: black;
  overflow-x: hidden;
  padding: 5px;
}
.content img {
  -webkit-filter: grayscale(100%);
}
.infobox {
  clear: right;
  float: right;
}
"""

j("head").append(j("<style/>").html(style))

class Widget
  constructor: () ->
    @id = _.uniqueId("widget")
    @elem = j(@tmpl).attr "id", @id
    @children = []

  find: (selector) ->
    @elem.find(selector)

  child: (widget) ->
    @elem.append(widget.elem)
    @children.push widget

  kill: ->
    @clean()
    @elem.remove()
    @ded = true

  clean: ->
    ch.kill() for ch in @children
    @children = []

  cb: (fn) ->
    console.log "outer", this
    =>
      console.log "inner", this
      unless @ded?
        console.log "do", fn, "arg", arguments
        fn.apply(this, arguments)
      else
        console.warn "You are talking to the dead"


class Box extends Widget
  constructor: (page) ->
    super()
    console.log @
    @getPage "Stockholm"

  getPage: (page) ->
    dataResource.wikipedia(page).then @cb @displayPage

  displayPage: (page) ->
    @find(".content").html(page)


  middle: ->
    @find(".sq").css
      left: "33%"
      right: "33%"
      height: "100%"


  upperLeft: ->
    @find(".sq").css
      left: "0"
      right: "66%"
      height: "33%"

  tmpl: """
      <ctx>
        <div class="sq">
          <div class="top">
            <ctx>
              <div class="line"></div>
            </ctx>
          </div>
          <div class="left">
            <ctx>
              <div class="line"></div>
            </ctx>
          </div>
          <div class="right">
            <ctx>
              <div class="line"></div>
            </ctx>
          </div>
          <div class="bottom">
            <ctx>
              <div class="line"></div>
            </ctx>
          </div>
          <div class="content">
            <div class="hatnote">For other uses, see <a href="/wiki/Stack_overflow_(disambiguation)" title="Stack overflow (disambiguation)" class="mw-disambig">Stack overflow (disambiguation)</a>.</div> <table class="infobox" style="width:22em"><tr><th colspan="2" style="text-align:center;font-size:125%;font-weight:bold">Stack Overflow</th></tr><tr><td colspan="2" style="text-align:center"> <a href="/wiki/File:Stack_Overflow_website_logo.png" class="image"><img alt="Stack Overflow website logo.png" src="//upload.wikimedia.org/wikipedia/en/thumb/9/95/Stack_Overflow_website_logo.png/250px-Stack_Overflow_website_logo.png" width="250" height="66" srcset="//upload.wikimedia.org/wikipedia/en/thumb/9/95/Stack_Overflow_website_logo.png/375px-Stack_Overflow_website_logo.png 1.5x, //upload.wikimedia.org/wikipedia/en/thumb/9/95/Stack_Overflow_website_logo.png/500px-Stack_Overflow_website_logo.png 2x" data-file-width="885" data-file-height="233" /></a></td></tr><tr><td colspan="2" style="text-align:center"> <a href="/wiki/File:Stack_Overflow_homepage.png" class="image"><img alt="Stack Overflow homepage.png" src="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Stack_Overflow_homepage.png/300px-Stack_Overflow_homepage.png" width="300" height="158" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Stack_Overflow_homepage.png/450px-Stack_Overflow_homepage.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Stack_Overflow_homepage.png/600px-Stack_Overflow_homepage.png 2x" data-file-width="2560" data-file-height="1352" /></a><div>Screenshot of Stack Overflow as of February 2015</div></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;"><a href="/wiki/Uniform_resource_locator" title="Uniform resource locator">Web&#160;address</a></th><td> <span class="url"><a rel="nofollow" class="external text" href="https://stackoverflow.com">stackoverflow<wbr/>.com</a></span></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Commercial?</th><td> Yes</td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;"><div style="padding:0.1em 0;line-height:1.2em;">Type of site</div></th><td> <a href="/wiki/Category:Knowledge_markets" title="Category:Knowledge markets">Knowledge markets</a></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Registration</th><td> Optional; Uses <a href="/wiki/OpenID" title="OpenID">OpenID</a></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Available&#160;in</th><td> <a href="/wiki/English_language" title="English language">English</a></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;"><div style="padding:0.1em 0;line-height:1.2em;">Content license</div></th><td> <a href="/wiki/CC-BY-SA_3.0" title="CC-BY-SA 3.0" class="mw-redirect">CC-BY-SA 3.0</a> (for user contributions)</td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Written&#160;in</th><td> <a href="/wiki/ASP.NET" title="ASP.NET">ASP.NET</a><sup id="cite_ref-roadchap_1-0" class="reference"><a href="#cite_note-roadchap-1"><span>[</span>1<span>]</span></a></sup></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Owner</th><td> Stack Exchange, Inc.</td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Created&#160;by</th><td> <a href="/wiki/Joel_Spolsky" title="Joel Spolsky">Joel Spolsky</a> and <a href="/wiki/Jeff_Atwood" title="Jeff Atwood">Jeff Atwood</a></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Launched</th><td> 15 September 2008<sup id="cite_ref-launches_2-0" class="reference"><a href="#cite_note-launches-2"><span>[</span>2<span>]</span></a></sup></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;"><div style="padding:0.1em 0;line-height:1.2em;"><a href="/wiki/Alexa_Internet" title="Alexa Internet">Alexa</a> rank</div></th><td> <img alt="negative increase" src="//upload.wikimedia.org/wikipedia/commons/thumb/5/59/Increase_Negative.svg/11px-Increase_Negative.svg.png" width="11" height="11" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/5/59/Increase_Negative.svg/17px-Increase_Negative.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/5/59/Increase_Negative.svg/22px-Increase_Negative.svg.png 2x" data-file-width="300" data-file-height="300" /> 58 (February 2015<sup class="plainlinks noprint asof-tag update" style="display:none;"><a class="external text" href="//en.wikipedia.org/w/index.php?title=Stack_Overflow&amp;action=edit">&#91;update&#93;</a></sup>)<sup id="cite_ref-alexa_3-0" class="reference"><a href="#cite_note-alexa-3"><span>[</span>3<span>]</span></a></sup></td></tr><tr><th scope="row" style="text-align:left;padding-right:0.65em;">Current&#160;status</th><td> Online</td></tr></table> <p><b>Stack Overflow</b> is a privately held <a href="/wiki/Website" title="Website">website</a>, the flagship site of the <a href="/wiki/Stack_Exchange_Network" title="Stack Exchange Network" class="mw-redirect">Stack Exchange Network</a>,<sup id="cite_ref-growthmodel_4-0" class="reference"><a href="#cite_note-growthmodel-4"><span>[</span>4<span>]</span></a></sup><sup id="cite_ref-Legal_5-0" class="reference"><a href="#cite_note-Legal-5"><span>[</span>5<span>]</span></a></sup><sup id="cite_ref-stackapps_legal_6-0" class="reference"><a href="#cite_note-stackapps_legal-6"><span>[</span>6<span>]</span></a></sup> created in 2008 by <a href="/wiki/Jeff_Atwood" title="Jeff Atwood">Jeff Atwood</a> and <a href="/wiki/Joel_Spolsky" title="Joel Spolsky">Joel Spolsky</a>,<sup id="cite_ref-introducing_7-0" class="reference"><a href="#cite_note-introducing-7"><span>[</span>7<span>]</span></a></sup><sup id="cite_ref-8" class="reference"><a href="#cite_note-8"><span>[</span>8<span>]</span></a></sup> as a more open alternative to earlier Q&amp;A sites such as <a href="/wiki/Experts-Exchange" title="Experts-Exchange">Experts-Exchange</a>. The name for the website was chosen by voting in April 2008 by readers of <i>Coding Horror</i>, Atwood's popular programming blog.<sup id="cite_ref-help_name_9-0" class="reference"><a href="#cite_note-help_name-9"><span>[</span>9<span>]</span></a></sup> </p><p>It features questions and answers on a wide range of topics in <a href="/wiki/Computer_programming" title="Computer programming">computer programming</a>.<sup id="cite_ref-secrets_10-0" class="reference"><a href="#cite_note-secrets-10"><span>[</span>10<span>]</span></a></sup><sup id="cite_ref-slashdot_11-0" class="reference"><a href="#cite_note-slashdot-11"><span>[</span>11<span>]</span></a></sup><sup id="cite_ref-google-tech-talks_12-0" class="reference"><a href="#cite_note-google-tech-talks-12"><span>[</span>12<span>]</span></a></sup> The website serves as a platform for users to ask and answer questions, and, through membership and active participation, to vote questions and answers up or down and edit questions and answers in a fashion similar to a <a href="/wiki/Wiki" title="Wiki">wiki</a> or <a href="/wiki/Digg" title="Digg">Digg</a>.<sup id="cite_ref-fashion_13-0" class="reference"><a href="#cite_note-fashion-13"><span>[</span>13<span>]</span></a></sup> Users of Stack Overflow can earn <a href="/wiki/Trust_metric" title="Trust metric">reputation points</a> and "badges"; for example, a person is awarded 10 reputation points for receiving an "up" vote on an answer given to a question, and can receive badges for their valued contributions,<sup id="cite_ref-soFAQ_14-0" class="reference"><a href="#cite_note-soFAQ-14"><span>[</span>14<span>]</span></a></sup> which represents a kind of <a href="/wiki/Gamification" title="Gamification">gamification</a> of the traditional <a href="/wiki/Q%26A_site" title="Q&amp;A site" class="mw-redirect">Q&amp;A site</a> or forum. All <a href="/wiki/User-generated_content" title="User-generated content">user-generated content</a> is licensed under a <a href="/wiki/CC-BY-SA_3.0" title="CC-BY-SA 3.0" class="mw-redirect">Creative Commons Attribute-ShareAlike</a> license.<sup id="cite_ref-15" class="reference"><a href="#cite_note-15"><span>[</span>15<span>]</span></a></sup> Questions are closed in order to allow low quality questions to improve. Jeff Atwood stated in 2010 that duplicate questions are not seen as a problem but rather they constitute an advantage if such additional questions drive extra traffic to the site by <a href="/wiki/Search_engine_optimization" title="Search engine optimization">multiplying relevant keyword hits in search engines</a>.<sup id="cite_ref-16" class="reference"><a href="#cite_note-16"><span>[</span>16<span>]</span></a></sup> </p> As of April 2014<sup class="plainlinks noprint asof-tag update" style="display:none;"><a class="external text" href="//en.wikipedia.org/w/index.php?title=Stack_Overflow&amp;action=edit">&#91;update&#93;</a></sup>, Stack Overflow has over 2,700,000 registered users and more than 7,100,000 questions.<sup id="cite_ref-soUSERS_17-0" class="reference"><a href="#cite_note-soUSERS-17"><span>[</span>17<span>]</span></a></sup><sup id="cite_ref-soQUESTIONS_18-0" class="reference"><a href="#cite_note-soQUESTIONS-18"><span>[</span>18<span>]</span></a></sup> Based on the type of <a href="/wiki/Tag_(metadata)" title="Tag (metadata)">tags</a> assigned to questions, the top eight most discussed topics on the site are: <a href="/wiki/Java_(programming_language)" title="Java (programming language)">Java</a>, <a href="/wiki/JavaScript" title="JavaScript">JavaScript</a>, <a href="/wiki/C_Sharp_(programming_language)" title="C Sharp (programming language)">C#</a>, <a href="/wiki/PHP" title="PHP">PHP</a>, <a href="/wiki/Android_(operating_system)" title="Android (operating system)">Android</a>, <a href="/wiki/JQuery" title="JQuery">jQuery</a>, <a href="/wiki/Python_(programming_language)" title="Python (programming language)">Python</a> and <a href="/wiki/HTML" title="HTML">HTML</a>.<sup id="cite_ref-tags_19-0" class="reference"><a href="#cite_note-tags-19"><span>[</span>19<span>]</span></a></sup><ol class="references"> <li id="cite_note-roadchap"><span class="mw-cite-backlink"><b><a href="#cite_ref-roadchap_0">^</a></b></span> <strong class="error mw-ext-cite-error">Cite error: The named reference <code>roadchap</code> was invoked but never defined (see the <a href="/wiki/Help:Cite_errors/Cite_error_references_no_text" title="Help:Cite errors/Cite error references no text">help page</a>). </strong></li> <li id="cite_note-launches-2"><span class="mw-cite-backlink"><b><a href="#cite_ref-launches_2-0">^</a></b></span> <span class="reference-text"><span class="citation web">Spolsky, Joel (2008-09-15). <a rel="nofollow" class="external text" href="http://www.joelonsoftware.com/items/2008/09/15.html">"Stack Overflow Launches"</a>. Joel on Software<span class="reference-accessdate">. Retrieved <span class="nowrap">2014-07-07</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.aulast=Spolsky%2C+Joel&amp;rft.au=Spolsky%2C+Joel&amp;rft.btitle=Stack+Overflow+Launches&amp;rft.date=2008-09-15&amp;rft.genre=book&amp;rft_id=http%3A%2F%2Fwww.joelonsoftware.com%2Fitems%2F2008%2F09%2F15.html&amp;rft.pub=Joel+on+Software&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-alexa-3"><span class="mw-cite-backlink"><b><a href="#cite_ref-alexa_3-0">^</a></b></span> <span class="reference-text"><span class="citation web"><a rel="nofollow" class="external text" href="http://www.alexa.com/siteinfo/stackoverflow.com">"Stackoverflow.com Site Info"</a>. <a href="/wiki/Alexa_Internet" title="Alexa Internet">Alexa Internet</a><span class="reference-accessdate">. Retrieved <span class="nowrap">2014-09-27</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.btitle=Stackoverflow.com+Site+Info&amp;rft.genre=book&amp;rft_id=http%3A%2F%2Fwww.alexa.com%2Fsiteinfo%2Fstackoverflow.com&amp;rft.pub=Alexa+Internet&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-growthmodel-4"><span class="mw-cite-backlink"><b><a href="#cite_ref-growthmodel_4-0">^</a></b></span> <span class="reference-text"><span class="citation journal">Sewak, M.; et al. (18 May 2010). <a rel="nofollow" class="external text" href="http://www.stanford.edu/class/ee204/Publications/Finding%20a%20Growth%20Business%20Model%20at%20Stack%20Overflow.pdf">"Finding a Growth Business Model at Stack Overflow, Inc."</a>. <i>Stanford CasePublisher</i> (Stanford University School of Engineering). Rev. 20 July 2010 (2010-204-1). 204-2010-1<span class="reference-accessdate">. Retrieved <span class="nowrap">23 May</span> 2014</span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Finding+a+Growth+Business+Model+at+Stack+Overflow%2C+Inc.&amp;rft.au=et+al.&amp;rft.aufirst=M.&amp;rft.aulast=Sewak&amp;rft.au=Sewak%2C+M.&amp;rft.date=18+May+2010&amp;rft.genre=article&amp;rft_id=http%3A%2F%2Fwww.stanford.edu%2Fclass%2Fee204%2FPublications%2FFinding%2520a%2520Growth%2520Business%2520Model%2520at%2520Stack%2520Overflow.pdf&amp;rft.issue=2010-204-1&amp;rft.jtitle=Stanford+CasePublisher&amp;rft.pub=Stanford+University+School+of+Engineering&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.volume=Rev.+20+July+2010" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-Legal-5"><span class="mw-cite-backlink"><b><a href="#cite_ref-Legal_5-0">^</a></b></span> <span class="reference-text"><span class="citation web"><a rel="nofollow" class="external text" href="https://stackexchange.com/legal">"Stack Exchange Network Legal Links"</a>. <i>Stack Exchange</i><span class="reference-accessdate">. Retrieved <span class="nowrap">2012-01-02</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Stack+Exchange+Network+Legal+Links&amp;rft.genre=article&amp;rft_id=https%3A%2F%2Fstackexchange.com%2Flegal&amp;rft.jtitle=Stack+Exchange&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-stackapps_legal-6"><span class="mw-cite-backlink"><b><a href="#cite_ref-stackapps_legal_6-0">^</a></b></span> <span class="reference-text"><span class="citation web">Stack Overflow Internet Services, Inc. (2010-06-08). <a rel="nofollow" class="external text" href="https://stackexchange.com/legal/terms-of-service">"Stack Exchange API"</a>. <i>Stack Apps</i><span class="reference-accessdate">. Retrieved <span class="nowrap">2010-06-08</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Stack+Exchange+API&amp;rft.aulast=Stack+Overflow+Internet+Services%2C+Inc.&amp;rft.au=Stack+Overflow+Internet+Services%2C+Inc.&amp;rft.date=2010-06-08&amp;rft.genre=article&amp;rft_id=https%3A%2F%2Fstackexchange.com%2Flegal%2Fterms-of-service&amp;rft.jtitle=Stack+Apps&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-introducing-7"><span class="mw-cite-backlink"><b><a href="#cite_ref-introducing_7-0">^</a></b></span> <span class="reference-text"><span class="citation web">Jeff Atwood (2008-04-16). <a rel="nofollow" class="external text" href="http://www.codinghorror.com/blog/archives/001101.html">"Introducing Stackoverflow.com"</a>. <i>Coding Horror</i><span class="reference-accessdate">. Retrieved <span class="nowrap">2009-03-11</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Introducing+Stackoverflow.com&amp;rft.au=Jeff+Atwood&amp;rft.aulast=Jeff+Atwood&amp;rft.date=2008-04-16&amp;rft.genre=article&amp;rft_id=http%3A%2F%2Fwww.codinghorror.com%2Fblog%2Farchives%2F001101.html&amp;rft.jtitle=Coding+Horror&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-8"><span class="mw-cite-backlink"><b><a href="#cite_ref-8">^</a></b></span> <span class="reference-text"><span class="citation web">Jeff Atwood (2008-09-16). <a rel="nofollow" class="external text" href="http://www.codinghorror.com/blog/archives/001169.html">"None of Us is as Dumb as All of Us"</a>. <i>Coding Horror</i><span class="reference-accessdate">. Retrieved <span class="nowrap">2009-03-11</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=None+of+Us+is+as+Dumb+as+All+of+Us&amp;rft.au=Jeff+Atwood&amp;rft.aulast=Jeff+Atwood&amp;rft.date=2008-09-16&amp;rft.genre=article&amp;rft_id=http%3A%2F%2Fwww.codinghorror.com%2Fblog%2Farchives%2F001169.html&amp;rft.jtitle=Coding+Horror&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-help_name-9"><span class="mw-cite-backlink"><b><a href="#cite_ref-help_name_9-0">^</a></b></span> <span class="reference-text"><span class="citation web">Jeff Atwood (2008-04-06). <a rel="nofollow" class="external text" href="http://blog.codinghorror.com/help-name-our-website/">"Help Name Our Website"</a>. <i>Coding Horror</i><span class="reference-accessdate">. Retrieved <span class="nowrap">2014-07-14</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Help+Name+Our+Website&amp;rft.au=Jeff+Atwood&amp;rft.aulast=Jeff+Atwood&amp;rft.date=2008-04-06&amp;rft.genre=article&amp;rft_id=http%3A%2F%2Fblog.codinghorror.com%2Fhelp-name-our-website%2F&amp;rft.jtitle=Coding+Horror&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-secrets-10"><span class="mw-cite-backlink"><b><a href="#cite_ref-secrets_10-0">^</a></b></span> <span class="reference-text"><span class="citation web">Alan Zeichick (2009-04-15). <a rel="nofollow" class="external text" href="http://www.sdtimes.com/SHORT_TAKES_APRIL_15_2009/About_SHORTTAKES/33403">"Secrets of social site success"</a>. <i><a href="/wiki/SD_Times" title="SD Times">SD Times</a></i><span class="reference-accessdate">. Retrieved <span class="nowrap">2009-04-16</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Secrets+of+social+site+success&amp;rft.au=Alan+Zeichick&amp;rft.aulast=Alan+Zeichick&amp;rft.date=2009-04-15&amp;rft.genre=article&amp;rft_id=http%3A%2F%2Fwww.sdtimes.com%2FSHORT_TAKES_APRIL_15_2009%2FAbout_SHORTTAKES%2F33403&amp;rft.jtitle=SD+Times&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-slashdot-11"><span class="mw-cite-backlink"><b><a href="#cite_ref-slashdot_11-0">^</a></b></span> <span class="reference-text"><span class="citation web"><a rel="nofollow" class="external text" href="http://developers.slashdot.org/article.pl?sid=08/09/16/1910214">"Spolsky's Software Q-and-A Site"</a>. <i>Slashdot</i>. 2008-09-16<span class="reference-accessdate">. Retrieved <span class="nowrap">2009-05-23</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Spolsky%27s+Software+Q-and-A+Site&amp;rft.date=2008-09-16&amp;rft.genre=article&amp;rft_id=http%3A%2F%2Fdevelopers.slashdot.org%2Farticle.pl%3Fsid%3D08%2F09%2F16%2F1910214&amp;rft.jtitle=Slashdot&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-google-tech-talks-12"><span class="mw-cite-backlink"><b><a href="#cite_ref-google-tech-talks_12-0">^</a></b></span> <span class="reference-text"><span class="citation web">Joel Spolsky (2009-04-24). <a rel="nofollow" class="external text" href="http://www.youtube.com/watch?v=NWHfY_lvKIQ">"Google Tech Talks: Learning from StackOverflow.com"</a>. YouTube<span class="reference-accessdate">. Retrieved <span class="nowrap">2009-05-23</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.au=Joel+Spolsky&amp;rft.aulast=Joel+Spolsky&amp;rft.btitle=Google+Tech+Talks%3A+Learning+from+StackOverflow.com&amp;rft.date=2009-04-24&amp;rft.genre=book&amp;rft_id=http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DNWHfY_lvKIQ&amp;rft.pub=YouTube&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-fashion-13"><span class="mw-cite-backlink"><b><a href="#cite_ref-fashion_13-0">^</a></b></span> <span class="reference-text"><span class="citation web">Jeff Atwood (2008-09-21). <a rel="nofollow" class="external text" href="http://www.codinghorror.com/blog/2011/10/the-gamification.html">"The Gamification"</a>. <i>Coding Horror Blog</i><span class="reference-accessdate">. Retrieved <span class="nowrap">2011-01-24</span></span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=The+Gamification&amp;rft.au=Jeff+Atwood&amp;rft.aulast=Jeff+Atwood&amp;rft.date=2008-09-21&amp;rft.genre=article&amp;rft_id=http%3A%2F%2Fwww.codinghorror.com%2Fblog%2F2011%2F10%2Fthe-gamification.html&amp;rft.jtitle=Coding+Horror+Blog&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-soFAQ-14"><span class="mw-cite-backlink"><b><a href="#cite_ref-soFAQ_14-0">^</a></b></span> <span class="reference-text"><span class="citation web"><a rel="nofollow" class="external text" href="https://stackoverflow.com/help/whats-reputation">"What is reputation? How do I earn (and lose) it?"</a>. <i>Stack Overflow</i><span class="reference-accessdate">. Retrieved <span class="nowrap">14 August</span> 2010</span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=What+is+reputation%3F+How+do+I+earn+%28and+lose%29+it%3F&amp;rft.genre=article&amp;rft_id=https%3A%2F%2Fstackoverflow.com%2Fhelp%2Fwhats-reputation&amp;rft.jtitle=Stack+Overflow&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-15"><span class="mw-cite-backlink"><b><a href="#cite_ref-15">^</a></b></span> <span class="reference-text"><a rel="nofollow" class="external text" href="http://wiki.creativecommons.org/Case_Studies/StackOverflow.com">Creativecommons.org</a></span> </li> <li id="cite_note-16"><span class="mw-cite-backlink"><b><a href="#cite_ref-16">^</a></b></span> <span class="reference-text"><a rel="nofollow" class="external free" href="http://blog.stackoverflow.com/2010/11/dr-strangedupe-or-how-i-learned-to-stop-worrying-and-love-duplication/">http://blog.stackoverflow.com/2010/11/dr-strangedupe-or-how-i-learned-to-stop-worrying-and-love-duplication/</a></span> </li> <li id="cite_note-soUSERS-17"><span class="mw-cite-backlink"><b><a href="#cite_ref-soUSERS_17-0">^</a></b></span> <span class="reference-text"><span class="citation web"><a rel="nofollow" class="external text" href="https://stackoverflow.com/users">"Users"</a>. <i>Stack Overflow</i><span class="reference-accessdate">. Retrieved <span class="nowrap">15 April</span> 2014</span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Users&amp;rft.genre=article&amp;rft_id=https%3A%2F%2Fstackoverflow.com%2Fusers&amp;rft.jtitle=Stack+Overflow&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-soQUESTIONS-18"><span class="mw-cite-backlink"><b><a href="#cite_ref-soQUESTIONS_18-0">^</a></b></span> <span class="reference-text"><span class="citation web"><a rel="nofollow" class="external text" href="https://stackoverflow.com/questions">"Questions"</a>. <i>Stack Overflow</i><span class="reference-accessdate">. Retrieved <span class="nowrap">15 April</span> 2014</span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Questions&amp;rft.genre=article&amp;rft_id=https%3A%2F%2Fstackoverflow.com%2Fquestions&amp;rft.jtitle=Stack+Overflow&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> <li id="cite_note-tags-19"><span class="mw-cite-backlink"><b><a href="#cite_ref-tags_19-0">^</a></b></span> <span class="reference-text"><span class="citation web"><a rel="nofollow" class="external text" href="https://stackoverflow.com/tags">"Tags"</a>. <i>Stack Overflow</i><span class="reference-accessdate">. Retrieved <span class="nowrap">9 December</span> 2014</span>.</span><span title="ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fen.wikipedia.org%3AStack+Overflow&amp;rft.atitle=Tags&amp;rft.genre=article&amp;rft_id=https%3A%2F%2Fstackoverflow.com%2Ftags&amp;rft.jtitle=Stack+Overflow&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal" class="Z3988"><span style="display:none;">&#160;</span></span></span> </li> </ol>
          </div>
        </div>
      </ctx>
    """
class RootWidget extends Widget
  constructor: () ->
    @id = "app"
    @elem = j("body")
    @children = []

class Orchestrator extends RootWidget
  constructor: ->
    super()
    @makeBox()

  moveUpperLeft: -> =>
    @children[@children.length - 1]?.upperLeft()

  makeBox: ->
    box = new Box()
    @child box
    box.middle()


orchestrator = new Orchestrator()

#clean = -> orchestrator.kill() 
#_.delay clean, 3000
