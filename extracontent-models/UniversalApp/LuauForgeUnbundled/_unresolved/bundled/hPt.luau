local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module3 = require("@luauforge/bundled/dzD")

local module4 = require("@luauforge/bundled/hPu")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module5 = require("@luauforge/bundled/hPz")

local extended = module.PureComponent:extend("ContextualMenu")

local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = module3.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

function extended.render(p2)
	local callbackCancel = p2.props.callbackCancel
	local callbackSelect = p2.props.callbackSelect
	local menuItems = p2.props.menuItems or {}
	local screenShape = p2.props.screenShape
	local formFactor2 = p2.props.formFactor

	local v5 = formFactor2 == formFactor.WIDE

	for i, menuItem in ipairs(menuItems) do
		menuItems[i].onSelect = function()
			callbackSelect(menuItem, i)
		end
		menuItems[i].text = menuItem.displayName
	end

	local v6 = {}
	local v7 = v5 and DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH or screenShape.parentWidth
	v6.ListPicker = module.createElement(module5, {
		layoutOrder = 2,
		items = menuItems,
		formFactor = formFactor2,
		width = v7
	})

	return module.createElement(module4, {
		callbackCancel = callbackCancel,
		screenShape = screenShape
	}, v6)
end

return (useSheetNavigation.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end)(extended))
