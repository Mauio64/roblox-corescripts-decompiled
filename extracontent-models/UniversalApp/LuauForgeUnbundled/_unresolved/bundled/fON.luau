local module = require("@luauforge/bundled/fOz")

local TextService = game:GetService("TextService")

local roact = module.Roact
local roactRodux = module.RoactRodux
local uiBlox = module.UIBlox
local foundation = module.Foundation
local text = foundation.Text
local icon = foundation.Icon
local enums = foundation.Enums
local t = module.t

local robloxAppEnums = module.RobloxAppEnums
local appPage = robloxAppEnums.AppPage
local roactServices = module.RoactServices.RoactServices
local appLinking = module.RoactServiceTags.AppLinking
local navigateDown = module.NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = module.SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/fOO").NavigationCommands else nil

local notificationType = robloxAppEnums.NotificationType
local withStyle = uiBlox.Core.Style.withStyle
local argCheck = module.ArgCheck
local module2 = require("@luauforge/bundled/fOP")

local withLocalization = module.Localization.withLocalization

local fFlagEnableModularizedUserAgreementsList = module.SharedFlags.FFlagEnableModularizedUserAgreementsList
local getFFlagVngTOSRevisedEnabled = module.SharedFlags.GetFFlagVngTOSRevisedEnabled
local fFlagKISAUserAgreementsRedesign = module.SharedFlags.FFlagKISAUserAgreementsRedesign
local defineFastFlag = game:DefineFastFlag("TrimLongTitleForTOSEnabled", false)

local roactAppPolicy = module.UniversalAppPolicy.RoactAppPolicy

local fitFrame = module.FitFrame
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local images = uiBlox.App.ImageSet.Images
local styledTextLabel = uiBlox.App.Text.StyledTextLabel

local v5 = game:DefineFastFlag("FixLocalizationOfStudioTermsForVNGSKU", false)
	and {
		TermsOfService = "CommonUI.UserAgreements.Popup.Agreement.TermsOfService",
		PrivacyPolicy = "CommonUI.UserAgreements.Popup.Agreement.PrivacyPolicy",
		StudioTermsForVNGSKU = "CommonUI.UserAgreements.Popup.Agreement.StudioTermsForVNGSKU"
	}
	or {
		TermsOfService = "CommonUI.UserAgreements.Popup.Agreement.TermsOfService",
		PrivacyPolicy = "CommonUI.UserAgreements.Popup.Agreement.PrivacyPolicy"
	}

if game:DefineFastFlag("FixLocalizationOfMissingAgreementTitles", false) then
	v5.PersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.PersonalInformationPolicy"

	v5.ThirdPartyPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.ThirdPartyPersonalInformationPolicy"

	v5.TransferPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.TransferPersonalInformationPolicy"

	v5.OptionalPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.OptionalPersonalInformationPolicy"
end

local extended = roact.PureComponent:extend("UserAgreementsListItem")

local function createImageElement(p2, p3, p4, right, theme, useExternalLinkArrow, useChevronArrow)
	if useChevronArrow then
		return roact.createElement(icon, {
			name = enums.IconName.ChevronLargeRight,
			size = enums.IconSize.Medium,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -right, 0.5, 0)
		})
	end

	if fFlagKISAUserAgreementsRedesign then
		local createElement = roact.createElement

		local v8 = if useExternalLinkArrow then enums.IconName.ArrowUpRightFromSquare else enums.IconName.ArrowLargeRight
		local v9 = if useExternalLinkArrow then enums.IconSize.Small else enums.IconSize.Medium
		local v7 = {
			name = v8,
			size = v9,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = 0
		}
		local newUDim2 = UDim2.new

		local v11 = if useExternalLinkArrow then -math.floor(right * 0.75) else -right
		v7.Position = newUDim2(1, v11, 0.5, 0)
		return createElement(icon, v7)
	else
		local createElement = roact.createElement
		local v6 = {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 14 * p3, 0, 14 * p3),
			Position = UDim2.new(1, -right, 0.5, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = p4,
			ImageColor3 = 0,
			ImageTransparency = 0
		}

		local v7 = if fFlagEnableModularizedUserAgreementsList then theme.UIEmphasis.Color else theme.SecondaryDefault.Color
		v6.ImageColor3 = v7

		v6.ImageTransparency = fFlagEnableModularizedUserAgreementsList and 0
			or theme.SecondaryDefault.Transparency
		return createElement(p2, v6)
	end
