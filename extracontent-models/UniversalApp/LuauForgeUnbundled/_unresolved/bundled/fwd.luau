local module = require("@luauforge/bundled/dMx")

local module2 = require("@luauforge/bundled/fwe")

local module3 = require("@luauforge/bundled/fwf")
local module4 = require("@luauforge/bundled/dHL")
local addSelectedBundleInfo = module4.Actions.AddSelectedBundleInfo
local setOrderForTryOns = module4.Actions.SetOrderForTryOns
local module5 = require("@luauforge/bundled/dOJ")

return function(p2)
	return function(object)
		local state = object:getState()
		local v5, v6 = module2(state)
		local v7 = module3(state, p2, module.ItemType.Bundle, nil, v5, v6)

		if v7.equippedAssetsToSetOrder then
			object:dispatch(module5(v7.equippedAssetsToSetOrder))
		end

		if v7.itemIdToOrderMap then
			object:dispatch(setOrderForTryOns(v7.itemIdToOrderMap))
		end

		object:dispatch(addSelectedBundleInfo(p2, v7.bundleInfoMapping))
	end
end
