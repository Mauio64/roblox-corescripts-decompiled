require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/reactionTypesFromEmojis")
local FFlagMomentsEmojiSetsApi = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsEmojiSetsApi")

local useSignalState = SignalsReact.useSignalState

local v5 = if FFlagMomentsEmojiSetsApi then require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsReactionsStore") else nil

local PICKER_REACTION_ORDER = module2.PICKER_REACTION_ORDER
local reactionTypesFromEmojis = module2.reactionTypesFromEmojis

local fn = FFlagMomentsEmojiSetsApi and function(p2)
	assert(v5 ~= nil, "expected Moments reactions store when FFlagMomentsEmojiSetsApi is on")
	local getEmojis = v5(false).getEmojis
	assert(getEmojis ~= nil, "expected getEmojis when FFlagMomentsEmojiSetsApi is on")
	return reactionTypesFromEmojis(getEmojis(p2))
end or nil

local function usePickerReactions()
	local v6 = PICKER_REACTION_ORDER

	if FFlagMomentsEmojiSetsApi then
		v6 = useSignalState(fn)
	end

	return v6
end

return usePickerReactions
