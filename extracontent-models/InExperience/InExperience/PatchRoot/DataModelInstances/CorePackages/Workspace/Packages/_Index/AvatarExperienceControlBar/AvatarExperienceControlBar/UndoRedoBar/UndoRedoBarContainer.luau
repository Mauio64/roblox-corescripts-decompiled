local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)

require(AvatarExperienceControlBar.ControlBarTypes)

local useUndoRedoBarViewModel = require(script.Parent.useUndoRedoBarViewModel)
local IconOnlyMenu = require(AvatarExperienceControlBar.Components.IconOnlyMenu)
local BaseControlBarContainer = require(AvatarExperienceControlBar.BaseControlBarContainer)
local FFlagAXResetAvatarButton = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXResetAvatarButton

local function UndoRedoBarContainer(t1: {[any]: any}) -- line: 19
	-- upvalues: useUndoRedoBarViewModel (copy), FFlagAXResetAvatarButton (copy), React (copy), BaseControlBarContainer (copy), IconOnlyMenu (copy)
	local v10 = useUndoRedoBarViewModel()

	if FFlagAXResetAvatarButton then
		return (React.createElement(BaseControlBarContainer, {
			config = v10.items,
			onActiveMenuItemChanged = function() -- line: 24
			end,
			LayoutOrder = t1.LayoutOrder
		}))
	end

	return (React.createElement(IconOnlyMenu, {
		items = v10.items,
		direction = not t1.direction and "horizontal" or t1.direction,
		LayoutOrder = t1.LayoutOrder
	}))
end

return React.memo(UndoRedoBarContainer)
