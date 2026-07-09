local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local UserInputService = game:GetService("UserInputService")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local IconOnlyMenu = require(AvatarExperienceControlBar.Components.IconOnlyMenu)
local IconTextMenu = require(AvatarExperienceControlBar.Components.IconTextMenu)
local ExternalEventConnection = require(AvatarExperienceControlBarParent.RoactUtils).ExternalEventConnection

require(AvatarExperienceControlBar.ControlBarTypes)

local function BaseControlBar(p1) -- line: 14
	-- upvalues: React (copy), Foundation (copy), IconOnlyMenu (copy), IconTextMenu (copy), ExternalEventConnection (copy), UserInputService (copy)
	local v11, v12 = React.useBinding(UDim2.new(0, 0, 0, 0))

	return React.createElement(Foundation.View, {
		tag = "no-clip",
		Size = v11,
		ref = p1.containerRef,
		LayoutOrder = p1.LayoutOrder
	}, {
		MainMenu = React.createElement(IconOnlyMenu, {
			items = p1.menus,
			activeItemId = p1.activeMenuItemId,
			onItemActivated = p1.onMenuItemActivated,
			ref = p1.iconMenuRef,
			onAbsoluteSizeChanged = function(p2) -- line: 27
				-- upvalues: v12 (copy)
				v12(UDim2.fromOffset(p2.AbsoluteSize.X, p2.AbsoluteSize.Y))
			end
		}),
		Submenu = if not p1.submenuItems then nil else React.createElement(IconTextMenu, {
			key = p1.activeMenuItemId,
			items = p1.submenuItems,
			onItemActivated = p1.onSubmenuItemActivated,
			Position = p1.submenuPosition
		}),
		OnInputEnded = React.createElement(ExternalEventConnection, {
			event = UserInputService.InputEnded,
			callback = p1.onInputEnded
		})
	})
end

return React.memo(BaseControlBar)
