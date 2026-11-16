return function(p)
	return {
		appsflyer = function(linkId: string, linkType: string)
			local v = { linkId = linkId, linkType = linkType }

			local mobileUrl = p.fromString("mobilenav:share_links?code={linkId}&type={linkType}")(v)
			local webUrl = p.fromString("www:share-links?code={linkId}&type={linkType}")(v)
			return p.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = mobileUrl,
				webUrl = webUrl
			})
		end,
		shortUrl = function(p2)
			return p.fromString("www:share?code={linkId}&type={type}&stamp={stamp|}")(p2)
		end
	}
end
