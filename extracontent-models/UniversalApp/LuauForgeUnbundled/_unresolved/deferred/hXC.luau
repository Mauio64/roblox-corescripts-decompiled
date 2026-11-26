local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local module = require("@luauforge/bundled/fCM")

local v5 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRegisterQRCodeKeyInEngine
	and "ProfileQrCodeCameraSettingsModalSeen"
	or "ScreenshotEventTracking"

local extended = Roact.PureComponent:extend("CameraPermissionPrompt")

function extended:renderAlertLocalized(props)
	local v6 = {
		props = { onActivated = self.props.closePrompt, text = props.gotItButtonText }
	}

	return Roact.createElement(interactiveAlert, {
		title = props.titleText,
		bodyText = props.messageText,
		buttonStackInfo = {
			buttons = { v6 }
		},
		screenSize = self.props.screenSize
	})
end

function extended.didMount(p2)
	AppStorageService:SetItem(v5, "true")
	AppStorageService:Flush()
end

function extended:render()
	return withLocalization({
		titleText = "Feature.AddFriends.Title.CameraPermission",
		messageText = "Feature.AddFriends.Description.CameraPermissionWarning",
		gotItButtonText = "Feature.Avatar.Action.GotIt"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

local function mapStateToProps(p2, p3)
	return { screenSize = p2.ScreenSize }
end

local function mapDispatchToProps(callback)
	return {
		closePrompt = function()
			callback(module())
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))
