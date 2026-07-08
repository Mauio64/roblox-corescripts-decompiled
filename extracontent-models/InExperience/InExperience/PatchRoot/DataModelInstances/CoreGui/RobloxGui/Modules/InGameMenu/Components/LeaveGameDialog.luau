local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local CancelLeavingGame = require(ParentParent.Actions.CancelLeavingGame)
local GlobalConfig = require(ParentParent.GlobalConfig)
local ConfirmationDialog = require(script.Parent.ConfirmationDialog)
local Constants = require(ParentParent.Resources.Constants)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local v15 = t.strictInterface({
	isLeavingGame = t.boolean,
	onCancel = t.callback,
	sendAnalytics = t.callback
})

local function LeaveGameDialog(p1) -- line: 31
	-- upvalues: GlobalConfig (copy), v15 (copy), withLocalization (copy), Roact (copy), ConfirmationDialog (copy), SendAnalytics (copy), Constants (copy), RunService (copy), GetDefaultQualityLevel (copy)
	if GlobalConfig.propValidation then
		assert(v15(p1))
	end

	return withLocalization({
		bodyText = "CoreScripts.InGameMenu.ConfirmLeaveGame",
		confirmText = "CoreScripts.InGameMenu.Leave",
		titleText = "CoreScripts.InGameMenu.LeaveGameQuestion",
		cancelText = "CoreScripts.InGameMenu.Cancel"
	})(function(p2) -- line: 41
		-- upvalues: Roact (copy), ConfirmationDialog (copy), p1 (copy), SendAnalytics (copy), Constants (copy), RunService (copy), GetDefaultQualityLevel (copy)
		return Roact.createElement(ConfirmationDialog, {
			bindReturnToConfirm = true,
			blurBackground = true,
			bodyText = p2.bodyText,
			confirmText = p2.confirmText,
			titleText = p2.titleText,
			cancelText = p2.cancelText,
			onCancel = p1.onCancel,
			onConfirm = function() -- line: 51
				-- upvalues: SendAnalytics (copy), Constants (copy), RunService (copy), GetDefaultQualityLevel (copy)
				SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
					confirmed = Constants.AnalyticsConfirmedName
				})
				RunService.Heartbeat:Wait()
				game:Shutdown()
				settings().Rendering.QualityLevel = GetDefaultQualityLevel()
			end,
			visible = p1.isLeavingGame
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 69
	return {
		isLeavingGame = p3.leavingGame
	}
end, function(p5) -- line: 73
	-- upvalues: CancelLeavingGame (copy), SendAnalytics (copy), Constants (copy)
	return {
		onCancel = function() -- line: 75
			-- upvalues: p5 (copy), CancelLeavingGame (copy), SendAnalytics (copy), Constants (copy)
			p5(CancelLeavingGame())
			SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
				confirmed = Constants.AnalyticsCancelledName
			})
		end
	}
end)(LeaveGameDialog)
