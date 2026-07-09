local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local withLocalization = require(Modules.LuaApp.withLocalization)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local Constants = require(Modules.LuaApp.Constants)
local v13 = Roact.PureComponent:extend("ConfirmSignOutV2")

function v13.init(p1) -- line: 18
	function p1.closeAlert() -- line: 19
		-- upvalues: p1 (copy)
		p1.props.closeAlert()
	end
end
function v13.render(p2) -- line: 24
	-- upvalues: withLocalization (copy), Roact (copy), Constants (copy), InteractiveAlert (copy), ButtonType (copy)
	local continueFunc = p2.props.continueFunc

	return withLocalization({
		titleText = "Application.Logout.Title.Logout",
		messageText = "Application.Logout.Message.Confirmation",
		confirmButtonText = "Application.Logout.Action.Logout",
		cancelButtonText = "Feature.GamePage.LabelCancelField"
	})(function(p3) -- line: 32
		-- upvalues: Roact (copy), Constants (copy), InteractiveAlert (copy), ButtonType (copy), p2 (copy), continueFunc (copy)
		return (Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Active = true,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Constants.Color.BLACK
		}, {
			AlertWindow = Roact.createElement(InteractiveAlert, {
				title = p3.titleText,
				bodyText = p3.messageText,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.Secondary,
							props = {
								onActivated = p2.closeAlert,
								text = p3.cancelButtonText
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								onActivated = continueFunc,
								text = p3.confirmButtonText
							}
						}
					}
				},
				screenSize = p2.props.screenSize
			})
		}))
	end)
end

local v14 = RoactRodux.connect(function(p4, _) -- line: 69
	return {
		screenSize = p4.ScreenSize
	}
end, function(p6) -- line: 73
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeAlert = function() -- line: 75
			-- upvalues: p6 (copy), CloseCentralOverlay (copy)
			return p6(CloseCentralOverlay())
		end
	}
end)(v13)

return (RoactServices.connect({
	localization = RoactLocalization
})(v14))
