local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/edC")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local module2 = require("@luauforge/deferred/hLH")
local module3 = require("@luauforge/bundled/fvl")

local module4 = require("@luauforge/bundled/fMG")
local module5 = require("@luauforge/bundled/fsy")

local extended = Roact.PureComponent:extend("AgreeToPhoneNumberVerification")

extended.defaultProps = { phoneNumber = "" }

function extended:init()
	function self.onConfirm()
		self.props.closeAlert()
		self.props.verificationChallengeCallback()
		self.props.authEventAnalytics.reportButtonClicked(
			module5.Context.SinglePageSignUpScreen,
			module5.Button.VerifyPhonePrompt
		)
	end
end

function extended.render(p2)
	return withStyle(function(p3)
		local theme = p3.Theme
		local containerWidth = p2.props.containerWidth
		local closeAlert = p2.props.closeAlert

		return module({
			titleText = "Feature.VerificationUpsell.Label.VerifyPhoneNumber",
			messageText = "Feature.VerificationUpsell.Message.Confirmation",
			confirmButtonText = "Feature.VerificationUpsell.Action.Ok",
			cancelButtonText = "Feature.VerificationUpsell.Action.Edit"
		})(function(props)
			return Roact.createElement(module2, {
				theme = theme,
				containerWidth = containerWidth,
				titleText = props.titleText,
				titleFont = p3.Font.Title.Font,
				messageText = string.gsub(props.messageText, "{phoneNumber}", p2.props.phoneNumber),
				messageFont = p3.Font.Body.Font,
				buttonFont = p3.Font.Body.Font,
				confirmButtonText = props.confirmButtonText,
				cancelButtonText = props.cancelButtonText,
				onConfirm = p2.onConfirm,
				isConfirming = false,
				hasCancelButton = true,
				onCancel = closeAlert
			})
		end)
	end)
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		closeAlert = function()
			return callback(module3())
		end
	}
end)(extended)

return (roactServices.connect({ authEventAnalytics = module4 })(v5))
