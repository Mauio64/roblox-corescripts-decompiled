local module = require("@luauforge/bundled/dTk")
local module2 = require("@luauforge/bundled/dUJ")
require("@luauforge/bundled/dTq")
local module3 = require("@luauforge/bundled/dUK")

local module4 = require("@luauforge/bundled/dVj")
local module5 = require("@luauforge/bundled/dTB")

local module6 = require("@luauforge/bundled/dUO")

local module7 = require("@luauforge/bundled/dUP")

local categoryMenu = module3.CategoryMenu
local mapButtons = module4.mapButtons
local mapTooltips = module4.mapTooltips

local function FavoritesCategoryMenu(props)
	local v5 = module2.useSignalState(module5.getActiveL1Id)
	local v6 = module2.useSignalState(module5.getActiveLeafId)

	local v7 = v5 or props.activeCategoryId

	local v8 = module6(v7)

	local v9 = module7(v7)
	local v10 = v6 or v9 or props.activeSubcategoryId

	local v11 = module.useCallback(function(p2)
		if typeof(props.onCategoryActivated) == "function" then
			props.onCategoryActivated(nil, nil, { categoryId = p2 })
		end
	end, { props.onCategoryActivated })

	local v12 = module.useCallback(function(p2)
		if typeof(props.onSubcategoryActivated) == "function" then
			props.onSubcategoryActivated(nil, nil, { subcategoryId = p2 })
		end
	end, { props.onSubcategoryActivated })

	local v13 = module.useMemo(function()
		return mapButtons(props.buttons, props.sduiContext, "MarketplaceFavoritesCategoryMenu")
	end, { props.buttons, props.sduiContext })

	local v14 = module.useMemo(function()
		return mapTooltips(props.tooltips)
	end, { props.tooltips })

	local v15 = {
		activeCategoryId = v7,
		activeSubcategoryId = v10,
		categories = props.categories,
		subcategories = v8,
		buttonsLocation = props.buttonsLocation,
		onCategoryActivated = v11,
		onSubcategoryActivated = v12,
		buttons = v13,
		tooltips = v14
	}

	return module.createElement(categoryMenu, v15)
end

return module.memo(FavoritesCategoryMenu)
