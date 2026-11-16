local Players = game:GetService("Players")

local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local InExperienceContainer = require(parent.InExperienceContainer)
local InExperienceProviderContainer = InExperienceContainer.InExperienceProviderContainer

require(AccountUpgrade.AccountUpgradeFlow)
local AccountUpgradeContainer = require(AccountUpgrade.Components.AccountUpgradeContainer)
local AccountUpgradeSuccessView = require(AccountUpgrade.SuccessModal.AccountUpgradeSuccessView)
local respawnIntoExperience = require(script.Parent.respawnIntoExperience)
local resolveSuccessIdentity = require(script.Parent.resolveSuccessIdentity)

local FStringAccountUpgradeLinkedAccountType = require(AccountUpgrade.Flags.FStringAccountUpgradeLinkedAccountType)

local function AccountUpgradePromptApp(props)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	local localPlayer = Players.LocalPlayer
	local name

	if localPlayer then
		name = localPlayer.Name
	end

	local onComplete = props.onComplete
	local onSignUpComplete = React.useCallback(function(p)
		if p.isSuccess then
			setState2(p)
		end
	end, {})

	local v = React.useCallback(function()
		local v = state2

		if v ~= nil then
			onComplete(v)
		end
	end, { onComplete, state2 })

	local onRespawnNow = React.useCallback(function()
		v()
		respawnIntoExperience()
	end, { v })
	local v2

	if state2 == nil then
		v2 = React.createElement(AccountUpgradeContainer, {
			flow = props.flow,
			hasBackdrop = true,
			currentUsername = name,
			onClose = props.onDismiss,
			onSignUpComplete = onSignUpComplete
		})
	else
		local displayName

		if localPlayer then
			displayName = localPlayer.DisplayName
		end

		local successIdentity = resolveSuccessIdentity(state2, {
			username = name,
			displayName = displayName
		})

		v2 = React.createElement(AccountUpgradeSuccessView, {
			userId = not localPlayer and 0 or localPlayer.UserId,
			displayName = successIdentity.displayName,
			username = successIdentity.username,
			didUsernameChange = successIdentity.didUsernameChange,
			linkedAccountType = FStringAccountUpgradeLinkedAccountType,
			onRespawnNow = onRespawnNow,
			onApplyLater = v,
			onConfirm = v,
			hasBackdrop = true
		})
	end

	local createElement = React.createElement
	local v3 = {
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
	local content

	if state then
		content = React.createElement(Foundation.OverlayProvider, { gui = state }, {
			Providers = React.createElement(InExperienceProviderContainer, {}, v2)
		})
	end

	v3.Content = content
	return createElement(CoreScriptsRootProvider, {}, v3)
end

return AccountUpgradePromptApp
