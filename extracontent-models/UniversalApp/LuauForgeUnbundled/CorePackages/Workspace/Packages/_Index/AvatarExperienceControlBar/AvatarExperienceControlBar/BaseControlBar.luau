local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")

local IconOnlyMenu = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/IconOnlyMenu")
local IconTextMenu = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/IconTextMenu")
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/RoactUtils").ExternalEventConnection

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")

local function BaseControlBar(props)
	local v5, v6 = React.useBinding(UDim2.new(0, 0, 0, 0))
	local createElement = React.createElement
	local view = Foundation.View
	local v7 = {
		tag = "no-clip",
		Size = v5,
		ref = props.containerRef,
		LayoutOrder = props.LayoutOrder
	}
	local v8 = {
		MainMenu = React.createElement(IconOnlyMenu, {
			items = props.menus,
			activeItemId = props.activeMenuItemId,
			onItemActivated = props.onMenuItemActivated,
			ref = props.iconMenuRef,
			onAbsoluteSizeChanged = function(p2)
				v6(UDim2.fromOffset(p2.AbsoluteSize.X, p2.AbsoluteSize.Y))
			end
		}),
		Submenu = 0,
		OnInputEnded = 0
	}

	local v9 = if props.submenuItems then React.createElement(IconTextMenu, {
		key = props.activeMenuItemId,
		items = props.submenuItems,
		onItemActivated = props.onSubmenuItemActivated,
		Position = props.submenuPosition
	}) else nil
	v8.Submenu = v9

	v8.OnInputEnded = React.createElement(externalEventConnection, {
		event = UserInputService.InputEnded,
		callback = props.onInputEnded
	})
	return createElement(view, v7, v8)
end

return React.memo(BaseControlBar)
