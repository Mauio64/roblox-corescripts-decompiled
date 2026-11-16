local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.MomentsCommon)
local SignalsReact = require(parent.SignalsReact)

local reactionTypesFromEmojis = require(Moments.Utils.reactionTypesFromEmojis)
local FFlagMomentsEmojiSetsApi = require(Moments.Flags.FFlagMomentsEmojiSetsApi)

local useSignalState = SignalsReact.useSignalState
local MomentsGetMomentsReactionsStore

if FFlagMomentsEmojiSetsApi then
	MomentsGetMomentsReactionsStore = require(parent.DataHydration.MomentsGetMomentsReactionsStore)
else
	MomentsGetMomentsReactionsStore = nil
end

local PICKER_REACTION_ORDER = reactionTypesFromEmojis.PICKER_REACTION_ORDER
local reactionTypesFromEmojis2 = reactionTypesFromEmojis.reactionTypesFromEmojis

local fn = FFlagMomentsEmojiSetsApi and function(p)
	assert(
		MomentsGetMomentsReactionsStore ~= nil,
		"expected Moments reactions store when FFlagMomentsEmojiSetsApi is on"
	)
	local getEmojis = MomentsGetMomentsReactionsStore(false).getEmojis
	assert(getEmojis ~= nil, "expected getEmojis when FFlagMomentsEmojiSetsApi is on")
	return reactionTypesFromEmojis2(getEmojis(p))
end or nil

local function usePickerReactions()
	local v = PICKER_REACTION_ORDER

	if FFlagMomentsEmojiSetsApi then
		return (useSignalState(fn))
	end

	return v
end

return usePickerReactions
