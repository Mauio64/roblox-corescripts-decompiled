local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local LuaApp = Modules.LuaApp
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local Constants = require(LuaApp.Constants)
local ContextualListMenu = require(LuaApp.Components.ContextualListMenu)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local ListPicker = require(Modules.LuaApp.Components.ListPicker)
local v11 = Roact.PureComponent:extend("ContextualMenu")
local DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH = Constants.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH

function v11.render(p1) -- line: 27
	-- upvalues: FormFactor (copy), DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH (copy), Roact (copy), ListPicker (copy), ContextualListMenu (copy)
	local callbackCancel = p1.props.callbackCancel
	local callbackSelect = p1.props.callbackSelect
	local v16 = p1.props.menuItems or {}
	local screenShape = p1.props.screenShape
	local formFactor = p1.props.formFactor
	local v19 = formFactor == FormFactor.WIDE

	for i, v in ipairs(v16) do
		v16[i].onSelect = function() -- line: 39
			-- upvalues: callbackSelect (copy), v (copy), i (copy)
			callbackSelect(v, i)
		end
		v16[i].text = v.displayName
	end

	local t1 = {}
	local v23 = v19 and DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH or screenShape.parentWidth

	t1.ListPicker = Roact.createElement(ListPicker, {
		layoutOrder = 2,
		items = v16,
		formFactor = formFactor,
		width = v23
	})

	return Roact.createElement(ContextualListMenu, {
		callbackCancel = callbackCancel,
		screenShape = screenShape
	}, t1)
end

return (RoactRodux.connect(function(p2, _) -- line: 60
	return {
		formFactor = p2.FormFactor
	}
end)(v11))
