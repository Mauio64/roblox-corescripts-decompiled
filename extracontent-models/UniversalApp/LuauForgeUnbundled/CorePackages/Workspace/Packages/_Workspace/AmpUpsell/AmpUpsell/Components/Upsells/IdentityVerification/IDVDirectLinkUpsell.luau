local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Roact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/AnalyticsService")
local sendButtonClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/sendButtonClickEvent")
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useStyle = UIBlox.Core.Style.useStyle
local linkButton = UIBlox.App.Button.LinkButton
local idvWithQRCodeUpsellStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").idvWithQRCodeUpsellStrings
local DirectionsTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/DirectionsTile")
local ProgressChecklist = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/ProgressChecklist")
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useSelector

local function IDVDirectLinkUpsell(props)
	local featureName = props.featureName
	local v5 = useLocalization(idvWithQRCodeUpsellStrings)
	local v6 = useStyle()
	local onClose = props.onClose
	local openPrivacyPolicyLink = props.openPrivacyPolicyLink
	local font = v6.Font.Body.Font
	local baseSize = v6.Font.BaseSize
	local transparency = v6.Theme.TextEmphasis.Transparency
	local v7 = baseSize * v6.Font.CaptionBody.RelativeSize
	local analyticsService = props.analyticsService or AnalyticsService.EventStream
	local idvLink = props.idvLink
	local latestStepCompleted = props.latestStepCompleted
	local v8 = latestStepCompleted > 0
	local openIdvLink = props.openIdvLink
	local v9 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local createElement = React.createElement
	local v11 = {
		title = v5.title,
		screenSize = v9,
		onCloseClicked = React.useCallback(function()
			sendButtonClickEvent(analyticsService, AppScreens.IDVDirectLinkUpsell, featureName, "CloseModal")
			onClose()
		end, { analyticsService, featureName }),
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttonHeight = 36,
			buttons = {
				{
					buttonType = buttonType.Secondary,
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
						text = v5.cancel
					}
				},
				{
					buttonType = buttonType.PrimarySystem,
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
						text = v5.startVerification
					}
				}
			}
		}
	}

	local createElement2 = React.createElement
	local v14 = { AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 }

	local v15 = {
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
	local v16

	if v8 then
		v16 = React.createElement(ProgressChecklist, {
			entryHeight = 18,
			layoutOrder = 1,
			latestStepCompleted = latestStepCompleted
		})
	else
		v16 = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 72),
				BackgroundColor3 = v6.Theme.BackgroundContrast.Color,
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
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				}),
				IDDirection = React.createElement(DirectionsTile, {
					imagePath = "icons/menu/document",
					headerText = v5.idDirectionsHeader,
					descriptionText = v5.idDirectionsBody,
					frameHeight = 48
				})
			}
		)
	end

	v15.DirectionsFrameOrProgressChecklist = v16

	local createElement3 = React.createElement
	local v18 = {
		Size = UDim2.new(1, 0, 0, 100),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		Disclaimer = 0,
		PrivacyPolicy = 0
	}

	local createElement4 = React.createElement
	local v20 = {
		Text = v5.disclaimer,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextXAlignment = 0,
		TextWrapped = true,
		AutomaticSize = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	if foundationFontFaceMigration then
		font = nil
	end

	v20.Font = font

	local v21 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v20.FontFace = v21

	v20.TextSize = v7
	v20.TextColor3 = v6.Theme.TextDefault.Color
	v20.TextTransparency = transparency
	v20.TextXAlignment = Enum.TextXAlignment.Left

	v20.AutomaticSize = Enum.AutomaticSize.XY
	children.Disclaimer = createElement4("TextLabel", v20)

	children.PrivacyPolicy = Roact.createElement(linkButton, {
		text = v5.privacyLinkText,
		layoutOrder = 2,
		fontStyle = "CaptionBody",
		underlineAlwaysEnabled = true,
		onActivated = function()
			sendButtonClickEvent(analyticsService, AppScreens.IDVDirectLinkUpsell, featureName, "OpenPrivacyPolicy")

			openPrivacyPolicyLink()
		end
	})
	v15.DisclaimerFrame = createElement3("Frame", v18, children)
	return createElement(partialPageModal, v11, {
		DirectLinkViewFrame = createElement2("Frame", v14, v15)
	})
end

return IDVDirectLinkUpsell
