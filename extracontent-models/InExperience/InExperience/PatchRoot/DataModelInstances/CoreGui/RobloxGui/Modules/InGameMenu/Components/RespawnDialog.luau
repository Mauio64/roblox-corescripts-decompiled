local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local IGMRespawnControllerBar = require(script.Parent.IGMRespawnControllerBar)
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local SetRespawning = require(ParentParent.Actions.SetRespawning)
local RespawnPlayer = require(ParentParent.Thunks.RespawnPlayer)
local ConfirmationDialog = require(script.Parent.ConfirmationDialog)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)

local function RespawnDialog(p1) -- line: 22
	-- upvalues: Roact (copy), IGMRespawnControllerBar (copy), withLocalization (copy), ConfirmationDialog (copy)
	local function renderRespawnDialogControllerBar() -- line: 23
		-- upvalues: Roact (copy), IGMRespawnControllerBar (copy), p1 (copy)
		return Roact.createElement(IGMRespawnControllerBar, {
			inputType = p1.inputType
		})
	end

	return withLocalization({
		titleText = "CoreScripts.InGameMenu.RespawnCharacterDialogTitle",
		bodyText = "CoreScripts.InGameMenu.RespawnCharacterDialogBody",
		confirmText = "CoreScripts.InGameMenu.RespawnCharacterDialogConfirm",
		cancelText = "CoreScripts.InGameMenu.Cancel"
	})(function(p2) -- line: 34
		-- upvalues: Roact (copy), p1 (copy), IGMRespawnControllerBar (copy), ConfirmationDialog (copy)
		return Roact.createFragment({
			RespawnDialogControllerBar = p1.isRespawning and Roact.createElement(IGMRespawnControllerBar, {
				inputType = p1.inputType
			}) or nil,
			ConfirmationDialog = Roact.createElement(ConfirmationDialog, {
				bindReturnToConfirm = true,
				visible = p1.isRespawning,
				titleText = p2.titleText,
				bodyText = p2.bodyText,
				confirmText = p2.confirmText,
				cancelText = p2.cancelText,
				onCancel = p1.onCancel,
				onConfirm = p1.onConfirm,
				inputType = p1.inputType
			})
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 55
	return {
		isRespawning = p3.respawn.dialogOpen,
		inputType = p3.displayOptions.inputType
	}
end, function(p5) -- line: 60
	-- upvalues: SetRespawning (copy), SendAnalytics (copy), Constants (copy), RespawnPlayer (copy)
	return {
		onCancel = function() -- line: 62
			-- upvalues: p5 (copy), SetRespawning (copy), SendAnalytics (copy), Constants (copy)
			p5(SetRespawning(false))
			SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsRespawnCharacterName, {
				confirmed = Constants.AnalyticsCancelledName
			})
		end,
		onConfirm = function() -- line: 70
			-- upvalues: p5 (copy), RespawnPlayer (copy)
			p5(RespawnPlayer)
		end
	}
end)(RespawnDialog)
