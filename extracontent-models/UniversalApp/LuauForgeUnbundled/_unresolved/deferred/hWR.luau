local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local module2 = require("@luauforge/bundled/fCM")
local module3 = require("@luauforge/bundled/egZ")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module4 = require("@luauforge/bundled/dzD")

local extended = Roact.PureComponent:extend("LeaveRobloxAlert")

function extended:init()
	function self.closeAlert()
		self.props.closeAlert()
	end
end

function extended.render(p2)
	local continueFunc = p2.props.continueFunc

	return module3({
		titleText = "Feature.GameDetails.Message.LeavingRobloxTitle",
		bodyText = "Feature.GameDetails.Message.ExternalLinkWarning",
		cancelButtonText = "Feature.GamePage.LabelCancelField",
		confirmButtonText = "Feature.GameDetails.Action.Continue"
	})(function(props)
		return (Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = module4.Color.BLACK,
			BackgroundTransparency = 1,
			Active = true,
			Selectable = false
		}, {
			AlertWindow = Roact.createElement(interactiveAlert, {
				title = props.titleText,
				bodyText = props.bodyText,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.Secondary,
							props = {
								onActivated = p2.closeAlert,
								text = props.cancelButtonText
							}
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = {
								onActivated = continueFunc,
								text = props.confirmButtonText
							}
						}
					}
				},
				screenSize = p2.props.screenSize
			})
		}))
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closeAlert = function()
			return callback(module2())
		end
	}
end)(extended)

return (roactServices.connect({ localization = module })(v5))