end

local strictInterface = t.strictInterface
local v6 = {
	LayoutOrder = t.integer,
	Size = 0,
	agreement = 0,
	minHeight = 0,
	widthOffset = 0,
	agreementTitleKey = 0,
	margin = 0,
	navigateDown = 0,
	agreementTypeExists = 0,
	useExternalBrowserForDisclaimerLinks = 0,
	linking = 0,
	hideLink = 0,
	checkBoxPresent = 0,
	useMutedText = 0,
	useExternalLinkArrow = 0,
	useChevronArrow = 0,
	useBoldTitle = 0
}
local v7 = if not getFFlagVngTOSRevisedEnabled() then t.UDim2 else nil
v6.Size = v7
v6.agreement = t.strictInterface({
	id = t.string,
	agreementType = t.string,
	clientType = t.string,
	displayUrl = t.string,
	regulationType = t.string,
	agreementBodyText = t.optional(t.string)
})

v6.minHeight = t.optional(t.integer)
v6.widthOffset = t.optional(t.integer)
v6.agreementTitleKey = t.optional(t.string)
v6.margin = t.optional(t.strictInterface({
	top = t.integer,
	right = t.integer,
	bottom = t.integer,
	left = t.integer
}))

v6.navigateDown = t.callback
v6.agreementTypeExists = t.optional(t.boolean)

v6.useExternalBrowserForDisclaimerLinks = t.optional(t.boolean)
v6.linking = t.optional(t.table)
v6.hideLink = t.optional(t.boolean)
v6.checkBoxPresent = t.optional(t.boolean)
v6.useMutedText = t.optional(t.boolean)
v6.useExternalLinkArrow = t.optional(t.boolean)
v6.useChevronArrow = t.optional(t.boolean)
v6.useBoldTitle = t.optional(t.boolean)
extended.validateProps = strictInterface(v6)

extended.defaultProps = {
	margin = fitFrame.Rect.square(0),
	agreementTypeExists = false
}

function LUAUFORGE_MODULE_GLOBALS_fON_openExternalBrowser(object, p2)
	argCheck.isNotNil(object, "linking")
	argCheck.isType(p2, "string", "url")

	object:openURL(p2)
end

function extended:init()
	local binding, v8 = roact.createBinding(false)
	self.buttonPressed = binding
	self.updateButtonPressed = v8

	function self.onButtonInputBegan(p2, p3)
		if
			p3.UserInputType == Enum.UserInputType.Touch
			or p3.UserInputType == Enum.UserInputType.MouseButton1
		then
			if self.buttonPressed:getValue() then
				return
			end

			self.updateButtonPressed(true)
		end
	end

	function self.onButtonInputEnded()
		if self.buttonPressed:getValue() then
			self.updateButtonPressed(false)
		end
	end

	function self.showLinkText(): boolean
		if fFlagEnableModularizedUserAgreementsList then
			return not (self.props.hideLink or self.props.agreementTypeExists)
		end

		return not self.props.agreementTypeExists
	end
end

