return function(p)
	local v = {}

	v.info = {
		webbundle = p.fromString("www:bundles/{assetId}"),
		webasset = p.fromString("www:catalog/{assetId}"),
		webpage = function(p2)
			if p2.assetType == "Bundle" then
				return v.info.webbundle(p2)
			end

			if p2.assetType == "Asset" then
				return v.info.webasset(p2)
			end

			warn(string.format("%s - unknown assetType of %s", tostring(script.name), (tostring(p2.assetType))))
			return nil
		end,
		appsflyer = function(p2)
			return p.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = p.fromString("mobilenav:item_details?itemId={assetId}&itemType={assetType}")(p2),
				webUrl = v.info.webpage(p2)
			})
		end
	}

	return v
end
