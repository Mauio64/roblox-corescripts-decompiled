local ContentProvider = game:GetService("ContentProvider")
local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local ArgCheck = require(LoginV2Parent.ArgCheck)
local AuthAnalytics = require(LoginV2Parent.AuthAnalytics)
local React = require(LoginV2Parent.React)
local SharedFlags = require(LoginV2Parent.SharedFlags)
local useDesignTokens = require(LoginV2Parent.Style).useDesignTokens
local useLocalization = require(LoginV2Parent.Localization).Hooks.useLocalization
local TextButton = require(LoginV2Parent.UIBlox).App.Button.TextButton
local GetFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow
local enrolledInLuafiedRecoveryExperiment = require(LoginV2Parent.AuthCommon).Experiments.enrolledInLuafiedRecoveryExperiment
local authButtonClick = AuthAnalytics.Events.authButtonClick
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local LoginContext = require(LoginV2.Context.LoginContext)

local function NeedHelpButton(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), LoginContext (copy), useDesignTokens (copy), useLocalization (copy), ArgCheck (copy), authButtonClick (copy), EventStreamConstants (copy), GetFFlagEnableLuafiedRecoveryFlow (copy), enrolledInLuafiedRecoveryExperiment (copy), ContentProvider (copy), TextButton (copy)
	local v18 = React.useContext(LoginContext)
	local v19 = useDesignTokens()
	local v20 = useLocalization({
		needHelpButtonText = t1.textKey
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v19.Size.Size_300),
			PaddingBottom = UDim.new(0, v19.Size.Size_300)
		}),
		Button = React.createElement(TextButton, {
			fontStyle = "CaptionHeader",
			colorStyleDefault = "TextDefault",
			text = v20.needHelpButtonText,
			isDisabled = t1.isDisabled,
			onActivated = function() -- line: 43
				-- upvalues: t1 (copy), ArgCheck (copy), authButtonClick (copy), EventStreamConstants (copy), GetFFlagEnableLuafiedRecoveryFlow (copy), enrolledInLuafiedRecoveryExperiment (copy), v18 (copy), ContentProvider (copy)
				if t1.originPage then
					local v21 = ArgCheck.isNonEmptyString(t1.originPage, "props.originPage")

					authButtonClick(v21, EventStreamConstants.Button.NeedHelpLink, nil, nil)
				end

				if GetFFlagEnableLuafiedRecoveryFlow() and enrolledInLuafiedRecoveryExperiment() then
					v18.utils.openAccountRecovery(t1.identifierAutofill or "")

					return
				end

				local v22 = ContentProvider.BaseUrl .. "login/forgot-password-or-username"

				v18.utils.openWebView(v22)
			end,
			verticalPadding = v19.Size.Size_400,
			position = UDim2.new(0.5, 0, 0.5, 0),
			anchorPoint = Vector2.new(0.5, 0.5)
		})
	})
end

return NeedHelpButton
