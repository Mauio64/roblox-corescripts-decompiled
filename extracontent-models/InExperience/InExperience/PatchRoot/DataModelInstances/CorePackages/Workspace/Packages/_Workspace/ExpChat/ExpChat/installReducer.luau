local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local ExpChatShared = require(parent.ExpChatShared)

local getEnableChatInputBarConfigurationAutocompleteEnabled = require(ExpChat.Flags.getEnableChatInputBarConfigurationAutocompleteEnabled)
local getFFlagUnreduxLastInputTypeChanged = require(ExpChat.Flags.getFFlagUnreduxLastInputTypeChanged)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags2.FFlagExpChatUseChannelTabsStore

local combineReducers = Rodux.combineReducers
local v = {
	ChatIntervention = require(script.ChatInterventionReducer),
	Messages = require(script.Messages),
	MutedUsers = ExpChatShared.Reducers.MutedUsers,
	VerifiedUsers = 0,
	Players = 0,
	LocalCharacter = 0,
	TextChannels = 0,
	ChatVisibility = 0,
	CanLocalUserChat = 0,
	LocalTeam = 0,
	isUsingTouch = 0,
	isUsingGamepad = 0,
	shouldFocusChatInputBar = 0,
	Voice = 0,
	BubbleChatSettings = 0,
	LegacyBubbleChatSettings = 0,
	ChatLayout = 0,
	AutoCastCommands = 0,
	Adornees = 0,
	ClientSettings = 0,
	AutocompleteDropdown = 0,
	ChannelTabs = 0,
	ReverseNudgeToxicUsers = 0
}
local verifiedUsers

if not FFlagEnableVerifiedBadgeStore then
	verifiedUsers = require(script.VerifiedUsers)
end

v.VerifiedUsers = verifiedUsers
v.Players = ExpChatShared.Reducers.Players
v.LocalCharacter = ExpChatShared.Reducers.LocalCharacter
v.TextChannels = ExpChatShared.Reducers.TextChannels
v.ChatVisibility = require(script.ChatVisibility)
v.CanLocalUserChat = require(script.CanLocalUserChat)
v.LocalTeam = ExpChatShared.Reducers.LocalTeam
local isUsingTouch

if not getFFlagUnreduxLastInputTypeChanged() then
	isUsingTouch = require(script.isUsingTouch)
end

v.isUsingTouch = isUsingTouch
local isUsingGamepad

if not getFFlagUnreduxLastInputTypeChanged() then
	isUsingGamepad = require(script.isUsingGamepad)
end

v.isUsingGamepad = isUsingGamepad
v.shouldFocusChatInputBar = require(script.shouldFocusChatInputBar)
v.Voice = require(script.Voice)
v.BubbleChatSettings = require(script.BubbleChat)
v.LegacyBubbleChatSettings = require(script.BubbleChat.LegacyChatReducer)
v.ChatLayout = require(script.ChatLayout)
v.AutoCastCommands = ExpChatShared.Reducers.AutoCastCommands
v.Adornees = require(script.Adornees)
v.ClientSettings = require(script.ClientSettings)
v.AutocompleteDropdown = getEnableChatInputBarConfigurationAutocompleteEnabled()
	and require(script.AutocompleteDropdown)
	or nil
local channelTabs

if not FFlagExpChatUseChannelTabsStore then
	channelTabs = require(script.ChannelTabs)
end

v.ChannelTabs = channelTabs
v.ReverseNudgeToxicUsers = require(script.ReverseNudgeToxicUsers)
return combineReducers(v)
