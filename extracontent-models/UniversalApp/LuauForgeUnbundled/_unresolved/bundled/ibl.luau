local module = require("@luauforge/bundled/ibe")
local module2 = require("@luauforge/bundled/ibj")
local iconButton = module2.IconButton
local view = module2.View
local buttonVariant = module2.Enums.ButtonVariant
local iconName = module2.Enums.IconName
local inputSize = module2.Enums.InputSize

local module3 = require("@luauforge/bundled/ibm")

local function ChevronButton(props)
	return module.createElement(iconButton, {
		tag = "col align-x-center align-y-center auto-xy radius-circle",
		LayoutOrder = props.layoutOrder,
		icon = props.iconName,
		isCircular = true,
		variant = buttonVariant.OverMedia,
		size = inputSize.Medium,
		isDisabled = props.disabled,
		onActivated = props.onActivated
	})
end

local function OutfitNavigationControls(props)
	local createElement = module.createElement
	local fragment = module.Fragment
	local v7 = if props.showLeftChevron then module.createElement(ChevronButton, {
		iconName = iconName.ChevronLargeLeft,
		layoutOrder = 1,
		onActivated = props.onLeftChevronActivated,
		disabled = props.isSwitchingOutfit
	}) else nil
	local v6 = {
		LeftChevron = v7,
		Spacer = module.createElement(view, { tag = "grow auto-y", LayoutOrder = 2 }),
		RightChevron = 0
	}

	local v8 = if props.showRightChevron then module.createElement(ChevronButton, {
		iconName = iconName.ChevronLargeRight,
		layoutOrder = 3,
		onActivated = props.onRightChevronActivated,
		disabled = module3.isRightChevronDisabled(
			props.isSwitchingOutfit,
			props.hasNextOutfit,
			props.hasNoAdditionalAvatars
		)
	}) else nil
	v6.RightChevron = v8
	return createElement(fragment, nil, v6)
end

return module.memo(OutfitNavigationControls)
