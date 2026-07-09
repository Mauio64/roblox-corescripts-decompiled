local Modules = script:FindFirstAncestor("DiscoveryMonolith").Modules
local SetHomePageUpsellCardVariation = require(Modules.LuaApp.Actions.SetHomePageUpsellCardVariation)

return function(p1, p2) -- line: 5
	-- upvalues: SetHomePageUpsellCardVariation (copy)
	local v5 = p1 or {
		upsellCardType = "",
		titleTextOverride = "",
		bodyTextOverride = "",
		upsellCardV2Config = nil
	}

	if p2.type == SetHomePageUpsellCardVariation.name then
		v5 = {
			upsellCardType = p2.upsellCardType,
			titleTextOverride = p2.titleTextOverride,
			bodyTextOverride = p2.bodyTextOverride,
			upsellCardV2Config = p2.upsellCardV2Config
		}
	end

	return v5
end
