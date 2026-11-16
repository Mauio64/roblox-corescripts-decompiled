local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
require(parent.MomentsCommon)
local React = require(parent.React)

local MomentContext = require(script.Parent.Parent.Parent.Parent.MomentContext)
local useReactionCommit = require(script.Parent.Parent.Parent.Parent.Reactions.useReactionCommit)
local PickerItem = require(script.Parent.PickerItem)
local usePickerReactions = require(script.Parent.usePickerReactions)

local View = Foundation.View

local function ReactionPicker()
	local store = MomentContext.useMoment().store

	local v = useReactionCommit()
	local v2 = usePickerReactions()

	local onSelect = React.useCallback(function(p, vector2: Vector2?)
		v("pickerSelect", vector2, p)
		store.setReactionPickerOpen(false)
	end, { store.setReactionPickerOpen, v })

	local children = {}

	for k, reaction in v2 do
		children[`reaction_{reaction}`] = React.createElement(PickerItem, {
			reaction = reaction,
			index = k,
			onSelect = onSelect
		})
	end

	return React.createElement(
		View,
		{ tag = "row align-x-center align-y-center gap-medium size-0-1400 auto-x padding-x-large" },
		children
	)
end

return React.memo(ReactionPicker)
