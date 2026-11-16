local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/fvl")
local module2 = require("@luauforge/deferred/hNd")
local module3 = require("@luauforge/deferred/hNe")
local module4 = require("@luauforge/deferred/hNf")
local module5 = require("@luauforge/bundled/fsr")
local module6 = require("@luauforge/bundled/fss")
local module7 = require("@luauforge/bundled/fst")
local module8 = require("@luauforge/bundled/dYT")
local module9 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module10 = require("@luauforge/bundled/fsv")
local module11 = require("@luauforge/bundled/edC")

local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local v5 = {
	action = "Feature.AccountSecurityPrompt.Action.AuthenticatorUpsellNextButtonMessage",
	downloadInstruction = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellDownloadInstruction",
	header = "Feature.AccountSecurityPrompt.Header.AuthenticatorUpsellDownloadAuthenticator",
	googleAuthenticator = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellGoogleOption",
	microsoftAuthenticator = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellMicrosoftOption",
	twilioAuthenticator = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellTwilioOption",
	settingsTitle = "CommonUI.Features.Label.Settings"
}

local extended = Roact.PureComponent:extend("InstallApps")

local medium = iconSize.Medium
local iconsstatussuccess = images["icons/status/success"]
local udim = UDim.new(0, 10)

function extended:init()
	self:setState({ requestInFlight = false })

	function self.continueToAuthenticatorAppScreen(p2)
		return function()
			self:setState({ requestInFlight = true })

			self.props.openWebView(module7.getWebViewUrlAccountSettings(), p2.settingsTitle)
			self.props.closeOverlay()
			self.props.updatePromptAssignment(
				self.props.networking,
				self.props.promptType,
				module6.DismissPrompt
			)
		end
	end

	function self.closeCallback()
		self.props.updatePromptAssignment(
			self.props.networking,
			self.props.promptType,
			module6.DismissPrompt
		)
	end
end

function extended.render(data)
	local requestInFlight = data.state.requestInFlight

	return UIBlox.Style.withStyle(function(p2)
		local color = p2.Theme.SystemPrimaryDefault.Color
		return module11(v5)(function(props)
			return Roact.createElement(module2, {
				title = props.header,
				closeCallback = data.closeCallback,
				makeBodyFragment = function(p3)
					return Roact.createFragment({
						BEFORE_TEXT = Roact.createElement(module3, {
							layoutOrder = 1,
							contentWidth = p3,
							text = props.downloadInstruction,
							useBold = true
						}),
						ROWS_WRAPPER = Roact.createElement(
							"Frame",
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								Transparency = 1,
								LayoutOrder = 2
							},
							{
								WrappingListWrapper = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Vertical,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									Padding = udim
								}),
								FIRST_ROW = Roact.createElement(
									"Frame",
									{
										AutomaticSize = Enum.AutomaticSize.XY,
										Transparency = 1
									},
									{
										WrappingListA = Roact.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = udim
										}),
										CheckmarkIconA = Roact.createElement(imageSetLabel, {
											Image = iconsstatussuccess,
											BorderSizePixel = 0,
											ImageColor3 = color,
											BackgroundTransparency = 1,
											Size = getIconSizeUDim2(medium)
										}),
										MicrosoftAuthenticator = Roact.createElement(module3, {
											contentWidth = 0,
											text = props.microsoftAuthenticator,
											useBold = true,
											alignLeft = true
										})
									}
								),
								SECOND_ROW = Roact.createElement(
									"Frame",
									{
										AutomaticSize = Enum.AutomaticSize.XY,
										Transparency = 1
									},
									{
										WrappingListB = Roact.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = udim
										}),
										CheckmarkIconB = Roact.createElement(imageSetLabel, {
											Image = iconsstatussuccess,
											BorderSizePixel = 0,
											ImageColor3 = color,
											BackgroundTransparency = 1,
											Size = getIconSizeUDim2(medium)
										}),
										GoogleAuthenticator = Roact.createElement(module3, {
											contentWidth = 0,
											text = props.googleAuthenticator,
											useBold = true,
											alignLeft = true
										})
									}
								),
								THIRD_ROW = Roact.createElement(
									"Frame",
									{
										AutomaticSize = Enum.AutomaticSize.XY,
										Transparency = 1
									},
									{
										WrappingListC = Roact.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = udim
										}),
										CheckmarkIconC = Roact.createElement(imageSetLabel, {
											Image = iconsstatussuccess,
											BorderSizePixel = 0,
											ImageColor3 = color,
											BackgroundTransparency = 1,
											Size = getIconSizeUDim2(medium)
										}),
										TwilioAuthenticator = Roact.createElement(module3, {
											contentWidth = 0,
											text = props.twilioAuthenticator,
											useBold = true,
											alignLeft = true
										})
									}
								)
							}
						)
					})
				end,
				buttonConfig = module4({
					{
						isDisabled = requestInFlight,
						isLoading = requestInFlight,
						onActivated = data.continueToAuthenticatorAppScreen(props),
						text = props.action,
						type = buttonType.PrimarySystem
					}
				})
			})
		end)
	end)
end

local v6 = RoactRodux.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		closeOverlay = function()
			return callback(module())
		end,
		openWebView = function(p2, p3)
			return callback(module5(p2, p3))
		end,
		updatePromptAssignment = function(p2, p3, p4)
			return callback(module10(p2, p3, p4))
		end
	}
end)(extended)

return (roactServices.connect({ analytics = module8, networking = module9 })(v6))
