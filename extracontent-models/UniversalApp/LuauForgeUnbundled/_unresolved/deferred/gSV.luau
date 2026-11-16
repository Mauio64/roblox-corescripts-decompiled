local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local categoryMenu = require("@luauforge/deferred/gkN").CategoryMenu

local function CategoryMenuSlotNavigation(props)
	return React.createElement(categoryMenu, {
		categories = props.categories,
		activeCategoryId = props.activeCategoryId,
		onCategoryActivated = props.onCategoryActivated,
		buttons = props.buttons,
		buttonsLocation = props.buttonsLocation,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex
	})
end

return React.memo(CategoryMenuSlotNavigation)
