local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local coreScriptsRootProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/CoreScriptsRoactCommon").CoreScriptsRootProvider
local inExperienceProviderContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/InExperienceContainer").InExperienceProviderContainer

require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
local AccountUpgradeContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeContainer")
local AccountUpgradeSuccessView = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeSuccessView")
local respawnIntoExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/InExperience/respawnIntoExperience")
local resolveSuccessIdentity = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/InExperience/resolveSuccessIdentity")

local FStringAccountUpgradeLinkedAccountType = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FStringAccountUpgradeLinkedAccountType")

local function AccountUpgradePromptApp(props)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	local localPlayer = Players.LocalPlayer

	local name = if localPlayer then localPlayer.Name else nil

	local onComplete = props.onComplete
	local v5 = React.useCallback(function(p2)
		if p2.isSuccess then
			setState2(p2)
		end
	end, {})

	local v6 = React.useCallback(function()
		local v7 = state2

		if v7 ~= nil then
			onComplete(v7)
		end
	end, { onComplete, state2 })

	local v7 = React.useCallback(function()
		v6()
		respawnIntoExperience()
	end, { v6 })
	local v8

	if state2 == nil then
		v8 = React.createElement(AccountUpgradeContainer, {
			flow = props.flow,
			hasBackdrop = true,
			currentUsername = name,
			onClose = props.onDismiss,
			onSignUpComplete = v5
		})
	else
		local v11 = if localPlayer then localPlayer.DisplayName else nil
		local v12 = resolveSuccessIdentity(state2, { username = name, displayName = v11 })

		v8 = React.createElement(AccountUpgradeSuccessView, {
			userId = not localPlayer and 0 or localPlayer.UserId,
			displayName = v12.displayName,
			username = v12.username,
			didUsernameChange = v12.didUsernameChange,
			linkedAccountType = FStringAccountUpgradeLinkedAccountType,
			onRespawnNow = v7,
			onApplyLater = v6,
			onConfirm = v6,
			hasBackdrop = true
		})
	end

	local createElement = React.createElement
	local v11 = {
		ModalFix = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			Modal = true,
			Size = UDim2.fromOffset(0, 0)
		}),
		Overlay = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			ref = setState
		}),
		Content = 0
	}

	local v12 = if state then React.createElement(Foundation.OverlayProvider, {
		gui = state
	}, {
		Providers = React.createElement(inExperienceProviderContainer, {}, v8)
	}) else nil
	v11.Content = v12
	return createElement(coreScriptsRootProvider, {}, v11)
end

return AccountUpgradePromptApp
