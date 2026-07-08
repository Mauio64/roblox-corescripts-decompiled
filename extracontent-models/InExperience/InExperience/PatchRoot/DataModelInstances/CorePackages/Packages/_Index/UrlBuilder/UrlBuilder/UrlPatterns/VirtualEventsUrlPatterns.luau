return function(p1) -- line: 1
	return {
		appsflyer = function(p2) -- line: 4
			-- upvalues: p1 (copy)
			local v3 = p1.fromString("mobilenav:event_details?eventid={eventId}")(p2)
			local v4 = p1.fromString("www:events/{eventId}")(p2)

			return p1.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = v3,
				webUrl = v4
			})
		end
	}
end
