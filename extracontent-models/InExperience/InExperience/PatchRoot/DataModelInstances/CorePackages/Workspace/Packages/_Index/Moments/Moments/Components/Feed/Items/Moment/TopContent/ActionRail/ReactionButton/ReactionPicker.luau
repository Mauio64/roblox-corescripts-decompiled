local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)

require(MomentsParent.MomentsCommon)

local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentContext = require(script.Parent.Parent.Parent.Parent.MomentContext)
local useReactionCommit = require(script.Parent.Parent.Parent.Parent.Reactions.useReactionCommit)
local PickerItem = require(script.Parent.PickerItem)
local reactionTypesFromEmojis = require(Moments.Utils.reactionTypesFromEmojis)
local FFlagMomentsEmojiSetsApi = require(Moments.Flags.FFlagMomentsEmojiSetsApi)
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState
local v13 = if not FFlagMomentsEmojiSetsApi then nil else require(MomentsParent.DataHydration.MomentsGetMomentsReactionsStore)
local FALLBACK_PICKER_REACTIONS = reactionTypesFromEmojis.FALLBACK_PICKER_REACTIONS
local reactionTypesFromEmojis2 = reactionTypesFromEmojis.reactionTypesFromEmojis
local v16 = if not FFlagMomentsEmojiSetsApi then nil else function(p1) -- line: 30
	-- upvalues: v13 (copy), reactionTypesFromEmojis2 (copy)
	assert(v13 ~= nil, "expected Moments reactions store when FFlagMomentsEmojiSetsApi is on")

	local getEmojis = v13(false).getEmojis

	assert(getEmojis ~= nil, "expected getEmojis when FFlagMomentsEmojiSetsApi is on")

	return reactionTypesFromEmojis2(getEmojis(p1))
end

local function ReactionPicker() -- line: 38
	-- upvalues: MomentContext (copy), useReactionCommit (copy), FALLBACK_PICKER_REACTIONS (copy), FFlagMomentsEmojiSetsApi (copy), useSignalState (copy), v16 (copy), React (copy), PickerItem (copy), View (copy)
	local store = MomentContext.useMoment().store
	local v21 = useReactionCommit()
	local v22 = FALLBACK_PICKER_REACTIONS

	if FFlagMomentsEmojiSetsApi then
		v22 = useSignalState(v16)
	end

	local v23 = React.useCallback(function(p2, vector2: Vector2?) -- line: 50
		-- upvalues: v21 (copy), store (copy)
		v21("pickerSelect", vector2, p2)
		store.setReactionPickerOpen(false)
	end, {
		store.setReactionPickerOpen,
		v21
	})
	local t1 = {}

	for v25, v26 in v22 do
		t1[`reaction_{ v26 }`] = React.createElement(PickerItem, {
			reaction = v26,
			index = v25,
			onSelect = v23
		})
	end

	return React.createElement(View, {
		tag = "row align-x-center align-y-center gap-medium size-0-1400 auto-x padding-x-large"
	}, t1)
end

return React.memo(ReactionPicker)
