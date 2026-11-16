local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local t = require(CorePackages.Packages.t)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appUpdateService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUpdateService

local module = require("@luauforge/bundled/edC")
local module2 = require("@luauforge/bundled/edP")
local updateMessageType = require("@luauforge/bundled/hMi").UpdateMessageType

local extended = Roact.PureComponent:extend("UpdateRequiredPrompt")

extended.validateProps = t.interface({
	canPerformBinaryUpdate = t.optional(t.boolean),
	showInternalChannelMessage = t.optional(t.boolean),
	updateMessageType = t.optional(t.string),
	closeOverlay = t.callback,
	screenSize = t.Vector2,
	appUpdateService = t.table
})

function extended:init()
	function self.performManagedUpdate()
		self.props.appUpdateService:performManagedUpdate()
	end
end

function extended.render(p2)
	local v5

	if p2.props.updateMessageType then
		v5 = p2.props.updateMessageType == updateMessageType.BetaProgram
			and "CommonUI.Controls.Label.BetaProgramUpdateMessage"
			or p2.props.updateMessageType == updateMessageType.InternalChannel
			and "CommonUI.Controls.Label.ChannelConfigurationUpdateMessage"
			or "CommonUI.Controls.Label.ForceUpdateBody"
	else
		v5 = p2.props.showInternalChannelMessage
			and "CommonUI.Controls.Label.ChannelConfigurationUpdateMessage"
			or "CommonUI.Controls.Label.ForceUpdateBody"
	end

	return module({
		titleText = "CommonUI.Controls.Label.ForceUpdateTitle",
		bodyText = v5,
		buttonText = "CommonUI.Controls.Action.CloseRoblox",
		cancelButtonText = "Feature.GamePage.LabelCancelField"
	})(function(props)
		return (Roact.createElement(interactiveAlert, {
			screenSize = p2.props.screenSize,
			title = props.titleText,
			bodyText = props.bodyText,
			buttonStackInfo = {
				buttons = { if p2.props.canPerformBinaryUpdate then {
						buttonType = buttonType.PrimarySystem,
						props = {
							text = props.buttonText,
							onActivated = p2.performManagedUpdate
						}
					} else {
						buttonType = buttonType.Secondary,
						props = {
							text = props.cancelButtonText,
							onActivated = p2.props.closeOverlay
						}
					} }
			}
		}))
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closeOverlay = function()
			callback(module2())
		end
	}
end)(extended)

return roactServices.connect({ appUpdateService = appUpdateService })(v5)
