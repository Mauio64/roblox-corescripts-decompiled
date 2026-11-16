local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dtT")
local module2 = require("@luauforge/bundled/dqV")

local defineFastString = game:DefineFastString("DebugHomePageUpsellCardVariationResponseBody", "")

return function(p2)
	return function(object)
		return module(p2):andThen(function(p3)
			if not (p3 and p3.responseBody) then
				object:dispatch(module2("", "", ""))

				return
			end

			local v5 = p3.responseBody

			if defineFastString ~= "" then
				local success, result = pcall(function()
					return HttpService:JSONDecode(defineFastString)
				end)
				v5 = result or v5
			end

			object:dispatch(module2(
				v5.upsellCardType or "",
				v5.localizedTitleTextOverride or "",
				v5.localizedBodyTextOverride or "",
				v5.upsellCardV2Config or nil
			))
		end, function(p3)
			object:dispatch(module2("", "", ""))
		end)
	end
end
