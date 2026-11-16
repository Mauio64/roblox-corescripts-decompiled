local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local UserInputService = game:GetService("UserInputService")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local IconOnlyMenu = require(AvatarExperienceControlBar.Components.IconOnlyMenu)
local IconTextMenu = require(AvatarExperienceControlBar.Components.IconTextMenu)
local RoactUtils = require(parent.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

require(AvatarExperienceControlBar.ControlBarTypes)

local function BaseControlBar(props)
	local size, v = React.useBinding(UDim2.new(0, 0, 0, 0))
	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = "no-clip",
		Size = size,
		ref = props.containerRef,
		LayoutOrder = props.LayoutOrder
	}
	local v3 = {
		MainMenu = React.createElement(IconOnlyMenu, {
			items = props.menus,
			activeItemId = props.activeMenuItemId,
			onItemActivated = props.onMenuItemActivated,
			ref = props.iconMenuRef,
			onAbsoluteSizeChanged = function(p)
				v(UDim2.fromOffset(p.AbsoluteSize.X, p.AbsoluteSize.Y))
			end
		}),
		Submenu = 0,
		OnInputEnded = 0
	}
	local submenu

	if props.submenuItems then
		submenu = React.createElement(IconTextMenu, {
			key = props.activeMenuItemId,
			items = props.submenuItems,
			onItemActivated = props.onSubmenuItemActivated,
			Position = props.submenuPosition
		})
	end

	v3.Submenu = submenu

	v3.OnInputEnded = React.createElement(ExternalEventConnection, {
		event = UserInputService.InputEnded,
		callback = props.onInputEnded
	})
	return createElement(view, v2, v3)
end

return React.memo(BaseControlBar)
