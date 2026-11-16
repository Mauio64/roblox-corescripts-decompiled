local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)

require(AvatarExperienceControlBar.ControlBarTypes)

local useUndoRedoBarViewModel = require(script.Parent.useUndoRedoBarViewModel)
local IconOnlyMenu = require(AvatarExperienceControlBar.Components.IconOnlyMenu)
local BaseControlBarContainer = require(AvatarExperienceControlBar.BaseControlBarContainer)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton

local function UndoRedoBarContainer(p)
	local v = useUndoRedoBarViewModel()

	if FFlagAXResetAvatarButton then
		return (React.createElement(BaseControlBarContainer, {
			config = v.items,
			onActiveMenuItemChanged = function() end,
			LayoutOrder = p.LayoutOrder
		}))
	end

	return (React.createElement(IconOnlyMenu, {
		items = v.items,
		direction = not p.direction and "horizontal" or p.direction,
		LayoutOrder = p.LayoutOrder
	}))
end

return React.memo(UndoRedoBarContainer)
