local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local PromptAssignmentAction = require(Modules.LuaApp.Enum.AccountSecurity.PromptAssignmentAction)
local PromptConstants = require(Modules.LuaApp.Components.AccountSecurity.Common.PromptConstants)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UpdatePromptAssignment = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptAssignment)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t1 = {
	action = "Feature.AccountSecurityPrompt.Action.AuthenticatorUpsellNextButtonMessage",
	downloadInstruction = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellDownloadInstruction",
	header = "Feature.AccountSecurityPrompt.Header.AuthenticatorUpsellDownloadAuthenticator",
	googleAuthenticator = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellGoogleOption",
	microsoftAuthenticator = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellMicrosoftOption",
	twilioAuthenticator = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellTwilioOption",
	settingsTitle = "CommonUI.Features.Label.Settings"
}
local v24 = Roact.PureComponent:extend("InstallApps")
local Medium = IconSize.Medium
local v26 = Images["icons/status/success"]
local uDim = UDim.new(0, 10)

function v24.init(p1) -- line: 43
	-- upvalues: PromptConstants (copy), PromptAssignmentAction (copy)
	p1:setState({
		requestInFlight = false
	})

	function p1.continueToAuthenticatorAppScreen(p2) -- line: 50
		-- upvalues: p1 (copy), PromptConstants (copy), PromptAssignmentAction (copy)
		return function() -- line: 51
			-- upvalues: p1 (copy), PromptConstants (copy), p2 (copy), PromptAssignmentAction (copy)
			p1:setState({
				requestInFlight = true
			})
			p1.props.openWebView(PromptConstants.getWebViewUrlAccountSettings(), p2.settingsTitle)
			p1.props.closeOverlay()
			p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, PromptAssignmentAction.DismissPrompt)
		end
	end
	function p1.closeCallback() -- line: 67
		-- upvalues: p1 (copy), PromptAssignmentAction (copy)
		p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, PromptAssignmentAction.DismissPrompt)
	end
end
function v24.render(p3) -- line: 76
	-- upvalues: UIBlox (copy), withLocalization (copy), t1 (copy), Roact (copy), ModalBase (copy), ModalBodyText (copy), uDim (copy), ImageSetLabel (copy), v26 (copy), getIconSizeUDim2 (copy), Medium (copy), ModalButtonConfig (copy), ButtonType (copy)
	local requestInFlight = p3.state.requestInFlight

	return UIBlox.Style.withStyle(function(p4) -- line: 79
		-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), ModalBase (copy), p3 (copy), ModalBodyText (copy), uDim (copy), ImageSetLabel (copy), v26 (copy), getIconSizeUDim2 (copy), Medium (copy), ModalButtonConfig (copy), requestInFlight (copy), ButtonType (copy)
		local SystemPrimaryDefaultColor = p4.Theme.SystemPrimaryDefault.Color

		return withLocalization(t1)(function(p5) -- line: 81
			-- upvalues: Roact (copy), ModalBase (copy), p3 (copy), ModalBodyText (copy), uDim (copy), ImageSetLabel (copy), v26 (copy), SystemPrimaryDefaultColor (copy), getIconSizeUDim2 (copy), Medium (copy), ModalButtonConfig (copy), requestInFlight (copy), ButtonType (copy)
			return Roact.createElement(ModalBase, {
				title = p5.header,
				closeCallback = p3.closeCallback,
				makeBodyFragment = function(p6) -- line: 85
					-- upvalues: Roact (copy), ModalBodyText (copy), p5 (copy), uDim (copy), ImageSetLabel (copy), v26 (copy), SystemPrimaryDefaultColor (copy), getIconSizeUDim2 (copy), Medium (copy)
					return Roact.createFragment({
						BEFORE_TEXT = Roact.createElement(ModalBodyText, {
							layoutOrder = 1,
							useBold = true,
							contentWidth = p6,
							text = p5.downloadInstruction
						}),
						ROWS_WRAPPER = Roact.createElement("Frame", {
							Transparency = 1,
							LayoutOrder = 2,
							AutomaticSize = Enum.AutomaticSize.XY
						}, {
							WrappingListWrapper = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								Padding = uDim
							}),
							FIRST_ROW = Roact.createElement("Frame", {
								Transparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY
							}, {
								WrappingListA = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = uDim
								}),
								CheckmarkIconA = Roact.createElement(ImageSetLabel, {
									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Image = v26,
									ImageColor3 = SystemPrimaryDefaultColor,
									Size = getIconSizeUDim2(Medium)
								}),
								MicrosoftAuthenticator = Roact.createElement(ModalBodyText, {
									contentWidth = 0,
									useBold = true,
									alignLeft = true,
									text = p5.microsoftAuthenticator
								})
							}),
							SECOND_ROW = Roact.createElement("Frame", {
								Transparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY
							}, {
								WrappingListB = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = uDim
								}),
								CheckmarkIconB = Roact.createElement(ImageSetLabel, {
									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Image = v26,
									ImageColor3 = SystemPrimaryDefaultColor,
									Size = getIconSizeUDim2(Medium)
								}),
								GoogleAuthenticator = Roact.createElement(ModalBodyText, {
									contentWidth = 0,
									useBold = true,
									alignLeft = true,
									text = p5.googleAuthenticator
								})
							}),
							THIRD_ROW = Roact.createElement("Frame", {
								Transparency = 1,
								AutomaticSize = Enum.AutomaticSize.XY
							}, {
								WrappingListC = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = uDim
								}),
								CheckmarkIconC = Roact.createElement(ImageSetLabel, {
									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Image = v26,
									ImageColor3 = SystemPrimaryDefaultColor,
									Size = getIconSizeUDim2(Medium)
								}),
								TwilioAuthenticator = Roact.createElement(ModalBodyText, {
									contentWidth = 0,
									useBold = true,
									alignLeft = true,
									text = p5.twilioAuthenticator
								})
							})
						})
					})
				end,
				buttonConfig = ModalButtonConfig({{
					isDisabled = requestInFlight,
					isLoading = requestInFlight,
					onActivated = p3.continueToAuthenticatorAppScreen(p5),
					text = p5.action,
					type = ButtonType.PrimarySystem
				}})
			})
		end)
	end)
end

local v28 = RoactRodux.connect(function(_, _) -- line: 190
	return {}
end, function(p9) -- line: 192
	-- upvalues: CloseCentralOverlay (copy), OpenWebview (copy), UpdatePromptAssignment (copy)
	return {
		closeOverlay = function() -- line: 194
			-- upvalues: p9 (copy), CloseCentralOverlay (copy)
			return p9(CloseCentralOverlay())
		end,
		openWebView = function(p10, p11) -- line: 197
			-- upvalues: p9 (copy), OpenWebview (copy)
			return p9(OpenWebview(p10, p11))
		end,
		updatePromptAssignment = function(p12, p13, p14) -- line: 200
			-- upvalues: p9 (copy), UpdatePromptAssignment (copy)
			return p9(UpdatePromptAssignment(p12, p13, p14))
		end
	}
end)(v24)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v28))
