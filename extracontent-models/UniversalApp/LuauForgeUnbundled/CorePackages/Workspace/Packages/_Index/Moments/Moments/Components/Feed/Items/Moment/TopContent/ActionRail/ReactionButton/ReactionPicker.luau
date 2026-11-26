local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local useReactionCommit = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/useReactionCommit")
local PickerItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/ReactionButton/PickerItem")
local usePickerReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/ReactionButton/usePickerReactions")

local view = Foundation.View

local function ReactionPicker()
	local store = MomentContext.useMoment().store

	local v5 = useReactionCommit()
	local v6 = usePickerReactions()

	local v7 = React.useCallback(function(p2, p3)
		v5("pickerSelect", p3, p2)
		store.setReactionPickerOpen(false)
	end, { store.setReactionPickerOpen, v5 })

	local children = {}

	for k, v8 in v6 do
		children[`reaction_{v8}`] = React.createElement(PickerItem, {
			reaction = v8,
			index = k,
			onSelect = v7
		})
	end

	return React.createElement(
		view,
		{
			tag = "row align-x-center align-y-center gap-medium size-0-1400 auto-x padding-x-large"
		},
		children
	)
end

return React.memo(ReactionPicker)
