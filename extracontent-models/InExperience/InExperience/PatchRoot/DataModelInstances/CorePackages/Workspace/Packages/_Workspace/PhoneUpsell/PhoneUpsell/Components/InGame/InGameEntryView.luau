local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local LinkButton = UIBlox.App.Button.LinkButton

local SharedFlags = require(parent.SharedFlags)
local GetFFlagDisablePVUpsellDataConsent = SharedFlags.GetFFlagDisablePVUpsellDataConsent

local function noOp() end

local v = {
	onClose = noOp,
	isButtonDisabled = false,
	onExtraButtonClick = noOp,
	isExtraButtonDisabled = false,
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	prefix = "1"
}

local function getButtonStackProps(buttonKey: string, size_1200: number, onActivated, isButtonDisabled: boolean, extraButtonKey: string, onActivated2, isExtraButtonDisabled: boolean)
	local buttons = {
		{
			buttonType = ButtonType.PrimarySystem,
			props = { onActivated = onActivated, text = buttonKey, isDisabled = isButtonDisabled }
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(buttons, 1, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = onActivated2,
				text = extraButtonKey,
				isDisabled = isExtraButtonDisabled
			}
		})
	end

	return { buttonHeight = size_1200, buttons = buttons }
end

local function InGameEntryView(p)
	local v2 = mergeProps(v, p)

	local state, setState = React.useState(false)
	local v3 = {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.VerificationUpsell.Description.PhoneNumberNeverPublic",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v2.titleKey,
		descriptionKey = v2.descriptionKey,
		buttonKey = v2.buttonKey,
		legalTextKey = v2.legalTextKey
	}

	if v2.extraButtonKey and v2.extraButtonKey ~= "" then
		v3.extraButtonKey = v2.extraButtonKey
	end

	local v4 = useStyle()
	local baseSize = v4.Font.BaseSize
	local relativeSize = v4.Font.CaptionHeader.RelativeSize
	local size_150 = v4.Tokens.Size.Size_150

	local v5 = useLocalization(v3)
	v5.legalTextKey = v5.legalTextKey:gsub("{buttonText}", v5.buttonKey)

	return React.createElement(InteractiveAlert, {
		title = v5.titleKey,
		screenSize = v2.screenSize,
		buttonStackInfo = getButtonStackProps(
			v5.buttonKey,
			v4.Tokens.Size.Size_1200,
			v2.onButtonClick,
			v2.isButtonDisabled,
			v5.extraButtonKey,
			v2.onExtraButtonClick,
			v2.isExtraButtonDisabled
		),
		onCloseClicked = v2.onClose,
		middleContent = function()
			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					BodyText = React.createElement("TextLabel", {
						LayoutOrder = 0,
						BackgroundTransparency = 1,
						Text = v5.descriptionKey,
						TextSize = baseSize,
						TextColor3 = v4.Theme.TextDefault.Color,
						TextTransparency = v4.Theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(v4.Tokens.Typography.BodyLarge.Font),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						RichText = true
					})
				}
			)
		end,
		footerContent = GetFFlagDisablePVUpsellDataConsent() and function(): nil
			return nil
		end or function()
			local createElement = React.createElement
			local v6 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local v7 = {
				ContentPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v4.Tokens.Size.Size_300)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, v4.Tokens.Size.Size_150)
				}),
				LegalTextContainer = 0,
				LegalButtonsContainer = 0
			}
			local legalTextContainer

			if v2.requireLegalTextCheckbox then
				legalTextContainer = React.createElement(
					"Frame",
					{
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, size_150)
						}),
						LegalCheckbox = React.createElement(Checkbox, {
							onActivated = setState,
							isChecked = state,
							label = ""
						}),
						LegalText = React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Text = v5.legalTextKey,
							TextSize = baseSize * relativeSize,
							TextColor3 = v4.Theme.TextDefault.Color,
							TextTransparency = v4.Theme.TextDefault.Transparency,
							FontFace = normalizeFontFace(v4.Tokens.Typography.BodyLarge.Font),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextWrapped = true,
							Size = UDim2.new(1, -(26 + size_150), 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						})
					}
				)
			elseif v2.alwaysShowLegalText or v2.countryCode.prefix == "1" then
				legalTextContainer = React.createElement("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Text = v5.legalTextKey,
					TextSize = baseSize * relativeSize,
					TextColor3 = v4.Theme.TextDefault.Color,
					TextTransparency = v4.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v4.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			else
				legalTextContainer = false
			end

			v7.LegalTextContainer = legalTextContainer
			local legalButtonsContainer

			if v2.countryCode.prefix == "1" then
				legalButtonsContainer = React.createElement(
					"Frame",
					{
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 5)
						}),
						TermsOfUseButton = React.createElement(LinkButton, {
							text = v5.termsOfUseKey,
							onActivated = v2.onTermsOfUseClick,
							layoutOrder = 5,
							fontStyle = "CaptionBody",
							size = UDim2.fromScale(0.2, 0.2)
						}),
						TextButtonDivider = React.createElement("TextLabel", {
							LayoutOrder = 6,
							BackgroundTransparency = 1,
							Text = "-",
							TextSize = baseSize * relativeSize,
							TextColor3 = v4.Theme.TextDefault.Color,
							TextTransparency = v4.Theme.TextDefault.Transparency,
							FontFace = normalizeFontFace(v4.Tokens.Typography.BodyLarge.Font),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextWrapped = true,
							AutomaticSize = Enum.AutomaticSize.XY
						}),
						PrivacyPolicyButton = React.createElement(LinkButton, {
							text = v5.privacyPolicyKey,
							onActivated = v2.onPrivacyPolicyClick,
							layoutOrder = 7,
							fontStyle = "CaptionBody"
						})
					}
				)
			else
				legalButtonsContainer = false
			end

			v7.LegalButtonsContainer = legalButtonsContainer
			return createElement("Frame", v6, v7)
		end
	})
end

return InGameEntryView
