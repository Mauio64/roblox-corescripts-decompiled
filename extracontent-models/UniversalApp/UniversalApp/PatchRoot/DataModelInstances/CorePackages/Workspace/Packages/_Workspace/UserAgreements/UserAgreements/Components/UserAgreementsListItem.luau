local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local TextService = game:GetService("TextService")
local Roact = dependencies.Roact
local RoactRodux = dependencies.RoactRodux
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local t = dependencies.t
local RobloxAppEnums = dependencies.RobloxAppEnums
local AppPage = RobloxAppEnums.AppPage
local RoactServices = dependencies.RoactServices.RoactServices
local AppLinking = dependencies.RoactServiceTags.AppLinking
local NavigateDown = dependencies.NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = dependencies.SharedFlags.FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local NotificationType = RobloxAppEnums.NotificationType
local withStyle = UIBlox.Core.Style.withStyle
local ArgCheck = dependencies.ArgCheck
local DEPRECATED_ImageSetLabel = require(script.Parent.DEPRECATED_ImageSetLabel)
local withLocalization = dependencies.Localization.withLocalization
local FFlagEnableModularizedUserAgreementsList = dependencies.SharedFlags.FFlagEnableModularizedUserAgreementsList
local GetFFlagVngTOSRevisedEnabled = dependencies.SharedFlags.GetFFlagVngTOSRevisedEnabled
local FFlagKISAUserAgreementsRedesign = dependencies.SharedFlags.FFlagKISAUserAgreementsRedesign
local v28 = game:DefineFastFlag("TrimLongTitleForTOSEnabled", false)
local RoactAppPolicy = dependencies.UniversalAppPolicy.RoactAppPolicy
local FitFrame = dependencies.FitFrame
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local v34 = game:DefineFastFlag("FixLocalizationOfStudioTermsForVNGSKU", false)
local v35 = game:DefineFastFlag("FixLocalizationOfMissingAgreementTitles", false)
local u36 = if not v34 then {
	TermsOfService = "CommonUI.UserAgreements.Popup.Agreement.TermsOfService",
	PrivacyPolicy = "CommonUI.UserAgreements.Popup.Agreement.PrivacyPolicy"
} else {
	TermsOfService = "CommonUI.UserAgreements.Popup.Agreement.TermsOfService",
	PrivacyPolicy = "CommonUI.UserAgreements.Popup.Agreement.PrivacyPolicy",
	StudioTermsForVNGSKU = "CommonUI.UserAgreements.Popup.Agreement.StudioTermsForVNGSKU"
}

if v35 then
	u36.PersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.PersonalInformationPolicy"
	u36.ThirdPartyPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.ThirdPartyPersonalInformationPolicy"
	u36.TransferPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.TransferPersonalInformationPolicy"
	u36.OptionalPersonalInformationPolicy = "CommonUI.UserAgreements.Popup.Agreement.OptionalPersonalInformationPolicy"
end

local v37 = Roact.PureComponent:extend("UserAgreementsListItem")

v37.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	Size = if GetFFlagVngTOSRevisedEnabled() then nil else t.UDim2,
	agreement = t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string
	}),
	minHeight = t.optional(t.integer),
	margin = t.optional(t.strictInterface({
		top = t.integer,
		right = t.integer,
		bottom = t.integer,
		left = t.integer
	})),
	navigateDown = t.callback,
	agreementTypeExists = t.optional(t.boolean),
	useExternalBrowserForDisclaimerLinks = t.optional(t.boolean),
	linking = t.optional(t.table),
	hideLink = t.optional(t.boolean),
	checkBoxPresent = t.optional(t.boolean)
})
v37.defaultProps = {
	agreementTypeExists = false,
	margin = FitFrame.Rect.square(0)
}

function openExternalBrowser(p1, p2) -- line: 120
	-- upvalues: ArgCheck (copy)
	ArgCheck.isNotNil(p1, "linking")
	ArgCheck.isType(p2, "string", "url")
	p1:openURL(p2)
