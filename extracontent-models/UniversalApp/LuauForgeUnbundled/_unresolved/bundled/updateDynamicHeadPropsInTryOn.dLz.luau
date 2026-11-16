local module = require("@luauforge/bundled/dHS")

local module2 = require("@luauforge/bundled/dLA")
require("@luauforge/bundled/dLy")

local dynamicHead = module2.Constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead

local function updateDynamicHeadPropsInTryOn(items, callback)
	local result = {}

	for k, item in items do
		if item.bundleInfo then
			local values = {}

			for k2, joined in item.bundleInfo do
				if joined.assetType == dynamicHead then
					local v5 = callback(joined)

					if v5 then
						joined = module.Dictionary.join(joined, v5)
					end

					values[k2] = joined
				else
					values[k2] = joined
				end
			end

			result[k] = module.Dictionary.join(item, { bundleInfo = values })
		else
			result[k] = item
		end
	end

	return result
end

return updateDynamicHeadPropsInTryOn
