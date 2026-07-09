local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local t = require(CorePackages.Packages.t)
local Modules = CoreGui.RobloxGui.Modules
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppUpdateService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUpdateService
local withLocalization = require(Modules.LuaApp.withLocalization)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local UpdateMessageType = require(CorePackages.Workspace.Packages.RobloxAppUpdate).UpdateMessageType
local EngineFeature = game:GetEngineFeature("AutoUpgradeEngineFeatureOnly")
local v16 = Roact.PureComponent:extend("UpdateRequiredPrompt")

v16.validateProps = t.interface({
	canPerformBinaryUpdate = t.optional(t.boolean),
	showInternalChannelMessage = t.optional(t.boolean),
	updateMessageType = t.optional(t.string),
	closeOverlay = t.callback,
	screenSize = t.Vector2,
	appUpdateService = if not EngineFeature then nil else t.table
})

function v16.init(p1) -- line: 41
	function p1.performManagedUpdate() -- line: 42
		-- upvalues: p1 (copy)
		p1.props.appUpdateService:performManagedUpdate()
	end
end
function v16.render(p2) -- line: 47
	-- upvalues: UpdateMessageType (copy), withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local v20 = if not p2.props.updateMessageType then not p2.props.showInternalChannelMessage and "CommonUI.Controls.Label.ForceUpdateBody" or "CommonUI.Controls.Label.ChannelConfigurationUpdateMessage" else if p2.props.updateMessageType ~= UpdateMessageType.BetaProgram then p2.props.updateMessageType ~= UpdateMessageType.InternalChannel and "CommonUI.Controls.Label.ForceUpdateBody" or "CommonUI.Controls.Label.ChannelConfigurationUpdateMessage" else "CommonUI.Controls.Label.BetaProgramUpdateMessage"

	return withLocalization({
		titleText = "CommonUI.Controls.Label.ForceUpdateTitle",
		buttonText = "CommonUI.Controls.Action.CloseRoblox",
		cancelButtonText = "Feature.GamePage.LabelCancelField",
		bodyText = v20
	})(function(p3) -- line: 70
		-- upvalues: Roact (copy), InteractiveAlert (copy), p2 (copy), ButtonType (copy)
		return (Roact.createElement(InteractiveAlert, {
			screenSize = p2.props.screenSize,
			title = p3.titleText,
			bodyText = p3.bodyText,
			buttonStackInfo = {
				buttons = { if not p2.props.canPerformBinaryUpdate then {
					buttonType = ButtonType.Secondary,
					props = {
						text = p3.cancelButtonText,
						onActivated = p2.props.closeOverlay
					}
				} else {
					buttonType = ButtonType.PrimarySystem,
					props = {
						text = p3.buttonText,
						onActivated = p2.performManagedUpdate
					}
				} }
			}
		}))
	end)
end

local v17 = RoactRodux.connect(function(p4, _) -- line: 100
	return {
		screenSize = p4.ScreenSize
	}
end, function(p6) -- line: 104
	-- upvalues: SetCentralOverlay (copy)
	return {
		closeOverlay = function() -- line: 106
			-- upvalues: p6 (copy), SetCentralOverlay (copy)
			p6(SetCentralOverlay())
		end
	}
end)(v16)

return RoactServices.connect({
	appUpdateService = AppUpdateService
})(v17)
