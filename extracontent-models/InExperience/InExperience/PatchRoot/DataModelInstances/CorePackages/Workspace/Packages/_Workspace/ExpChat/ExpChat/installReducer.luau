local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local getEnableChatInputBarConfigurationAutocompleteEnabled = require(ExpChat.Flags.getEnableChatInputBarConfigurationAutocompleteEnabled)
local getFFlagUnreduxLastInputTypeChanged = require(ExpChat.Flags.getFFlagUnreduxLastInputTypeChanged)
local getFFlagExpChatEnableChannelTabsUI = require(ExpChat.Flags.getFFlagExpChatEnableChannelTabsUI)
local FFlagEnableVerifiedBadgeStore = require(ExpChatParent.SharedFlags).FFlagEnableVerifiedBadgeStore

return Rodux.combineReducers({
	ChatIntervention = require(script.ChatInterventionReducer),
	Messages = require(script.Messages),
	MutedUsers = ExpChatShared.Reducers.MutedUsers,
	VerifiedUsers = if not FFlagEnableVerifiedBadgeStore then require(script.VerifiedUsers) else nil,
	Players = ExpChatShared.Reducers.Players,
	LocalCharacter = ExpChatShared.Reducers.LocalCharacter,
	TextChannels = ExpChatShared.Reducers.TextChannels,
	ChatVisibility = require(script.ChatVisibility),
	CanLocalUserChat = require(script.CanLocalUserChat),
	LocalTeam = ExpChatShared.Reducers.LocalTeam,
	isUsingTouch = if getFFlagUnreduxLastInputTypeChanged() then nil else require(script.isUsingTouch),
	isUsingGamepad = if getFFlagUnreduxLastInputTypeChanged() then nil else require(script.isUsingGamepad),
	shouldFocusChatInputBar = require(script.shouldFocusChatInputBar),
	Voice = require(script.Voice),
	BubbleChatSettings = require(script.BubbleChat),
	LegacyBubbleChatSettings = require(script.BubbleChat.LegacyChatReducer),
	ChatLayout = require(script.ChatLayout),
	AutoCastCommands = ExpChatShared.Reducers.AutoCastCommands,
	Adornees = require(script.Adornees),
	ClientSettings = require(script.ClientSettings),
	AutocompleteDropdown = getEnableChatInputBarConfigurationAutocompleteEnabled() and require(script.AutocompleteDropdown) or nil,
	ChannelTabs = getFFlagExpChatEnableChannelTabsUI() and require(script.ChannelTabs) or nil,
	ReverseNudgeToxicUsers = require(script.ReverseNudgeToxicUsers)
})
