local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local module2 = require("@luauforge/bundled/egZ")

local module3 = require("@luauforge/deferred/hWp")
local module4 = require("@luauforge/bundled/fCM")

local module5 = require("@luauforge/bundled/eha")

local extended = Roact.PureComponent:extend("ConfirmSignOut")

function extended.render(p2)
	local theme = p2.props.theme
	local containerWidth = p2.props.containerWidth
	local closeAlert = p2.props.closeAlert
	local continueFunc = p2.props.continueFunc
	local localization = p2.props.localization

	local function fn(props)
		return Roact.createElement(module3, {
			theme = theme,
			containerWidth = containerWidth,
			titleText = props.titleText,
			titleFont = theme.AlertWindow.Title.Font,
			messageText = props.messageText,
			messageFont = theme.AlertWindow.Title.Font,
			buttonFont = theme.AlertWindow.Button.Font,
			confirmButtonText = props.confirmButtonText,
			onConfirm = continueFunc,
			isConfirming = false,
			hasCancelButton = true,
			onCancel = closeAlert
		})
	end

	if module5() then
		return module2({
			titleText = "Application.Logout.Title.Logout",
			messageText = "Application.Logout.Message.Confirmation",
			confirmButtonText = "Application.Logout.Action.Logout",
			cancelButtonText = "Feature.GamePage.LabelCancelField"
		})(fn)
	end

	return fn({
		titleText = localization:Format("Application.Logout.Title.Logout"),
		messageText = localization:Format("Application.Logout.Message.Confirmation"),
		confirmButtonText = localization:Format("Application.Logout.Action.Logout"),
		cancelButtonText = localization:Format("Feature.GamePage.LabelCancelField")
	})
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		closeAlert = function()
			return callback(module4())
		end
	}
end)(extended)

return (roactServices.connect({ localization = module })(v5))
