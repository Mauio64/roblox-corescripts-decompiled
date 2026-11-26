local module = require("@luauforge/bundled/gvo")

local module2 = require("@luauforge/bundled/gvM")
local module3 = require("@luauforge/bundled/gvN")

local react = module.React
local uiBlox = module.UIBlox
local foundation = module.Foundation
local normalizeFontFace = foundation.Utility.normalizeFontFace
local sharedFlags = module.SharedFlags
local fFlagKISAUserAgreementsRedesign = sharedFlags.FFlagKISAUserAgreementsRedesign
local fFlagEnableKISAConsentModalization = sharedFlags.FFlagEnableKISAConsentModalization

local checkbox = foundation.Checkbox
local button = foundation.Button
local text = foundation.Text
local icon = foundation.Icon
local buttonVariant = foundation.Enums.ButtonVariant
local inputSize = foundation.Enums.InputSize
local iconSize = foundation.Enums.IconSize
local iconName = foundation.Enums.IconName
local dialogSize = foundation.Enums.DialogSize
local sheet = foundation.Sheet

local roactRodux = module.RoactRodux
local useLocalization = module.Localization.Hooks.useLocalization
local formFactor = require("@luauforge/bundled/gvu").Enums.FormFactor
local fitFrame = module.FitFrame
local useDesignTokens = module.Style.useDesignTokens
local closeCentralOverlay = module.CentralOverlay.Thunks.CloseCentralOverlay
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local useState = react.useState
local useStyle = uiBlox.Core.Style.useStyle
local button2 = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType

local iconButton = uiBlox.App.Button.IconButton
local images = uiBlox.App.ImageSet.Images
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local userAgreementsList = module.UserAgreements.UserAgreementsList
local module4 = require("@luauforge/bundled/gvn")

local rect = Rect.new(8, 8, 9, 9)

local v5 = {
	TermsOfService = "CommonUI.UserAgreements.Popup.KISAConsent.Agreement.TermsOfService",
	PrivacyPolicy = "CommonUI.UserAgreements.Popup.Agreement.PrivacyPolicy",
	PersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.PersonalInformationPolicy",
	ThirdPartyPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.KISAConsent.Agreement.ThirdPartyInfo",
	TransferPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.TransferPersonalInformationPolicy",
	OptionalPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.OptionalPersonalInformationPolicy"
}

local v6 = {
	TermsOfService = 1,
	PrivacyPolicy = 2,
	ThirdPartyPersonalInformationPolicy = 3,
	TransferPersonalInformationPolicy = 4,
	PersonalInformationPolicy = 5,
	OptionalPersonalInformationPolicy = 6
}

local function createContrastStrokeCheckbox(props, p2, fn)
	local color3 = props.Color.Stroke.Default.Color3
	local background = props.Color.ActionSubEmphasis.Background
	local createElement = react.createElement
	local v8 = {}
	v8.LayoutOrder = 1
	v8.Size = UDim2.fromOffset(props.Size.Size_600, props.Size.Size_600)
	local v9 = if p2 then background.Color3 else Color3.new(1, 1, 1)
	v8.BackgroundColor3 = v9
	v8.BackgroundTransparency = not p2 and 1 or background.Transparency
	v8.AutoButtonColor = false
	v8.BorderSizePixel = 0
	v8[react.Event.Activated] = fn
	local v10 = {
		UICorner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.Radius.Small)
		}),
		UIStroke = 0,
		Check = 0
	}

	local createElement2 = react.createElement

	if p2 then
		color3 = background.Color3
	end

	v10.UIStroke = createElement2("UIStroke", {
		Color = color3,
		Transparency = not p2 and 0.6 or background.Transparency,
		Thickness = 1
	})

	local v13 = if p2 then react.createElement(icon, {
		name = iconName.Check,
		size = iconSize.Small,
		style = props.Color.ActionSubEmphasis.Foreground,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	}) else nil
	v10.Check = v13
	return createElement("ImageButton", v8, v10)
end

