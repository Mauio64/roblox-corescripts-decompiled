local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local Modules = DiscoveryMonolith.Modules
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Promise = require(DiscoveryMonolithParent.Promise)
local PostHomePageUpsellCardVariationDismiss = require(Modules.LuaApp.Http.Requests.PostHomePageUpsellCardVariationDismiss)
local SetHomePageUpsellCardVariation = require(Modules.LuaApp.Actions.SetHomePageUpsellCardVariation)
local flaggedMutedError = require(DiscoveryMonolithParent.Loggers).flaggedMutedError

return function(p1, s1: string?) -- line: 20
	-- upvalues: SetHomePageUpsellCardVariation (copy), Promise (copy), PostHomePageUpsellCardVariationDismiss (copy), flaggedMutedError (copy)
	return function(p2) -- line: 21
		-- upvalues: SetHomePageUpsellCardVariation (copy), s1 (copy), Promise (copy), PostHomePageUpsellCardVariationDismiss (copy), p1 (copy), flaggedMutedError (copy)
		p2:dispatch(SetHomePageUpsellCardVariation("", "", "", {}))

		if not s1 or s1 == "" then
			return Promise.resolve()
		end

		return PostHomePageUpsellCardVariationDismiss(p1, s1):andThen(function(p3) -- line: 28
			-- upvalues: s1 (copy), flaggedMutedError (copy)
			if not p3 then
				local v14 = s1

				flaggedMutedError("HomePageContactMethodModuleVariationDismiss", "Unexpected response to post upsell card variation dismiss", {
					cardType = v14
				})
			end
		end, function(_) -- line: 32
			-- upvalues: s1 (copy), flaggedMutedError (copy)
			local v16 = s1

			flaggedMutedError("HomePageContactMethodModuleVariationDismiss", "Failed to post upsell card variation dismiss", {
				cardType = v16
			})
		end):catch(function(_) -- line: 34
			-- upvalues: s1 (copy), flaggedMutedError (copy)
			local v18 = s1

			flaggedMutedError("HomePageContactMethodModuleVariationDismiss", "Failed to post upsell card variation dismiss", {
				cardType = v18
			})
		end)
	end
end
