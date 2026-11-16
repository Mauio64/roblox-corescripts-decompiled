local module = require("@luauforge/bundled/dqe")

local module2 = require("@luauforge/bundled/duW")
local module3 = require("@luauforge/bundled/dqV")

local flaggedMutedError = require("@luauforge/bundled/dru").flaggedMutedError

return function(p2, p3)
	return function(object)
		object:dispatch(module3("", "", "", {}))

		if p3 and p3 ~= "" then
			return module2(p2, p3):andThen(function(p4)
				if not p4 then
					flaggedMutedError(
						"HomePageContactMethodModuleVariationDismiss",
						"Unexpected response to post upsell card variation dismiss",
						{ cardType = p3 }
					)
				end
			end, function(p4)
				flaggedMutedError(
					"HomePageContactMethodModuleVariationDismiss",
					"Failed to post upsell card variation dismiss",
					{ cardType = p3 }
				)
			end):catch(function(p4)
				flaggedMutedError(
					"HomePageContactMethodModuleVariationDismiss",
					"Failed to post upsell card variation dismiss",
					{ cardType = p3 }
				)
			end)
		end

		return module.resolve()
	end
end
