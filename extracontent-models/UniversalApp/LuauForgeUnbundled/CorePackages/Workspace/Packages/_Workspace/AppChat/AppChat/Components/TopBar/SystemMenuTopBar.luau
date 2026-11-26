local ChatTopBarBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatTopBarBase")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local createSystemMenuButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/createSystemMenuButton")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local function SystemMenuTopBar(p2)
	local screenName = p2.screenName
	local navigation = p2.navigation

	local v5 = useSignalState((GetTopBarStore(false).getScreenTopBar(screenName)))

	local systemButtonEnabled = v5.systemButtonEnabled
	local systemButtonActivated = v5.systemButtonActivated
	local systemButtonText = v5.systemButtonText or "Feature.Chat.Action.Add"

	local v6 = useLocalization({
		systemButtonText = systemButtonText,
		networkErrorText = "Feature.Chat.Response.NetworkError",
		invalidParticipantText = "Feature.Chat.Toast.Error.InvalidUserSelected",
		cannotExpandToGroupChatActivePartyText = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError"
	})

	local function fn()
		return createSystemMenuButton({
			localizedStrings = v6,
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