local function ConsentSheetLayout(p2)
	local clone = table.clone(p2.children)
	local sheetHeader = clone.SheetHeader
	local agreeZone = clone.AgreeZone
	clone.SheetHeader = nil
	clone.AgreeZone = nil

	return react.createElement(sheet.Root, {
		preferCenterSheet = true,
		snapPoints = { 1 },
		size = dialogSize.Medium,
		onClose = p2.onClose
	}, {
		Header = react.createElement(sheet.Header, { hasCloseAffordance = true }, sheetHeader),
		Content = react.createElement(sheet.Content, { isContentFullBleed = true }, clone),
		Actions = react.createElement(sheet.Actions, nil, agreeZone)
	})
end

return (roactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize, formFactor = p2.FormFactor }
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(closeCentralOverlay())
		end
	}
end)(function(props)
	local isUnderAgeFlow = props.isUnderAgeFlow or false
	local v7 = fFlagEnableKISAConsentModalization and props.useFoundationSheet == true

	local screenSize = props.screenSize
	local v8 = useStyle()
	local theme = v8.Theme
	local font = v8.Font

	local v9 = tostring(props.formFactor) == tostring(formFactor.WIDE)
	local v10 = useDesignTokens()
	local authCompliance = v10.LuaApps.AuthCompliance

	local v11 = useLocalization({
		title = v7 and "CommonUI.UserAgreements.Popup.KISAConsent.Title" or "Authentication.OneTimePasscode.Label.ConsentNeeded",
		message = v7 and "CommonUI.UserAgreements.Popup.KISAConsent.Message" or "CommonUI.UserAgreements.Popup.KISAMessage",
		agreeButton = "CommonUI.UserAgreements.Popup.Agree2",
		checkbox = "CommonUI.UserAgreements.Popup.CheckboxMessage",
		errorMessage = "CommonUI.UserAgreements.Popup.FailAndRetryMessage",
		underAgeFlowTitle = "Authentication.OneTimePasscode.Label.ParentConsentNeeded",
		underAgeFlowMessage = "Authentication.OneTimePasscode.Description.ReviewAndConsentToTerms"
	})

	local state, setState = useState({})
	local state2, setState2 = useState({})

	if props.agreements ~= state2 then
		setState2(props.agreements)
		local v12 = {}

		for k, agreement in pairs(props.agreements) do
			v12[agreement.id] = false
		end

		setState(v12)
	end

	local checkBoxStatusVariables, v12, v13 = module4.getCheckBoxStatusVariables(state, props.agreements)
	local v14 = not checkBoxStatusVariables
	local v15 = v7 and 0 or authCompliance.paddingTop
	local v16 = if v7 then v10.Size.Size_400 else authCompliance.paddingLeft
	local v17 = not v7 and 0 or authCompliance.checkboxPaddingBottom

	local function fn()
		if props.onAbandonFunction then
			props.onAbandonFunction()
		end

		props.closeCentralOverlay()
	end

	local v18, v19 = (function(p2, p3)
		if v7 then
			return ConsentSheetLayout, { onClose = fn }
		end

		if p2 then
			return imageSetLabel, {
				Size = UDim2.new(0, 540, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = p3.BackgroundUIDefault.Color,
				Image = "LuaApp/buttons/buttonFill",
				ImageColor3 = p3.BackgroundUIDefault.Color,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect,
				AutomaticSize = Enum.AutomaticSize.Y
			}
		end

		return "Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			BackgroundColor3 = p3.BackgroundUIDefault.Color
		}
	end)(v9, theme)

	local function fn2(p2)
		local v20 = if p2 then module3.btn.agreeAllCheckboxes else module3.btn.disagreeAllCheckboxes
		module2.sendButtonClickEvent(module3.ctx.kisaAgreements, module3.origin.signup, v20)

		local v21 = {}

		for k, v22 in pairs(state) do
			v21[k] = p2
		end

		setState(v21)
	end

	local function setCheckBoxStates(p2, p3, p4)
		local v20 = if p4 then module3.btn.checked else module3.btn.unchecked
		module2.sendFormInteractionEvent(module3.ctx.kisaCheckbox, p3, v20)
		setState(p2)
	end

	local createElement = react.createElement
	local v21 = {
		Size = UDim2.new(1, 0, 0, screenSize.Y),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v22 = { Layout = 0 }
	local createElement2 = react.createElement
	local children = {
		ListLayout = v9 and not v7 and react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = 0,
		SheetHeader = 0,
		Content = 0,
		AgreeZone = 0
	}

	local v23 = if not v7 then react.createElement("UIPadding", {
		PaddingTop = UDim.new(0, authCompliance.paddingTop),
		PaddingBottom = UDim.new(0, authCompliance.paddingBottom)
	}) else nil
	children.Padding = v23
	local v24

	if v7 then
		local createElement3 = react.createElement
		local v26 = {
			Size = UDim2.new(1, 0, 0, authCompliance.xButtonSize),
			tag = "text-heading-medium text-align-x-left text-align-y-center content-emphasis",
			Text = 0,
			TextTruncate = 0
		}

		local v27 = if isUnderAgeFlow then v11.underAgeFlowTitle else v11.title
		v26.Text = v27
		v26.TextTruncate = Enum.TextTruncate.AtEnd
		v24 = createElement3(text, v26)
	end

	children.SheetHeader = v24

	local createElement3 = react.createElement

	local v27 = if v7 then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 0, screenSize.Y - 150)
	local v28 = if v7 then Enum.AutomaticSize.Y else nil

	local children2 = {
		Layout = react.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = 0,
		Message = 0,
		AgreementsContainer = 0,
		SecondDivider = 0,
		AgreementsList = 0
	}

	local createElement4 = react.createElement
	local v30 = {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Visible = not v7,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement5 = react.createElement
	local v32 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local v33 = {
		ListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = react.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, authCompliance.paddingLeft)
		}),
		CrossXButton = react.createElement(iconButton, {
			layoutOrder = 1,
			anchorPoint = Vector2.new(0.5, 0.5),
			size = UDim2.new(
				0,
				tonumber(authCompliance.xButtonSize),
				0,
				(tonumber(authCompliance.xButtonSize))
			),
			position = UDim2.new(0, 0, 0, 0),
			icon = images["icons/navigation/close"],
			onActivated = fn
		}),
		TitleText = 0
	}
	local v34

	if fFlagKISAUserAgreementsRedesign then
		local createElement6 = react.createElement
		local v36 = {
			LayoutOrder = 2,
			Size = UDim2.new(0.75, 0, 0, authCompliance.xButtonSize),
			BackgroundTransparency = 1,
			tag = "text-heading-small text-align-x-center text-align-y-center content-emphasis",
			Text = 0,
			TextTruncate = 0
		}

		local v37 = if isUnderAgeFlow then v11.underAgeFlowTitle else v11.title
		v36.Text = v37
		v36.TextTruncate = Enum.TextTruncate.AtEnd
		v34 = createElement6(text, v36)
	else
		local createElement6 = react.createElement
		local v36 = {
			layoutOrder = 2,
			size = UDim2.new(0.75, 0, 0, authCompliance.xButtonSize),
			text = 0,
			fontStyle = 0,
			colorStyle = 0,
			textXAlignment = 0,
			textYAlignment = 0,
			textTruncate = 0
		}

		local v37 = if isUnderAgeFlow then v11.underAgeFlowTitle else v11.title
		v36.text = v37
		v36.fontStyle = font.Header1
		v36.colorStyle = theme.TextEmphasis
		v36.textXAlignment = Enum.TextXAlignment.Center
		v36.textYAlignment = Enum.TextYAlignment.Center
		v36.textTruncate = Enum.TextTruncate.AtEnd
		v34 = createElement6(styledTextLabel, v36)
	end

	v33.TitleText = v34
	local children3 = {
		AreaAboveFirstDivider = createElement5("Frame", v32, v33),
		FirstDivider = 0
	}

	local createElement6 = react.createElement
	local v36 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local createElement7 = react.createElement
	local v38 = {
		PaddingTop = UDim.new(0, authCompliance.dividerPaddingTop),
		PaddingRight = 0,
		PaddingLeft = 0
	}

	local v39 = if fFlagKISAUserAgreementsRedesign then UDim.new(0, 0) else UDim.new(0, authCompliance.paddingRight)
	v38.PaddingRight = v39

	local v40 = if fFlagKISAUserAgreementsRedesign then UDim.new(0, 0) else UDim.new(0, authCompliance.paddingLeft)
	v38.PaddingLeft = v40
	local children4 = {
		Padding = createElement7("UIPadding", v38),
		Divider = 0
	}

	local createElement8 = react.createElement
	local v42 = {
		Size = UDim2.new(1, 0, 0, 1),
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	}

	local v43 = if fFlagKISAUserAgreementsRedesign then v10.Color.Stroke.Default.Color3 else v10.Color.Shift.Shift_200.Color3
	v42.BackgroundColor3 = v43

	v42.BackgroundTransparency = not fFlagKISAUserAgreementsRedesign and 0
		or v10.Color.Stroke.Default.Transparency
	children4.Divider = createElement8("Frame", v42)
	children3.FirstDivider = createElement6("Frame", v36, children4)
	children2.Title = createElement4("Frame", v30, children3)

	local createElement9 = react.createElement
	local v45 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local createElement10 = react.createElement
	local udim

	if v7 then
		udim = UDim.new(0, 0)
	else
		local newUDim = UDim.new
		local v50

		if v9 then
			v50 = authCompliance.messagePaddingTopWideViewExtended
		else
			v50 = authCompliance.messagePaddingTopExtended
		end

		udim = newUDim(0, v50)
	end

	local v48 = {
		PaddingTop = udim,
		PaddingRight = UDim.new(0, v16),
		PaddingBottom = 0,
		PaddingLeft = 0
	}
	local udim2

	if v7 then
		udim2 = UDim.new(0, v10.Size.Size_500)
	else
		local newUDim = UDim.new
		local v50

		if v9 then
			v50 = authCompliance.messagePaddingBottomWideView
		else
			v50 = authCompliance.messagePaddingBottomReduced
		end

		udim2 = newUDim(0, v50)
	end

	v48.PaddingBottom = udim2

	v48.PaddingLeft = UDim.new(0, v16)
	local v46 = {
		Padding = createElement10("UIPadding", v48),
		MessageText = 0
	}
	local v49

	if v7 then
		local createElement11 = react.createElement

		local v52 = if isUnderAgeFlow then v11.underAgeFlowMessage else v11.message
		v49 = createElement11(text, {
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
			Text = v52
		})
	else
		local createElement11 = react.createElement

		local v52 = if isUnderAgeFlow then v11.underAgeFlowMessage else v11.message

		local v53 = if fFlagKISAUserAgreementsRedesign then v10.Typography.BodyMedium.FontSize else authCompliance.messageSize
		local v51 = {
			BackgroundTransparency = 1,
			Text = v52,
			TextSize = v53,
			TextColor3 = v10.Color.Content.Emphasis.Color3,
			TextTransparency = v8.Theme.TextDefault.Transparency,
			FontFace = 0,
			TextXAlignment = 0,
			AutomaticSize = 0,
			TextWrapped = true,
			Size = 0
		}
		local v55

		if fFlagKISAUserAgreementsRedesign then
			v55 = v10.Typography.BodyMedium.Font
		else
			v55 = v10.Typography.BodyLarge.Font
		end

		v51.FontFace = normalizeFontFace(v55)

		v51.TextXAlignment = Enum.TextXAlignment.Left
		v51.AutomaticSize = Enum.AutomaticSize.Y

		v51.Size = UDim2.new(1, 0, 0, 0)
		v49 = createElement11("TextLabel", v51)
	end

	v46.MessageText = v49
	children2.Message = createElement9("Frame", v45, v46)

	local createElement11 = react.createElement
	local v51 = {
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local v52 = {
		Padding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingRight = UDim.new(0, v16),
			PaddingBottom = UDim.new(0, authCompliance.checkboxPaddingBottom),
			PaddingLeft = UDim.new(0, v16)
		}),
		Layout = 0,
		CheckBox = 0,
		CheckboxLabel = 0,
		MessageButton = 0
	}

	local v53 = if v7 then react.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v10.Size.Size_300)
	}) else nil
	v52.Layout = v53
	local v54

	if v7 then
		v54 = createContrastStrokeCheckbox(v10, v13, function()
			fn2(not v13)
		end)
	else
		v54 = react.createElement(checkbox, {
			label = "",
			isChecked = v13,
			onActivated = function()
				fn2(not v13)
			end
		})
	end

	v52.CheckBox = v54
	local v55

	if v7 then
		v55 = react.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, -(v10.Size.Size_600 + v10.Size.Size_300), 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}, {
			Padding = react.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v10.Size.Size_50)
			}),
			Text = react.createElement(text, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left text-align-y-top content-emphasis",
				Text = v11.checkbox,
				onActivated = function()
					fn2(not v13)
				end
			})
		})
	end

	v52.CheckboxLabel = v55
	local v56

	if not v7 then
		local createElement12 = react.createElement
		local v58 = {}
		v58.Size = UDim2.new(
			1,
			-((tonumber(authCompliance.checkboxSize) or 0) + (tonumber(authCompliance.checkboxPadding) or 0)),
			1,
			0
		)

		v58.Position = UDim2.new(
			0,
			(tonumber(authCompliance.checkboxSize) or 0) + (tonumber(authCompliance.checkboxPadding) or 0),
			0,
			0
		)

		v58.AutomaticSize = Enum.AutomaticSize.Y
		v58.BackgroundTransparency = 1
		v58.Text = v11.checkbox
		local v60

		if fFlagKISAUserAgreementsRedesign then
			v60 = v10.Typography.BodyMedium.Font
		else
			v60 = v10.Typography.BodyLarge.Font
		end

		v58.FontFace = normalizeFontFace(v60)

		local v61 = if fFlagKISAUserAgreementsRedesign then v10.Typography.BodyMedium.FontSize else authCompliance.messageSize
		v58.TextSize = v61

		local v62 = if fFlagKISAUserAgreementsRedesign and not v7 then theme.TextEmphasis.Color else theme.TextMuted.Color
		v58.TextColor3 = v62

		local v63 = if fFlagKISAUserAgreementsRedesign and not v7 then theme.TextEmphasis.Transparency else theme.TextMuted.Transparency
		v58.TextTransparency = v63

		v58.TextXAlignment = Enum.TextXAlignment.Left
		v58.TextWrapped = true
		v58[react.Event.Activated] = nil
		v56 = createElement12("TextButton", v58)
	end

	v52.MessageButton = v56
	children2.AgreementsContainer = createElement11("Frame", v51, v52)

	local createElement12 = react.createElement
	local v58 = {
		LayoutOrder = 4,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local v59 = {
		Padding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingRight = UDim.new(0, v16),
			PaddingBottom = UDim.new(0, v17),
			PaddingLeft = UDim.new(0, v16)
		}),
		Divider = 0
	}

	local createElement13 = react.createElement
	local v61 = {
		Size = UDim2.new(1, 0, 0, 1),
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	}
	local color3

	if v7 then
		color3 = v10.Color.Stroke.Emphasis.Color3
	elseif fFlagKISAUserAgreementsRedesign then
		color3 = v10.Color.Stroke.Default.Color3
	else
		color3 = v10.Color.Shift.Shift_200.Color3
	end

	v61.BackgroundColor3 = color3

	local v62 = if v7 then v10.Color.Stroke.Emphasis.Transparency else not fFlagKISAUserAgreementsRedesign and 0 or v10.Color.Stroke.Default.Transparency
	v61.BackgroundTransparency = v62
	v59.Divider = createElement13("Frame", v61)
	children2.SecondDivider = createElement12("Frame", v58, v59)

	local createElement14 = react.createElement
	local v64 = {
		LayoutOrder = 5,
		agreements = props.agreements,
		checkBoxStates = state,
		setCheckBoxStates = setCheckBoxStates,
		separateRequiredOptional = v12,
		margin = fitFrame.Rect.quad(
			v15,
			authCompliance.paddingRight,
			authCompliance.listPaddingBottom,
			authCompliance.paddingLeft
		),
		verticalSpaceOffset = 300,
		isAgreeAllChecked = v13,
		useScrollableFrame = true,
		disableInnerScrolling = v7,
		useExternalLinkArrowForAgreementRows = v7,
		agreementTitleKeys = if v7 then v5 else nil,
		agreementTypeOrder = if v7 then v6 else nil,
		listItemHeight = 0,
		horizontalPadding = 0,
		checkboxLabelGap = 0,
		useLabelMediumSectionTitles = 0,
		useContrastUncheckedCheckbox = 0
	}

	local v67 = if v7 then v10.Size.Size_900 else nil
	v64.listItemHeight = v67
	local v68 = if v7 then v10.Size.Size_400 else nil
	v64.horizontalPadding = v68
	local v69 = if v7 then v10.Size.Size_300 else nil
	v64.checkboxLabelGap = v69
	v64.useLabelMediumSectionTitles = v7
	v64.useContrastUncheckedCheckbox = v7
	children2.AgreementsList = createElement14(userAgreementsList, v64)
	children.Content = createElement3(
		"Frame",
		{ Size = v27, AutomaticSize = v28, LayoutOrder = 1, BackgroundTransparency = 1 },
		children2
	)

	local createElement15 = react.createElement
	local v71 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = 0,
		AnchorPoint = 0
	}

	local v72 = if not v7 then UDim2.new(0.5, 0, 1, -authCompliance.agreeButtonPaddingBottom) else nil
	v71.Position = v72

	local v73 = if not v7 then Vector2.new(0.5, 1) else nil
	v71.AnchorPoint = v73

	local v75 = if not v7 then react.createElement("UIPadding", {
		PaddingTop = UDim.new(0, 0),
		PaddingRight = UDim.new(0, authCompliance.paddingRight),
		PaddingBottom = UDim.new(0, authCompliance.agreeButtonPaddingBottom),
		PaddingLeft = UDim.new(0, authCompliance.paddingLeft)
	}) else nil

	local createElement16 = react.createElement
	local fitFrameVertical = fitFrame.FitFrameVertical
	local v76 = { width = UDim.new(1, 0), BackgroundTransparency = 1 }
	local v78

	if fFlagKISAUserAgreementsRedesign then
		local createElement17 = react.createElement
		local v81

		if v7 then
			v81 = buttonVariant.Emphasis
		else
			v81 = if v14 then buttonVariant.Standard else buttonVariant.Emphasis
		end

		local v82 = if v7 then inputSize.Medium else inputSize.Large
		v78 = createElement17(button, {
			LayoutOrder = 2,
			variant = v81,
			size = v82,
			width = UDim.new(1, 0),
			isDisabled = v14,
			text = v11.agreeButton,
			onActivated = function()
				props.onAgreeFunction(state)
				props.closeCentralOverlay()
			end
		})
	else
		v78 = react.createElement(button2, {
			buttonType = buttonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, authCompliance.agreeButtonHeight),
			anchorPoint = Vector2.new(0, 0),
			isDisabled = v14,
			layoutOrder = 2,
			text = v11.agreeButton,
			fontStyle = font.SubHeader1,
			onActivated = function()
				props.onAgreeFunction(state)
				props.closeCentralOverlay()
			end
		})
	end

	children.AgreeZone = createElement15("Frame", v71, {
		Padding = v75,
		createElement16(fitFrameVertical, v76, { ErrorLabel = nil, AgreeButton = v78 })
	})
	v22.Layout = createElement2(v18, v19, children)
	return createElement("Frame", v21, v22)
end))
