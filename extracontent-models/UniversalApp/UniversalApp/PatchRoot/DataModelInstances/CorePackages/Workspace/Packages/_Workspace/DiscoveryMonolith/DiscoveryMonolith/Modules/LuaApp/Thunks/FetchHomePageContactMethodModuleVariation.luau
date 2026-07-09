local HttpService = game:GetService("HttpService")
local Modules = script:FindFirstAncestor("DiscoveryMonolith").Modules
local GetHomePageUpsellCardVariation = require(Modules.LuaApp.Http.Requests.GetHomePageUpsellCardVariation)
local SetHomePageUpsellCardVariation = require(Modules.LuaApp.Actions.SetHomePageUpsellCardVariation)
local v5 = game:DefineFastString("DebugHomePageUpsellCardVariationResponseBody", "")

return function(p1) -- line: 12
	-- upvalues: GetHomePageUpsellCardVariation (copy), v5 (copy), HttpService (copy), SetHomePageUpsellCardVariation (copy)
	return function(p2) -- line: 13
		-- upvalues: GetHomePageUpsellCardVariation (copy), p1 (copy), v5 (copy), HttpService (copy), SetHomePageUpsellCardVariation (copy)
		return GetHomePageUpsellCardVariation(p1):andThen(function(p3) -- line: 14
			-- upvalues: v5 (copy), HttpService (copy), p2 (copy), SetHomePageUpsellCardVariation (copy)
			if p3 and p3.responseBody then
				local responseBody = p3.responseBody

				if v5 ~= "" then
					local _, result = pcall(function() -- line: 19
						-- upvalues: HttpService (copy), v5 (copy)
						return HttpService:JSONDecode(v5)
					end)

					if result then
						responseBody = result
					end
				end

				p2:dispatch(SetHomePageUpsellCardVariation(responseBody.upsellCardType or "", responseBody.localizedTitleTextOverride or "", responseBody.localizedBodyTextOverride or "", responseBody.upsellCardV2Config or nil))

				return
			end

			p2:dispatch(SetHomePageUpsellCardVariation("", "", ""))
		end, function(_) -- line: 37
			-- upvalues: p2 (copy), SetHomePageUpsellCardVariation (copy)
			p2:dispatch(SetHomePageUpsellCardVariation("", "", ""))
		end)
	end
end
