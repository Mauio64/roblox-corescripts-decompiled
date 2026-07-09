local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local MomentsCommon = require(Parent.MomentsCommon)
local React = require(Parent.React)
local MomentContext = require(script.Parent.Parent.Parent.Parent.MomentContext)
local useReactionCommit = require(script.Parent.Parent.Parent.Parent.Reactions.useReactionCommit)
local PickerItem = require(script.Parent.PickerItem)
local View = Foundation.View
local ReactionType = MomentsCommon.Enums.ReactionType
local t1 = {
	ReactionType.ThumbsUp,
	ReactionType.Heart,
	ReactionType.LaughJoy,
	ReactionType.Wow,
	ReactionType.Cry,
	ReactionType.Fire,
	ReactionType.Skull
}

local function ReactionPicker() -- line: 28
	-- upvalues: MomentContext (copy), useReactionCommit (copy), React (copy), t1 (copy), PickerItem (copy), View (copy)
	local store = MomentContext.useMoment().store
	local v13 = useReactionCommit()
	local v14 = React.useCallback(function(p1, vector2: Vector2?) -- line: 34
		-- upvalues: v13 (copy), store (copy)
		v13("pickerSelect", vector2, p1)
		store.setReactionPickerOpen(false)
	end, {
		store.setReactionPickerOpen,
		v13
	})
	local t2 = {}

	for v16, v17 in t1 do
		t2[`reaction_{ v17 }`] = React.createElement(PickerItem, {
			reaction = v17,
			index = v16,
			onSelect = v14
		})
	end

	return React.createElement(View, {
		tag = "row align-x-center align-y-center gap-medium size-0-1400 auto-x padding-x-large"
	}, t2)
end

return React.memo(ReactionPicker)
