local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/fvl")
local module2 = require("@luauforge/deferred/hNd")
local module3 = require("@luauforge/deferred/hNe")
local module4 = require("@luauforge/deferred/hNf")
local module5 = require("@luauforge/bundled/fso")
local module6 = require("@luauforge/bundled/fss")
local module7 = require("@luauforge/bundled/dYT")
local module8 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module9 = require("@luauforge/bundled/fsv")
local module10 = require("@luauforge/bundled/edC")

local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local v5 = {
	action = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellSetupAuthenticatorButtonMessage",
	descriptionEnd = "Feature.AccountSecurityPrompt.Description.ChangeYourPassword",
	descriptionStart = "Feature.AccountSecurityPrompt.Description.UnusualActivity",
	header = "Feature.AccountSecurityPrompt.Header.AuthenticatorUpsellWelcomeMessage",
	keepBadActorsOutHeadline = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellBadActorHeadline",
	keepBadActorsOutMessage = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellBadActorMessage",
	protectGamesRobuxHeadline = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellProtectRobuxHeadline",
	protectGamesRobuxMessage = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellProtectRobuxMessage",
	twoFactorsBetterThanOneHeadline = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellTwoFactorHeadline",
	twoFactorsBetterThanOneMessage = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellTwoFactorMessage"
}

local extended = Roact.PureComponent:extend("Intro")

local xLarge = iconSize.XLarge

local v6 = getIconSize(xLarge) + 6 - 13

local udim = UDim.new(0, 10)
local udim2 = UDim.new(0, 3)
local udim3 = UDim.new(6, 6)

function extended:init()
	self:setState({ requestInFlight = false })

	function self.continueToAuthenticatorAppScreen(p2)
		return function()
			self:setState({ requestInFlight = true })

			self.props.navigateToModalState(module5.AuthenticatorUpsellInstallApps)
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
		return module10(v5)(function(props)
			return Roact.createElement(module2, {
				title = props.header,
				closeCallback = data.closeCallback,
				makeBodyFragment = function(p3)
					return Roact.createFragment({
						ROWS_WRAPPER = Roact.createElement(
							"Frame",
							{ AutomaticSize = Enum.AutomaticSize.XY, Transparency = 1 },
							{
								WrappingListWrapper = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Vertical,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = udim
								}),
								FIRST_ROW = Roact.createElement(
									"Frame",
									{
										AutomaticSize = Enum.AutomaticSize.Y,
										Transparency = 1
									},
									{
										WrappingListB = Roact.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = udim3
										}),
										Left_ProtectGamesRobuxImage = Roact.createElement(imageSetLabel, {
											Image = images["icons/graphic/connectdevices_2xl"],
											BorderSizePixel = 0,
											BackgroundTransparency = 1,
											Size = getIconSizeUDim2(xLarge)
										}),
										SubFrame = Roact.createElement(
											"Frame",
											{
												AutomaticSize = Enum.AutomaticSize.XY,
												Transparency = 1
											},
											{
												ASubList = Roact.createElement("UIListLayout", {
													FillDirection = Enum.FillDirection.Vertical,
													Padding = udim2
												}),
												Right_TwoFactorsTextA = Roact.createElement(module3, {
													contentWidth = p3 - v6,
													text = props.twoFactorsBetterThanOneHeadline,
													useBold = true,
													alignLeft = true
												}),
												Right_TwoFactorsTextB = Roact.createElement(module3, {
													contentWidth = p3 - v6,
													text = props.twoFactorsBetterThanOneMessage,
													useBold = false,
													alignLeft = true
												})
											}
										)
									}
								),
								SECOND_ROW = Roact.createElement(
									"Frame",
									{
										AutomaticSize = Enum.AutomaticSize.Y,
										Transparency = 1
									},
									{
										WrappingListB = Roact.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = udim3
										}),
										Left_ProtectGamesRobuxImage = Roact.createElement(imageSetLabel, {
											Image = images["icons/graphic/gamesanditems_2xl"],
											BorderSizePixel = 0,
											BackgroundTransparency = 1,
											Size = getIconSizeUDim2(xLarge)
										}),
										SubFrame = Roact.createElement(
											"Frame",
											{
												AutomaticSize = Enum.AutomaticSize.XY,
												Transparency = 1
											},
											{
												ASubList = Roact.createElement("UIListLayout", {
													FillDirection = Enum.FillDirection.Vertical,
													Padding = udim2
												}),
												Right_ProtectGamesRobuxHeadline = Roact.createElement(module3, {
													contentWidth = p3 - v6,
													text = props.protectGamesRobuxHeadline,
													useBold = true,
													alignLeft = true
												}),
												Right_ProtectGamesRobuxMessage = Roact.createElement(module3, {
													contentWidth = p3 - v6,
													text = props.protectGamesRobuxMessage,
													useBold = false,
													alignLeft = true
												})
											}
										)
									}
								),
								THIRD_ROW = Roact.createElement(
									"Frame",
									{
										AutomaticSize = Enum.AutomaticSize.Y,
										Transparency = 1
									},
									{
										WrappingListC = Roact.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											Padding = udim3
										}),
										Left_KeepBadActorsImage = Roact.createElement(imageSetLabel, {
											Image = images["icons/graphic/blocktheft_2xl"],
											BorderSizePixel = 0,
											BackgroundTransparency = 1,
											Size = getIconSizeUDim2(xLarge)
										}),
										SubFrame = Roact.createElement(
											"Frame",
											{
												AutomaticSize = Enum.AutomaticSize.XY,
												Transparency = 1
											},
											{
												ASubList = Roact.createElement("UIListLayout", {
													FillDirection = Enum.FillDirection.Vertical,
													Padding = udim2
												}),
												Right_TwoFactorsTextA = Roact.createElement(module3, {
													contentWidth = p3 - v6,
													text = props.keepBadActorsOutHeadline,
													useBold = true,
													alignLeft = true
												}),
												Right_TwoFactorsTextB = Roact.createElement(module3, {
													contentWidth = p3 - v6,
													text = props.keepBadActorsOutMessage,
													useBold = false,
													alignLeft = true
												})
											}
										)
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

local v7 = RoactRodux.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		closeOverlay = function()
			return callback(module())
		end,
		updatePromptAssignment = function(p2, p3, p4)
			return callback(module9(p2, p3, p4))
		end
	}
end)(extended)

return (roactServices.connect({ analytics = module7, networking = module8 })(v7))