end
function v37.init(p3) -- line: 127
	-- upvalues: Roact (copy), FFlagEnableModularizedUserAgreementsList (copy)
	local v43, v44 = Roact.createBinding(false)

	p3.buttonPressed = v43
	p3.updateButtonPressed = v44

	function p3.onButtonInputBegan(_, p5) -- line: 130
		-- upvalues: p3 (copy)
		if p5.UserInputType == Enum.UserInputType.Touch or p5.UserInputType == Enum.UserInputType.MouseButton1 then
			if p3.buttonPressed:getValue() then
				return
			end

			p3.updateButtonPressed(true)
		end
	end
	function p3.onButtonInputEnded() -- line: 142
		-- upvalues: p3 (copy)
		if p3.buttonPressed:getValue() then
			p3.updateButtonPressed(false)
		end
	end
	function p3.showLinkText() -- line: 148
		-- upvalues: FFlagEnableModularizedUserAgreementsList (copy), p3 (copy)
		if FFlagEnableModularizedUserAgreementsList then
			return not p3.props.hideLink and not p3.props.agreementTypeExists
		end

		return not p3.props.agreementTypeExists
	end
end
function v37.renderWithProviders(p6, p7, p8) -- line: 157
	-- upvalues: FFlagEnableModularizedUserAgreementsList (copy), GetFFlagVngTOSRevisedEnabled (copy), TextService (copy), ImageSetLabel (copy), Images (copy), DEPRECATED_ImageSetLabel (copy), FFlagKISAUserAgreementsRedesign (copy), Roact (copy), Icon (copy), Enums (copy), v28 (copy), AppPage (copy), NotificationType (copy), FoundationText (copy), StyledTextLabel (copy)
	local propsLayoutOrder = p6.props.LayoutOrder
	local propsSize = p6.props.Size
	local v50 = p6.props.minHeight or 55
	local margin = p6.props.margin
	local agreement = p6.props.agreement
	local v53 = p6.props.checkBoxPresent or false
	local p8Font = p8.Font
	local Theme = p8.Theme
	local Tokens = p8.Tokens
	local v57 = -(margin.left + margin.right + 14)
	local v58 = if not FFlagEnableModularizedUserAgreementsList or not v53 then p8Font.BaseSize * p8Font.Header2.RelativeSize else Tokens.FontSize.FontSize_350
	local v59 = 20 / v58
	local v60 = p8Font.BaseSize * p8Font.CaptionHeader.RelativeSize
	local v61 = 14 / v60
	local displayUrl = agreement.displayUrl
	local agreementTitle = p7.agreementTitle
	local shortTitle = p7.shortTitle

	if GetFFlagVngTOSRevisedEnabled() and (p6.state.titleTextWidth and p6.state.titleTextWidth > 100) then
		v50 = math.max(v50, TextService:GetTextSize(agreementTitle, v58, p8Font.Body.Font, Vector2.new(p6.state.titleTextWidth, 1e999)).Y + 20 + margin.top + margin.bottom)
	end

	local v65, n1, v67

	if FFlagEnableModularizedUserAgreementsList then
		v65 = ImageSetLabel
		n1 = 3
		v67 = Images["icons/navigation/pushRight"]
	else
		v65 = DEPRECATED_ImageSetLabel
		n1 = 1
		v67 = "LuaApp/icons/navigation/pushRight_small"
	end

	local function createImageElement(p9, p10, p11) -- line: 212
		-- upvalues: FFlagKISAUserAgreementsRedesign (copy), Roact (copy), Icon (copy), Enums (copy), margin (copy), FFlagEnableModularizedUserAgreementsList (copy), Theme (copy)
		if FFlagKISAUserAgreementsRedesign then
			return Roact.createElement(Icon, {
				name = Enums.IconName.ArrowLargeRight,
				size = Enums.IconSize.Medium,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -margin.right, 0.5, 0)
			})
		end

		return Roact.createElement(p9, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 14 * p10, 0, 14 * p10),
			Position = UDim2.new(1, -margin.right, 0.5, 0),
			Image = p11,
			ImageColor3 = if not FFlagEnableModularizedUserAgreementsList then Theme.SecondaryDefault.Color else Theme.UIEmphasis.Color,
			ImageTransparency = if not FFlagEnableModularizedUserAgreementsList then Theme.SecondaryDefault.Transparency else 0
		})
	end

	return Roact.createElement("ImageButton", {
		LayoutOrder = propsLayoutOrder,
		Size = if not GetFFlagVngTOSRevisedEnabled() then propsSize else UDim2.new(1, 0, 0, v50),
		AutoButtonColor = false,
		BackgroundColor3 = p8.Theme.BackgroundOnPress.Color,
		BackgroundTransparency = p6.buttonPressed:map(function(p12) -- line: 243
			-- upvalues: p8 (copy)
			return p12 and p8.Theme.BackgroundOnPress.Transparency or 1
		end),
		BorderSizePixel = 0,
		[Roact.Event.InputBegan] = p6.onButtonInputBegan,
		[Roact.Event.InputEnded] = p6.onButtonInputEnded,
		[Roact.Event.Activated] = function() -- line: 249
			-- upvalues: p6 (copy), displayUrl (copy), agreementTitle (copy), v28 (copy), shortTitle (copy), AppPage (copy), NotificationType (copy)
			if p6.props.useExternalBrowserForDisclaimerLinks then
				openExternalBrowser(p6.props.linking, displayUrl)

				return
			end

			local v79 = agreementTitle

			if v28 and string.len(agreementTitle) > 30 then
				v79 = if shortTitle ~= nil and shortTitle ~= "" then shortTitle else "Terms"
			end

			p6.props.navigateDown({
				name = AppPage.GenericWebPage,
				detail = displayUrl,
				extraProps = {
					title = v79,
					notificationType = NotificationType.OPEN_CUSTOM_WEBVIEW
				}
			})
		end
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, margin.top),
			PaddingBottom = UDim.new(0, margin.bottom),
			PaddingLeft = UDim.new(0, margin.left),
			PaddingRight = if not FFlagEnableModularizedUserAgreementsList or not v53 then UDim.new(0, 0) else UDim.new(0, margin.right * 2)
		}),
		TextLayout = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, v57, 1, 0)
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TitleText = if not FFlagKISAUserAgreementsRedesign then if not GetFFlagVngTOSRevisedEnabled() then Roact.createElement("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new((not FFlagEnableModularizedUserAgreementsList or not v53) and 1 or 0.9, 0, 0, not FFlagEnableModularizedUserAgreementsList and 20 or 40),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Text = agreementTitle,
				Font = if not FFlagEnableModularizedUserAgreementsList then p8Font.Header2.Font else p8Font.Body.Font,
				TextSize = v58,
				LineHeight = v59,
				TextColor3 = Theme.TextMuted.Color,
				TextTransparency = Theme.TextMuted.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = not not FFlagEnableModularizedUserAgreementsList,
				TextYAlignment = Enum.TextYAlignment.Center
			}) else Roact.createElement(StyledTextLabel, {
				layoutOrder = 1,
				size = UDim2.new(1, 0, 0, 0),
				text = agreementTitle,
				fontStyle = p8Font.Body,
				colorStyle = Theme.TextMuted,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				textTruncate = Enum.TextTruncate.None,
				automaticSize = Enum.AutomaticSize.Y,
				onAbsoluteSizeChange = function(p13) -- line: 306
					-- upvalues: p6 (copy)
					local AbsoluteSize = p13.AbsoluteSize

					if p6.state.titleTextWidth ~= AbsoluteSize.X then
						p6:setState({
							titleTextWidth = AbsoluteSize.X
						})
					end
				end
			}) else Roact.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "text-body-medium text-wrap text-align-x-left content-emphasis",
				BackgroundTransparency = 1,
				Size = UDim2.new(not v53 and 1 or 0.9, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = agreementTitle
			}),
			LinkText = p6.showLinkText() and Roact.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 14),
				Text = displayUrl,
				Font = p8Font.Header2.Font,
				TextSize = v60,
				LineHeight = v61,
				TextColor3 = Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd
			}) or nil
		}),
		RightImage = createImageElement(v65, n1, v67)
	})
