local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local ChatTopBarBase = require(script.Parent.ChatTopBarBase)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local Roact = require(AppChatParent.Roact)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useSignalState = require(AppChatParent.SignalsReact).useSignalState

local function SystemMenuTopBar(t1: {[any]: any}) -- line: 28
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), useSignalState (copy), useLocalization (copy), createSystemMenuButton (copy), Roact (copy), ChatTopBarBase (copy)
	if not FFlagAppChatTopBarConfigDriven() then
		return nil
	end

	local screenName = t1.screenName
	local navigation = t1.navigation
	local v14 = GetTopBarStore(false).getScreenTopBar(screenName)
	local v15 = useSignalState(v14)
	local systemButtonEnabled = v15.systemButtonEnabled
	local systemButtonActivated = v15.systemButtonActivated
	local v18 = v15.systemButtonText or "Feature.Chat.Action.Add"
	local v19 = useLocalization({
		networkErrorText = "Feature.Chat.Response.NetworkError",
		invalidParticipantText = "Feature.Chat.Toast.Error.InvalidUserSelected",
		cannotExpandToGroupChatActivePartyText = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError",
		systemButtonText = v18
	})

	return Roact.createElement(ChatTopBarBase, {
		screenName = screenName,
		navigation = navigation,
		renderRight = function() -- line: 51
			-- upvalues: createSystemMenuButton (copy), v19 (copy), systemButtonEnabled (copy), systemButtonActivated (copy)
			return createSystemMenuButton({
				localizedStrings = v19,
				isDisabled = not systemButtonEnabled,
				onActivated = systemButtonActivated
			})
		end
	})
end

return SystemMenuTopBar
