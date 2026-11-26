local module = require("@luauforge/bundled/dtf")
require("@luauforge/bundled/dtp")
local appPage = require("@luauforge/bundled/dup").AppPage

local module2 = require("@luauforge/bundled/dtQ")

return function(options, data)
	local v5 = options or {}

	if data.type ~= module2.name then
		return v5
	end

	local recommendations = data.recommendations

	for k, recommendation in pairs(recommendations) do
		if k ~= appPage.Home then
			continue
		end

		assert(k == recommendation.pageType, "Should match page type")

		if not recommendation.globalLayoutData then
			continue
		end

		if data.isAppend then
			v5 = module.Dictionary.join(v5, recommendation.globalLayoutData)
		else
			v5 = module.Dictionary.join({}, recommendation.globalLayoutData)
		end
	end

	return v5
end