end
function v37.render(p14) -- line: 358
	-- upvalues: u36 (ref), withLocalization (copy), withStyle (copy)
	local v70 = u36[p14.props.agreement.agreementType] or "CommonUI.UserAgreements.Popup.DefaultAgreementTitle"

	return withLocalization({
		shortTitle = "CommonUI.UserAgreements.Popup.TitleOnWebview",
		agreementTitle = v70
	})(function(p15) -- line: 368
		-- upvalues: withStyle (copy), p14 (copy)
		return withStyle(function(p16) -- line: 369
			-- upvalues: p14 (copy), p15 (copy)
			return p14:renderWithProviders(p15, p16)
		end)
	end)
end

local v38 = RoactAppPolicy.connect(function(p17) -- line: 375
	return {
		useExternalBrowserForDisclaimerLinks = p17.shouldUseExternalBrowserForDisclaimerLinks()
	}
end)(v37)
local v39 = RoactServices.connect({
	linking = AppLinking
})(v38)

return (RoactRodux.connect(nil, function(p18) -- line: 385
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy)
	return {
		navigateDown = function(p19) -- line: 387
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v19 (copy), p18 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v19.down(v19.fromLegacyPage(p19))

				return
			end

			p18(NavigateDown(p19))
		end
	}
end)(v39))
