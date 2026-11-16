local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")

local SelectableItemCardRowView = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SelectableItemCardRow/SelectableItemCardRowView")
local useSelectableRowViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SelectableItemCardRow/useSelectableRowViewModel")

local function SelectableCardRowContainer(p2)
	local v5 = useSelectableRowViewModel(p2)
	return React.createElement(SelectableItemCardRowView, v5)
end

return SelectableCardRowContainer
