local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")

local useUndoRedoBarViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/UndoRedoBar/useUndoRedoBarViewModel")
local IconOnlyMenu = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/IconOnlyMenu")
local BaseControlBarContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/BaseControlBarContainer")

local fFlagAXResetAvatarButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXResetAvatarButton

local function UndoRedoBarContainer(p2)
	local v5 = useUndoRedoBarViewModel()

	if fFlagAXResetAvatarButton then
		return (React.createElement(BaseControlBarContainer, {
			config = v5.items,
			onActiveMenuItemChanged = function() end,
			LayoutOrder = p2.LayoutOrder
		}))
	end

	return (React.createElement(IconOnlyMenu, {
		items = v5.items,
		direction = not p2.direction and "horizontal" or p2.direction,
		LayoutOrder = p2.LayoutOrder
	}))
end

return React.memo(UndoRedoBarContainer)
