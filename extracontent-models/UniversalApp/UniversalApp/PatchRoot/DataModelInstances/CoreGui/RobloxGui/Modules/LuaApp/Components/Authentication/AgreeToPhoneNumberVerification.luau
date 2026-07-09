local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local v12 = Roact.PureComponent:extend("AgreeToPhoneNumberVerification")

v12.defaultProps = {
	phoneNumber = ""
}

function v12.init(p1) -- line: 22
	-- upvalues: EventStreamConstants (copy)
	function p1.onConfirm() -- line: 23
		-- upvalues: p1 (copy), EventStreamConstants (copy)
		p1.props.closeAlert()
		p1.props.verificationChallengeCallback()
		p1.props.authEventAnalytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.VerifyPhonePrompt)
	end
end
function v12.render(p2) -- line: 33
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), AlertWindow (copy)
	return withStyle(function(p3) -- line: 34
		-- upvalues: p2 (copy), withLocalization (copy), Roact (copy), AlertWindow (copy)
		local Theme = p3.Theme
		local containerWidth = p2.props.containerWidth
		local closeAlert = p2.props.closeAlert

		return withLocalization({
			titleText = "Feature.VerificationUpsell.Label.VerifyPhoneNumber",
			messageText = "Feature.VerificationUpsell.Message.Confirmation",
			confirmButtonText = "Feature.VerificationUpsell.Action.Ok",
			cancelButtonText = "Feature.VerificationUpsell.Action.Edit"
		})(function(p4) -- line: 44
			-- upvalues: Roact (copy), AlertWindow (copy), Theme (copy), containerWidth (copy), p3 (copy), p2 (copy), closeAlert (copy)
			return Roact.createElement(AlertWindow, {
				isConfirming = false,
				hasCancelButton = true,
				theme = Theme,
				containerWidth = containerWidth,
				titleText = p4.titleText,
				titleFont = p3.Font.Title.Font,
				messageText = string.gsub(p4.messageText, "{phoneNumber}", p2.props.phoneNumber),
				messageFont = p3.Font.Body.Font,
				buttonFont = p3.Font.Body.Font,
				confirmButtonText = p4.confirmButtonText,
				cancelButtonText = p4.cancelButtonText,
				onConfirm = p2.onConfirm,
				onCancel = closeAlert
			})
		end)
	end)
end

local v13 = RoactRodux.connect(nil, function(p5) -- line: 64
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeAlert = function() -- line: 66
			-- upvalues: p5 (copy), CloseCentralOverlay (copy)
			return p5(CloseCentralOverlay())
		end
	}
end)(v12)

return (RoactServices.connect({
	authEventAnalytics = RoactAnalyticsAuthEvents
})(v13))
