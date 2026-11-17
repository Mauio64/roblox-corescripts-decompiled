local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require(parent.React)
local Roact = require(parent.Roact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useStyle = UIBlox.Core.Style.useStyle
local LinkButton = UIBlox.App.Button.LinkButton
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local idvWithQRCodeUpsellStrings = LocalizationStrings.idvWithQRCodeUpsellStrings
local DirectionsTile = require(script.Parent.DirectionsTile)
local ProgressChecklist = require(script.Parent.ProgressChecklist)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function IDVDirectLinkUpsell(props)
	local featureName = props.featureName
	local v = useLocalization(idvWithQRCodeUpsellStrings)
	local v2 = useStyle()
	local onClose = props.onClose
	local openPrivacyPolicyLink = props.openPrivacyPolicyLink
	local baseSize = v2.Font.BaseSize
	local transparency = v2.Theme.TextEmphasis.Transparency
	local textSize = baseSize * v2.Font.CaptionBody.RelativeSize
	local analyticsService = props.analyticsService or AnalyticsService.EventStream
	local idvLink = props.idvLink
	local latestStepCompleted = props.latestStepCompleted
	local v3 = latestStepCompleted > 0
	local openIdvLink = props.openIdvLink
	local screenSize = useSelector(function(p)
		return p.ScreenSize
	end)

	local createElement = React.createElement
	local v4 = {
		title = v.title,
		screenSize = screenSize,
		onCloseClicked = React.useCallback(function()
			sendButtonClickEvent(analyticsService, AppScreens.IDVDirectLinkUpsell, featureName, "CloseModal")
			onClose()
		end, { analyticsService, featureName }),
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttonHeight = 36,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = React.useCallback(function()
							sendButtonClickEvent(
								analyticsService,
								AppScreens.IDVDirectLinkUpsell,
								featureName,
								"CloseModal"
							)
							onClose()
						end, { analyticsService, featureName }),
						text = v.cancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = React.useCallback(function()
							if idvLink ~= nil then
								sendButtonClickEvent(
									analyticsService,
									AppScreens.IDVDirectLinkUpsell,
									featureName,
									"OpenIdvLink"
								)

								openIdvLink(idvLink)
							end
						end, { openIdvLink, idvLink, analyticsService, featureName }),
						text = v.startVerification
					}
				}
			}
		}
	}

	local createElement2 = React.createElement
	local v5 = { AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 }

	local v6 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 24)
		}),
		DirectionsFrameOrProgressChecklist = 0,
		DisclaimerFrame = 0
	}
	local directionsFrameOrProgressChecklist

	if v3 then
		directionsFrameOrProgressChecklist = React.createElement(ProgressChecklist, {
			entryHeight = 18,
			layoutOrder = 1,
			latestStepCompleted = latestStepCompleted
		})
	else
		directionsFrameOrProgressChecklist = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 72),
				BackgroundColor3 = v2.Theme.BackgroundContrast.Color,
				BackgroundTransparency = 0,
				LayoutOrder = 1
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				IDDirection = React.createElement(DirectionsTile, {
					imagePath = "icons/menu/document",
					headerText = v.idDirectionsHeader,
					descriptionText = v.idDirectionsBody,
					frameHeight = 48
				})
			}
		)
	end

	v6.DirectionsFrameOrProgressChecklist = directionsFrameOrProgressChecklist

	v6.DisclaimerFrame = React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 0, 100), BackgroundTransparency = 1, LayoutOrder = 2 },
		{
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			Disclaimer = React.createElement("TextLabel", {
				Text = v.disclaimer,
				FontFace = normalizeFontFace(v2.Tokens.Typography.BodyLarge.Font),
				TextSize = textSize,
				TextColor3 = v2.Theme.TextDefault.Color,
				TextTransparency = transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}),
			PrivacyPolicy = Roact.createElement(LinkButton, {
				text = v.privacyLinkText,
				layoutOrder = 2,
				fontStyle = "CaptionBody",
				underlineAlwaysEnabled = true,
				onActivated = function()
					sendButtonClickEvent(
						analyticsService,
						AppScreens.IDVDirectLinkUpsell,
						featureName,
						"OpenPrivacyPolicy"
					)

					openPrivacyPolicyLink()
				end
			})
		}
	)
	return createElement(PartialPageModal, v4, {
		DirectLinkViewFrame = createElement2("Frame", v5, v6)
	})
end

return IDVDirectLinkUpsell
