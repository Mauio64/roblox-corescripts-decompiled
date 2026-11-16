local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ChatTopBarBase = require(script.Parent.ChatTopBarBase)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)

local Roact = require(parent.Roact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)

local useSignalState = SignalsReact.useSignalState

local function SystemMenuTopBar(p)
	local screenName = p.screenName
	local navigation = p.navigation

	local v = useSignalState((GetTopBarStore(false).getScreenTopBar(screenName)))

	local systemButtonEnabled = v.systemButtonEnabled
	local systemButtonActivated = v.systemButtonActivated
	local localizedStrings = useLocalization({
		systemButtonText = v.systemButtonText or "Feature.Chat.Action.Add",
		networkErrorText = "Feature.Chat.Response.NetworkError",
		invalidParticipantText = "Feature.Chat.Toast.Error.InvalidUserSelected",
		cannotExpandToGroupChatActivePartyText = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError"
	})

	local function fn()
		return createSystemMenuButton({
			localizedStrings = localizedStrings,
			isDisabled = not systemButtonEnabled,
			onActivated = systemButtonActivated
		})
	end

	return Roact.createElement(ChatTopBarBase, {
		screenName = screenName,
		navigation = navigation,
		renderRight = fn
	})
end

return SystemMenuTopBar
