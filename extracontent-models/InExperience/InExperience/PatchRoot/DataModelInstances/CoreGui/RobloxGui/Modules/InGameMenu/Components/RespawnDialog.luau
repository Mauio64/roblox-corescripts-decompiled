local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux

local IGMRespawnControllerBar = require(script.Parent.IGMRespawnControllerBar)

local parent = script.Parent.Parent

local withLocalization = require(parent.Localization.withLocalization)

local SetRespawning = require(parent.Actions.SetRespawning)
local RespawnPlayer = require(parent.Thunks.RespawnPlayer)

local ConfirmationDialog = require(script.Parent.ConfirmationDialog)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local function RespawnDialog(data)
	local function renderRespawnDialogControllerBar() -- 1 equivalent call inferred from this helper
		return Roact.createElement(IGMRespawnControllerBar, { inputType = data.inputType })
	end

	return withLocalization({
		titleText = "CoreScripts.InGameMenu.RespawnCharacterDialogTitle",
		bodyText = "CoreScripts.InGameMenu.RespawnCharacterDialogBody",
		confirmText = "CoreScripts.InGameMenu.RespawnCharacterDialogConfirm",
		cancelText = "CoreScripts.InGameMenu.Cancel"
	})(function(props)
		return Roact.createFragment({
			RespawnDialogControllerBar = data.isRespawning and renderRespawnDialogControllerBar() or nil, -- inferred equivalent call
			ConfirmationDialog = Roact.createElement(ConfirmationDialog, {
				visible = data.isRespawning,
				titleText = props.titleText,
				bodyText = props.bodyText,
				confirmText = props.confirmText,
				cancelText = props.cancelText,
				bindReturnToConfirm = true,
				onCancel = data.onCancel,
				onConfirm = data.onConfirm,
				inputType = data.inputType
			})
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isRespawning = p.respawn.dialogOpen, inputType = p.displayOptions.inputType }
end, function(callback)
	return {
		onCancel = function()
			callback(SetRespawning(false))
			SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsRespawnCharacterName, {
				confirmed = Constants.AnalyticsCancelledName
			})
		end,
		onConfirm = function()
			callback(RespawnPlayer)
		end
	}
end)(RespawnDialog)
