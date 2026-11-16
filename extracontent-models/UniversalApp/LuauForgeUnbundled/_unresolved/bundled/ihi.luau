require("@luauforge/bundled/dHK")
local module = require("@luauforge/bundled/dMx")

local module2 = require("@luauforge/bundled/gqw")

return function(p2)
	local v5, v6, v7 = module2(p2, module.AssetTypeIdStrings.DynamicHead)
	local v8, v9, v10 = module2(p2, module.AssetTypeIdStrings.Head)

	if v10 and (not v7 or v7 < v10) or not v6 then
		return nil
	end

	assert(v6, "tryOnBundleInfo is non-nil. Silence type checker")

	for k, v11 in v6 do
		if v11.assetType == module.AssetTypeIdStrings.MoodAnimation then
			return k
		end
	end

	return nil
end
