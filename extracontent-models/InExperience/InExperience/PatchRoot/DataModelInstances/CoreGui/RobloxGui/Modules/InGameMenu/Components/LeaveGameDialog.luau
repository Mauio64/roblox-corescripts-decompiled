local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent

local withLocalization = require(parent.Localization.withLocalization)

local CancelLeavingGame = require(parent.Actions.CancelLeavingGame)

local GlobalConfig = require(parent.GlobalConfig)

local ConfirmationDialog = require(script.Parent.ConfirmationDialog)

local Constants = require(parent.Resources.Constants)

local SendAnalytics = require(parent.Utility.SendAnalytics)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local GetDefaultQualityLevel = AppCommonLib.GetDefaultQualityLevel

local strictInterface = t.strictInterface({
	isLeavingGame = t.boolean,
	onCancel = t.callback,
	sendAnalytics = t.callback
})

local function LeaveGameDialog(p)
	if GlobalConfig.propValidation then
		assert(strictInterface(p))
	end

	return withLocalization({
		bodyText = "CoreScripts.InGameMenu.ConfirmLeaveGame",
		confirmText = "CoreScripts.InGameMenu.Leave",
		titleText = "CoreScripts.InGameMenu.LeaveGameQuestion",
		cancelText = "CoreScripts.InGameMenu.Cancel"
	})(function(props)
		return Roact.createElement(ConfirmationDialog, {
			bodyText = props.bodyText,
			confirmText = props.confirmText,
			titleText = props.titleText,
			cancelText = props.cancelText,
			bindReturnToConfirm = true,
			onCancel = p.onCancel,
			onConfirm = function()
				SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
					confirmed = Constants.AnalyticsConfirmedName
				})

				RunService.Heartbeat:Wait()
				game:Shutdown()
				local settings = settings()
				settings.Rendering.QualityLevel = GetDefaultQualityLevel()
			end,
			blurBackground = true,
			visible = p.isLeavingGame
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isLeavingGame = p.leavingGame }
end, function(callback)
	return {
		onCancel = function()
			callback(CancelLeavingGame())
			SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
				confirmed = Constants.AnalyticsCancelledName
			})
		end
	}
end)(LeaveGameDialog)
