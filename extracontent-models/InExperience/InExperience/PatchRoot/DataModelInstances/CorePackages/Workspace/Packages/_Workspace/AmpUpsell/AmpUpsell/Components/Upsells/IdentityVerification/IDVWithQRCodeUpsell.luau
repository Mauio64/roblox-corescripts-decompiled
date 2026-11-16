local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useStyle = UIBlox.Core.Style.useStyle
local LinkButton = UIBlox.App.Button.LinkButton
local DirectionsTile = require(script.Parent.DirectionsTile)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local QRCodeDisplay = require(parent.QRCodeDisplay)
local DisplayQRCode = QRCodeDisplay.DisplayQRCode
local ECLevels = QRCodeDisplay.ECLevels

local ProgressChecklist = require(script.Parent.ProgressChecklist)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local idvWithQRCodeUpsellStrings = LocalizationStrings.idvWithQRCodeUpsellStrings

local function IDVWithQRCodeUpsell(props)
	local featureName = props.featureName
	local qrCodeLink = props.qrCodeLink
	local v = useLocalization(idvWithQRCodeUpsellStrings)
	local v2 = useStyle()
	local onClose = props.onClose
	local openPrivacyPolicyLink = props.openPrivacyPolicyLink
	local font = v2.Font.Body.Font
	local baseSize = v2.Font.BaseSize
	local transparency = v2.Theme.TextEmphasis.Transparency
	local textSize = baseSize * v2.Font.CaptionBody.RelativeSize
	local v3

	if props.analyticsService then
		v3 = props.analyticsService
	else
		v3 = AnalyticsService.EventStream
	end

	local udim = UDim2.fromOffset(153, 153)
	local latestStepCompleted = props.latestStepCompleted
	local v4 = latestStepCompleted > 0
	local screenSize = useSelector(function(p)
		return p.ScreenSize
	end)

	local createElement = React.createElement
	local v5 = {
		title = v.title,
		screenSize = screenSize,
		onCloseClicked = function()
			sendButtonClickEvent(v3, AppScreens.IDVWithQRCodeUpsell, featureName, "CloseModal")
			onClose()
		end,
		bottomPadding = 0
	}

	local createElement2 = React.createElement
	local v6 = { AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 }

	local children = {
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
		HeaderText = 0,
		DirectionsFrame = 0,
		Checklist = 0,
		BeginText = 0,
		QRCodeWrapper = 0,
		DisclaimerFrame = 0
	}

	local createElement3 = React.createElement
	local text = if v4 then v.verifyInBrowser else v.ageVerifyPrompt
	children.HeaderText = createElement3(StyledTextLabel, {
		text = text,
		fontStyle = v2.Font.Header2,
		colorStyle = v2.Theme.TextEmphasis,
		size = UDim2.new(1, 0, 0, 0),
		lineHeight = 1,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		automaticSize = Enum.AutomaticSize.XY,
		layoutOrder = 0
	})
	local directionsFrame

	if not v4 then
		directionsFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 144),
				BackgroundColor3 = v2.Theme.BackgroundContrast.Color,
				BackgroundTransparency = 0,
				LayoutOrder = 1
			},
			{
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 24)
				}),
				IDDirection = React.createElement(DirectionsTile, {
					imagePath = "icons/menu/document",
					headerText = v.idDirectionsHeader,
					descriptionText = v.idDirectionsBody,
					frameHeight = 48,
					layoutOrder = 1
				}),
				PhoneDirection = React.createElement(DirectionsTile, {
					imagePath = "icons/menu/mobile",
					headerText = v.phoneDirectionsHeader,
					descriptionText = v.phoneDirectionsBody,
					frameHeight = 48,
					layoutOrder = 2
				})
			}
		)
	end

	children.DirectionsFrame = directionsFrame
	local checklist

	if v4 then
		checklist = React.createElement(ProgressChecklist, {
			entryHeight = 18,
			layoutOrder = 1,
			latestStepCompleted = latestStepCompleted
		})
	end

	children.Checklist = checklist
	local beginText

	if not v4 then
		beginText = React.createElement(StyledTextLabel, {
			text = v.beginText,
			fontStyle = v2.Font.Header1,
			colorStyle = v2.Theme.TextEmphasis,
			size = UDim2.new(1, 0, 0, 0),
			lineHeight = 1,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			automaticSize = Enum.AutomaticSize.XY,
			layoutOrder = 2
		})
	end

	children.BeginText = beginText

	local createElement4 = React.createElement
	local v7 = {
		Size = udim,
		BackgroundColor3 = Color3.fromHex("#FFFFFF"),
		BackgroundTransparency = 0,
		LayoutOrder = 3
	}
	local qrCode

	if qrCodeLink == nil then
		qrCode = React.createElement(Loading, { size = IconSize.Medium })
	else
		qrCode = React.createElement(DisplayQRCode, {
			ecLevel = ECLevels.EC_LEVEL_1,
			sideLength = 150,
			backgroundTransparency = 1,
			toEncode = qrCodeLink
		})
	end

	children.QRCodeWrapper = createElement4("Frame", v7, {
		QrCode = qrCode,
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4)
		})
	})

	local createElement5 = React.createElement
	local v8 = { Size = UDim2.new(1, 0, 0, 100), BackgroundTransparency = 1, LayoutOrder = 4 }

	local v9 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		Disclaimer = 0,
		PrivacyPolicy = 0,
		HavingTroubleInfoText = 0,
		DontCloseWindowDisclaimer = 0
	}
	local disclaimer

	if not v4 then
		local createElement6 = React.createElement
		local v10 = {
			Text = v.disclaimer,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			AutomaticSize = 0,
			Size = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		if FoundationFontFaceMigration then
			font = nil
		end

		v10.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Tokens.Typography.BodyLarge.Font)
		end

		v10.FontFace = fontFace

		v10.TextSize = textSize
		v10.TextColor3 = v2.Theme.TextDefault.Color
		v10.TextTransparency = transparency
		v10.TextXAlignment = Enum.TextXAlignment.Center

		v10.AutomaticSize = Enum.AutomaticSize.XY
		v10.Size = UDim2.new(1, 0, 0, 24)
		disclaimer = createElement6("TextLabel", v10)
	end

	v9.Disclaimer = disclaimer
	local privacyPolicy

	if not v4 then
		privacyPolicy = React.createElement(LinkButton, {
			text = v.privacyLinkText,
			layoutOrder = 2,
			fontStyle = "CaptionBody",
			underlineAlwaysEnabled = true,
			onActivated = function()
				sendButtonClickEvent(v3, AppScreens.IDVWithQRCodeUpsell, featureName, "OpenPrivacyPolicy")

				openPrivacyPolicyLink()
			end
		})
	end

	v9.PrivacyPolicy = privacyPolicy
	local havingTroubleInfoText

	if v4 then
		havingTroubleInfoText = React.createElement(StyledTextLabel, {
			text = v.havingTroubleInfoText,
			size = UDim2.new(1, 0, 0.5, 0),
			fontStyle = v2.Font.CaptionBody,
			colorStyle = v2.Theme.TextEmphasis,
			lineHeight = 1,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			layoutOrder = 1
		})
	end

	v9.HavingTroubleInfoText = havingTroubleInfoText
	local dontCloseWindowDisclaimer

	if v4 then
		dontCloseWindowDisclaimer = React.createElement(StyledTextLabel, {
			text = v.dontCloseWindowDisclaimer,
			fontStyle = v2.Font.CaptionBody,
			size = UDim2.new(1, 0, 0.5, 0),
			colorStyle = v2.Theme.TextEmphasis,
			lineHeight = 1,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			layoutOrder = 2
		})
	end

	v9.DontCloseWindowDisclaimer = dontCloseWindowDisclaimer
	children.DisclaimerFrame = createElement5("Frame", v8, v9)
	return createElement(PartialPageModal, v5, {
		QRCodeViewFrame = createElement2("Frame", v6, children)
	})
end

return IDVWithQRCodeUpsell