function extended:renderWithProviders(p2, props2)
	local layoutOrder = self.props.LayoutOrder
	local v8 = self.props.Size
	local minHeight = self.props.minHeight or 55
	local widthOffset = self.props.widthOffset or 0
	local margin = self.props.margin
	local agreement = self.props.agreement
	local checkBoxPresent = self.props.checkBoxPresent or false
	local useMutedText = self.props.useMutedText or false
	local useExternalLinkArrow = self.props.useExternalLinkArrow or false
	local useChevronArrow = self.props.useChevronArrow or false
	local useBoldTitle = self.props.useBoldTitle or false

	local font = props2.Font
	local theme = props2.Theme
	local tokens = props2.Tokens

	local v9 = -(margin.left + margin.right + 14)
	local v10

	if fFlagEnableModularizedUserAgreementsList and checkBoxPresent then
		v10 = tokens.FontSize.FontSize_350
	else
		v10 = font.BaseSize * font.Header2.RelativeSize
	end

	local v11 = 20 / v10
	local v12 = font.BaseSize * font.CaptionHeader.RelativeSize
	local v13 = 14 / v12

	local displayUrl = agreement.displayUrl
	local agreementTitle = p2.agreementTitle

	local shortTitle = p2.shortTitle

	if getFFlagVngTOSRevisedEnabled() and self.state.titleTextWidth and self.state.titleTextWidth > 100 then
		minHeight = math.max(
			minHeight,
			TextService:GetTextSize(
				agreementTitle,
				v10,
				font.Body.Font,
				Vector2.new(self.state.titleTextWidth, 1e999)
			).Y + 20 + margin.top + margin.bottom
		)
	end

	local v14, v15, v16

	if fFlagEnableModularizedUserAgreementsList then
		v14 = imageSetLabel

		v15 = images["icons/navigation/pushRight"]
		v16 = 3
	else
		v14 = module2
		v16 = 1
		v15 = "LuaApp/icons/navigation/pushRight_small"
	end

	local createElement = roact.createElement

	if getFFlagVngTOSRevisedEnabled() then
		v8 = UDim2.new(1, widthOffset, 0, minHeight)
	end

	local v18 = {
		LayoutOrder = layoutOrder,
		Size = v8,
		AutoButtonColor = false,
		BackgroundColor3 = props2.Theme.BackgroundOnPress.Color,
		BackgroundTransparency = self.buttonPressed:map(function(p3)
			return p3 and props2.Theme.BackgroundOnPress.Transparency or 1
		end),
		BorderSizePixel = 0,
		[roact.Event.InputBegan] = self.onButtonInputBegan,
		[roact.Event.InputEnded] = self.onButtonInputEnded,
		[roact.Event.Activated] = function()
			if self.props.useExternalBrowserForDisclaimerLinks then
				LUAUFORGE_MODULE_GLOBALS_fON_openExternalBrowser(self.props.linking, displayUrl)
				return
			end

			local v19 = agreementTitle

			if defineFastFlag and string.len(agreementTitle) > 30 then
				v19 = (shortTitle == nil or shortTitle == "") and "Terms" or shortTitle
			end

			self.props.navigateDown({
				name = appPage.GenericWebPage,
				detail = displayUrl,
				extraProps = {
					title = v19,
					notificationType = notificationType.OPEN_CUSTOM_WEBVIEW
				}
			})
		end
	}

	local createElement2 = roact.createElement
	local v20 = {
		PaddingTop = UDim.new(0, margin.top),
		PaddingBottom = UDim.new(0, margin.bottom),
		PaddingLeft = UDim.new(0, margin.left),
		PaddingRight = 0
	}
	local udim

	if fFlagEnableModularizedUserAgreementsList and checkBoxPresent then
		local newUDim = UDim.new

		local v22 = if useExternalLinkArrow then math.floor(margin.right * 2 * 0.75) else margin.right * 2
		udim = newUDim(0, v22)
	else
		udim = UDim.new(0, 0)
	end

	v20.PaddingRight = udim
	local children = {
		Padding = createElement2("UIPadding", v20),
		TextLayout = 0,
		RightImage = 0
	}

	local createElement3 = roact.createElement
	local v22 = {
		Size = UDim2.new(1, v9, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v23 = {
		ListLayout = roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TitleText = 0,
		LinkText = 0
	}
	local v24

	if useBoldTitle then
		v24 = roact.createElement(text, {
			LayoutOrder = 1,
			tag = "auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
			Size = UDim2.new(checkBoxPresent and 0.9 or 1, 0, 0, 0),
			BackgroundTransparency = 1,
			Text = agreementTitle
		})
	elseif fFlagKISAUserAgreementsRedesign then
		local createElement4 = roact.createElement
		local v26 = {
			LayoutOrder = 1,
			tag = {
				["auto-y text-body-medium text-wrap text-align-x-left content-muted"] = useMutedText,
				["text-body-medium text-wrap text-align-x-left content-emphasis"] = not useMutedText
			},
			Size = UDim2.new(checkBoxPresent and 0.9 or 1, 0, 0, 0),
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			Text = 0
		}
		local v27 = if not useMutedText then Enum.AutomaticSize.Y else nil
		v26.AutomaticSize = v27

		v26.Text = agreementTitle
		v24 = createElement4(text, v26)
	elseif getFFlagVngTOSRevisedEnabled() then
		v24 = roact.createElement(styledTextLabel, {
			layoutOrder = 1,
			size = UDim2.new(1, 0, 0, 0),
			text = agreementTitle,
			fontStyle = font.Body,
			colorStyle = theme.TextMuted,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center,
			textTruncate = Enum.TextTruncate.None,
			automaticSize = Enum.AutomaticSize.Y,
			onAbsoluteSizeChange = function(p3)
				local absoluteSize = p3.AbsoluteSize

				if self.state.titleTextWidth ~= absoluteSize.X then
					self:setState({ titleTextWidth = absoluteSize.X })
				end
			end
		})
	else
		local createElement4 = roact.createElement
		local v26 = {
			LayoutOrder = 1,
			Size = UDim2.new(
				fFlagEnableModularizedUserAgreementsList and checkBoxPresent and 0.9 or 1,
				0,
				0,
				fFlagEnableModularizedUserAgreementsList and 40 or 20
			),
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = agreementTitle,
			Font = 0,
			TextSize = 0,
			LineHeight = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextWrapped = 0,
			TextYAlignment = 0
		}

		local v27 = if fFlagEnableModularizedUserAgreementsList then font.Body.Font else font.Header2.Font
		v26.Font = v27
		v26.TextSize = v10
		v26.LineHeight = v11
		v26.TextColor3 = theme.TextMuted.Color
		v26.TextTransparency = theme.TextMuted.Transparency
		v26.TextXAlignment = Enum.TextXAlignment.Left
		v26.TextWrapped = fFlagEnableModularizedUserAgreementsList and true or false
		v26.TextYAlignment = Enum.TextYAlignment.Center
		v24 = createElement4("TextLabel", v26)
	end

	v23.TitleText = v24

	local v25 = if self.showLinkText() then roact.createElement("TextLabel", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = displayUrl,
		Font = font.Header2.Font,
		TextSize = v12,
		LineHeight = v13,
		TextColor3 = theme.TextEmphasis.Color,
		TextTransparency = 0.5,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd
	}) or nil else nil
	v23.LinkText = v25
	children.TextLayout = createElement3("Frame", v22, v23)

	children.RightImage = createImageElement(
		v14,
		v16,
		v15,
		margin.right,
		theme,
		useExternalLinkArrow,
		useChevronArrow
	)
	return createElement("ImageButton", v18, children)
end

function extended:render()
	local agreement = self.props.agreement
	local agreementTitleKey = self.props.agreementTitleKey
		or v5[agreement.agreementType]
		or "CommonUI.UserAgreements.Popup.DefaultAgreementTitle"

	return withLocalization({
		agreementTitle = agreementTitleKey,
		shortTitle = "CommonUI.UserAgreements.Popup.TitleOnWebview"
	})(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local v8 = roactAppPolicy.connect(function(p2)
	return {
		useExternalBrowserForDisclaimerLinks = p2.shouldUseExternalBrowserForDisclaimerLinks()
	}
end)(extended)

local v9 = roactServices.connect({ linking = appLinking })(v8)

return (roactRodux.connect(nil, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(navigateDown(p2))
			end
		end
	}
end)(v9))
