return function(p)
	return {
		appsflyer = function(p2)
			local mobileUrl = p.fromString("mobilenav:event_details?eventid={eventId}")(p2)
			local webUrl = p.fromString("www:events/{eventId}")(p2)
			return p.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = mobileUrl,
				webUrl = webUrl
			})
		end
	}
end
