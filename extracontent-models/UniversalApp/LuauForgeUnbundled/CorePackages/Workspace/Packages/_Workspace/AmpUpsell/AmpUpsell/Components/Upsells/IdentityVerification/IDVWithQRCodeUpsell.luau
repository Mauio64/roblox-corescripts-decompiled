local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/AnalyticsService")
local sendButtonClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/sendButtonClickEvent")
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useStyle = UIBlox.Core.Style.useStyle
local linkButton = UIBlox.App.Button.LinkButton
local DirectionsTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/DirectionsTile")
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local QRCodeDisplay = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/QRCodeDisplay")
local displayQRCode = QRCodeDisplay.DisplayQRCode
local ecLevels = QRCodeDisplay.ECLevels

local ProgressChecklist = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/ProgressChecklist")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local idvWithQRCodeUpsellStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").idvWithQRCodeUpsellStrings

local function IDVWithQRCodeUpsell(props)
	local featureName = props.featureName
	local qrCodeLink = props.qrCodeLink
	local v5 = useLocalization(idvWithQRCodeUpsellStrings)
	local v6 = useStyle()
	local onClose = props.onClose
	local openPrivacyPolicyLink = props.openPrivacyPolicyLink
	local font = v6.Font.Body.Font
	local baseSize = v6.Font.BaseSize
	local transparency = v6.Theme.TextEmphasis.Transparency
	local v7 = baseSize * v6.Font.CaptionBody.RelativeSize
	local v8 = if props.analyticsService then props.analyticsService else AnalyticsService.EventStream
	local udim = UDim2.fromOffset(153, 153)
	local latestStepCompleted = props.latestStepCompleted
	local v9 = latestStepCompleted > 0
	local v10 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local createElement = React.createElement
	local v12 = {
		title = v5.title,
		screenSize = v10,
		onCloseClicked = function()
			sendButtonClickEvent(v8, AppScreens.IDVWithQRCodeUpsell, featureName, "CloseModal")
			onClose()
		end,
		bottomPadding = 0
	}

	local createElement2 = React.createElement
	local v15 = { AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 }

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
	local v18 = if v9 then v5.verifyInBrowser else v5.ageVerifyPrompt
	children.HeaderText = createElement3(styledTextLabel, {
		text = v18,
		fontStyle = v6.Font.Header2,
		colorStyle = v6.Theme.TextEmphasis,
		size = UDim2.new(1, 0, 0, 0),
		lineHeight = 1,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		automaticSize = Enum.AutomaticSize.XY,
		layoutOrder = 0
	})

	local v19 = if not v9 then React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 144),
			BackgroundColor3 = v6.Theme.BackgroundContrast.Color,
			BackgroundTransparency = 0,
			LayoutOrder = 1
		},
		{
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
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
				headerText = v5.idDirectionsHeader,
				descriptionText = v5.idDirectionsBody,
				frameHeight = 48,
				layoutOrder = 1
			}),
			PhoneDirection = React.createElement(DirectionsTile, {
				imagePath = "icons/menu/mobile",
				headerText = v5.phoneDirectionsHeader,
				descriptionText = v5.phoneDirectionsBody,
				frameHeight = 48,
				layoutOrder = 2
			})
		}
	) else nil
	children.DirectionsFrame = v19

	local v20 = if v9 then React.createElement(ProgressChecklist, {
		entryHeight = 18,
		layoutOrder = 1,
		latestStepCompleted = latestStepCompleted
	}) else nil
	children.Checklist = v20

	local v21 = if not v9 then React.createElement(styledTextLabel, {
		text = v5.beginText,
		fontStyle = v6.Font.Header1,
		colorStyle = v6.Theme.TextEmphasis,
		size = UDim2.new(1, 0, 0, 0),
		lineHeight = 1,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		automaticSize = Enum.AutomaticSize.XY,
		layoutOrder = 2
	}) else nil
	children.BeginText = v21

	local createElement4 = React.createElement
	local v23 = {
		Size = udim,
		BackgroundColor3 = Color3.fromHex("#FFFFFF"),
		BackgroundTransparency = 0,
		LayoutOrder = 3
	}

	local v24 = if qrCodeLink == nil then React.createElement(loading, {
		size = iconSize.Medium
	}) else React.createElement(displayQRCode, {
		ecLevel = ecLevels.EC_LEVEL_1,
		sideLength = 150,
		backgroundTransparency = 1,
		toEncode = qrCodeLink
	})
	children.QRCodeWrapper = createElement4("Frame", v23, {
		QrCode = v24,
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
	local v26 = {
		Size = UDim2.new(1, 0, 0, 100),
		BackgroundTransparency = 1,
		LayoutOrder = 4
	}

	local v27 = {
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
	local v28

	if not v9 then
		local createElement6 = React.createElement
		local v30 = {
			Text = v5.disclaimer,
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

		if foundationFontFaceMigration then
			font = nil
		end

		v30.Font = font

		local v31 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
		v30.FontFace = v31

		v30.TextSize = v7
		v30.TextColor3 = v6.Theme.TextDefault.Color
		v30.TextTransparency = transparency
		v30.TextXAlignment = Enum.TextXAlignment.Center

		v30.AutomaticSize = Enum.AutomaticSize.XY
		v30.Size = UDim2.new(1, 0, 0, 24)
		v28 = createElement6("TextLabel", v30)
	end

	v27.Disclaimer = v28
	local v29

	if not v9 then
		v29 = React.createElement(linkButton, {
			text = v5.privacyLinkText,
			layoutOrder = 2,
			fontStyle = "CaptionBody",
			underlineAlwaysEnabled = true,
			onActivated = function()
				sendButtonClickEvent(v8, AppScreens.IDVWithQRCodeUpsell, featureName, "OpenPrivacyPolicy")

				openPrivacyPolicyLink()
			end
		})
	end

	v27.PrivacyPolicy = v29

	local v30 = if v9 then React.createElement(styledTextLabel, {
		text = v5.havingTroubleInfoText,
		size = UDim2.new(1, 0, 0.5, 0),
		fontStyle = v6.Font.CaptionBody,
		colorStyle = v6.Theme.TextEmphasis,
		lineHeight = 1,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		layoutOrder = 1
	}) else nil
	v27.HavingTroubleInfoText = v30

	local v31 = if v9 then React.createElement(styledTextLabel, {
		text = v5.dontCloseWindowDisclaimer,
		fontStyle = v6.Font.CaptionBody,
		size = UDim2.new(1, 0, 0.5, 0),
		colorStyle = v6.Theme.TextEmphasis,
		lineHeight = 1,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		layoutOrder = 2
	}) else nil
	v27.DontCloseWindowDisclaimer = v31
	children.DisclaimerFrame = createElement5("Frame", v26, v27)
	return createElement(partialPageModal, v12, {
		QRCodeViewFrame = createElement2("Frame", v15, children)
	})
end

return IDVWithQRCodeUpsell
