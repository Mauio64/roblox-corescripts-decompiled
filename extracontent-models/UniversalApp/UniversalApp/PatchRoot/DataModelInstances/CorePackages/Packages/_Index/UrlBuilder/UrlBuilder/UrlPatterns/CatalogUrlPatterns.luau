return function(p1) -- line: 3
	local t1 = {}

	t1.info = {
		webbundle = p1.fromString("www:bundles/{assetId}"),
		webasset = p1.fromString("www:catalog/{assetId}"),
		webpage = function(p2) -- line: 10
			-- upvalues: t1 (copy)
			if p2.assetType == "Bundle" then
				return t1.info.webbundle(p2)
			end

			if p2.assetType == "Asset" then
				return t1.info.webasset(p2)
			end

			warn(string.format("%s - unknown assetType of %s", tostring(script.name), (tostring(p2.assetType))))

			return nil
		end,
		appsflyer = function(p3) -- line: 20
			-- upvalues: p1 (copy), t1 (copy)
			return p1.fromString("appsflyer:Ebh5?pid=share&is_retargeting=true&af_dp={mobileUrl}&af_web_dp={webUrl}")({
				mobileUrl = p1.fromString("mobilenav:item_details?itemId={assetId}&itemType={assetType}")(p3),
				webUrl = t1.info.webpage(p3)
			})
		end
	}

	return t1
end
