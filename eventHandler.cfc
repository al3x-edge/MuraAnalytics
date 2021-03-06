component name='eventHandler' accessors='true' extends='mura.plugin.pluginGenericEventHandler' output='false' {

  property name='$';

  this.pluginName = 'MuraAnalytics';

  public any function onApplicationLoad(required struct $) {
    // Register all event handlers/listeners of this .cfc with Mura CMS
    variables.pluginConfig.addEventHandler(this);
  }

  public any function onRenderEnd(required struct $){
    var html = '';
    var headHTML = '';
    var contentReplaced = false;
    var newContent = $.event("__MuraResponse__");
    var google_gajs_tracking = variables.pluginConfig.getSetting('GoogleAnalyticsGATrackingID');
    var google_analyticsjs_tracking = variables.pluginConfig.getSetting('GoogleAnalyticsAJTrackingID');
    var google_analyticsjs_extra = variables.pluginConfig.getSetting('GoogleAnalyticsJSExtras');
    var google_webmaster_verification = variables.pluginConfig.getSetting('GoogleWebmasterVerification');

    if(google_webmaster_verification != ''){
      savecontent variable='webmasterverify' { include 'inc/webmaster.cfm'; }
      headHTML &= webmasterverify;
    }

    if(google_gajs_tracking != ''){
      savecontent variable='gajs' { include 'inc/gajs.cfm'; }
      html &= gajs;
    }

    if(google_analyticsjs_tracking != ''){
      savecontent variable='analyticsjs' { include 'inc/analyticsjs.cfm'; }
      headHTML &= analyticsjs;
    }

    if(headHTML != ''){
      newContent = replaceNoCase(newContent, "</head>", headHTML & "</head>");
      contentReplaced = true;
    }

    if(html != ''){
      newContent = replaceNoCase(newContent, "</body>", html & "</body>");
      contentReplaced = true;
    }

    if(contentReplaced == true){
      $.event("__MuraResponse__", newContent);
    }
  }
}
