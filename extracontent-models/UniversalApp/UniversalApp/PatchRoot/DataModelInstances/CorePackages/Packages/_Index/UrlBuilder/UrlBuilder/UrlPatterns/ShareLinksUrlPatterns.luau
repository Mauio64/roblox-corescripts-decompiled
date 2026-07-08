return function(p1) -- line: 7
	return {
		appsflyer = function(s1: string, s2: string) -- line: 10
			-- upvalues: p1 (copy)
			local t1 = {
				linkId = s1,
				linkType = s2
			}
			local v5 = p1.fromString("mobilenav:share_links?code={linkId}&type={linkType}")(t1)
			local v6 = p1.fromString("www:share-links?code={linkId}&type={linkType}")(t1)

			return p1.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = v5,
				webUrl = v6
			})
		end,
		shortUrl = function(t2: {[any]: any}) -- line: 25
			-- upvalues: p1 (copy)
			return p1.fromString("www:share?code={linkId}&type={type}&stamp={stamp|}")(t2)
		end
	}
end
