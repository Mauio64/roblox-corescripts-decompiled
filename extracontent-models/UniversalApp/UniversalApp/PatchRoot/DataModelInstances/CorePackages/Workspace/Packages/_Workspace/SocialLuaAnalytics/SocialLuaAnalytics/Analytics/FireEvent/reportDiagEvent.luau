local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local DiagEventTypes = require(SocialLuaAnalytics.Analytics.Enums).DiagEventTypes
local getPlatformSuffix = require(script.Parent.getPlatformSuffix)

require(script.Parent.Parent.Types)

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: getPlatformSuffix (copy), DiagEventTypes (copy)
	return function(p1) -- line: 12
		-- upvalues: getPlatformSuffix (copy), DiagEventTypes (copy), t1 (copy)
		local v6 = `{ p1.name }{ getPlatformSuffix(p1.platformSpecificity) }`

		if p1.type == DiagEventTypes.Stats then
			t1:reportStats(v6, p1.value)

			return p1
		end

		t1:reportCounter(v6, p1.value)

		return p1
	end
end
