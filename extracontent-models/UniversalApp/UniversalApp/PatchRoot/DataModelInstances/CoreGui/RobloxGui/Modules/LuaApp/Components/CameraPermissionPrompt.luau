local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local InteractiveAlert = require(CorePackages.Packages.UIBlox).App.Dialog.Alert.InteractiveAlert
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local v9 = not require(CorePackages.Workspace.Packages.SharedFlags).FFlagRegisterQRCodeKeyInEngine and "ScreenshotEventTracking" or "ProfileQrCodeCameraSettingsModalSeen"
local v10 = Roact.PureComponent:extend("CameraPermissionPrompt")

function v10.renderAlertLocalized(p1, p2) -- line: 20
	-- upvalues: Roact (copy), InteractiveAlert (copy)
	local t1 = {
		props = {
			onActivated = p1.props.closePrompt,
			text = p2.gotItButtonText
		}
	}

	return Roact.createElement(InteractiveAlert, {
		title = p2.titleText,
		bodyText = p2.messageText,
		buttonStackInfo = {
			buttons = { t1 }
		},
		screenSize = p1.props.screenSize
	})
end
function v10.didMount(_) -- line: 37
	-- upvalues: AppStorageService (copy), v9 (copy)
	AppStorageService:SetItem(v9, "true")
	AppStorageService:Flush()
end
function v10.render(p4) -- line: 42
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Feature.AddFriends.Title.CameraPermission",
		messageText = "Feature.AddFriends.Description.CameraPermissionWarning",
		gotItButtonText = "Feature.Avatar.Action.GotIt"
	})(function(p5) -- line: 47
		-- upvalues: p4 (copy)
		return p4:renderAlertLocalized(p5)
	end)
end

local function mapStateToProps(p6, _) -- line: 52
	return {
		screenSize = p6.ScreenSize
	}
end
local function mapDispatchToProps(p8) -- line: 58
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closePrompt = function() -- line: 60
			-- upvalues: p8 (copy), CloseCentralOverlay (copy)
			p8(CloseCentralOverlay())
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v10))
