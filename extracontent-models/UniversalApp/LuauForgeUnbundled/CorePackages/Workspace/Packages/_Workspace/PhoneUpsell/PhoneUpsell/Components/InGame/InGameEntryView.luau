local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")
local linkButton = UIBlox.App.Button.LinkButton

local getFFlagDisablePVUpsellDataConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFFlagDisablePVUpsellDataConsent

local function noOp() end

local v5 = {
	onClose = noOp,
	isButtonDisabled = false,
	onExtraButtonClick = noOp,
	isExtraButtonDisabled = false,
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	prefix = "1"
}

local function getButtonStackProps(buttonKey, size_1200, onActivated, isButtonDisabled, extraButtonKey, onActivated2, isExtraButtonDisabled)
	local v6 = {
		{
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = onActivated,
				text = buttonKey,
				isDisabled = isButtonDisabled
			}
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(v6, 1, {
			buttonType = buttonType.Secondary,
			props = {
				onActivated = onActivated2,
				text = extraButtonKey,
				isDisabled = isExtraButtonDisabled
			}
		})
	end

	return { buttonHeight = size_1200, buttons = v6 }
end

local function InGameEntryView(p2)
	local v6 = mergeProps(v5, p2)

	local state, setState = React.useState(false)
	local v7 = {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.VerificationUpsell.Description.PhoneNumberNeverPublic",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v6.titleKey,
		descriptionKey = v6.descriptionKey,
		buttonKey = v6.buttonKey,
		legalTextKey = v6.legalTextKey
	}

	if v6.extraButtonKey and v6.extraButtonKey ~= "" then
		v7.extraButtonKey = v6.extraButtonKey
	end

	local v8 = useStyle()
	local baseSize = v8.Font.BaseSize
	local relativeSize = v8.Font.CaptionHeader.RelativeSize
	local size_150 = v8.Tokens.Size.Size_150

	local v9 = useLocalization(v7)
	v9.legalTextKey = v9.legalTextKey:gsub("{buttonText}", v9.buttonKey)

	return React.createElement(interactiveAlert, {
		title = v9.titleKey,
		screenSize = v6.screenSize,
		buttonStackInfo = getButtonStackProps(
			v9.buttonKey,
			v8.Tokens.Size.Size_1200,
			v6.onButtonClick,
			v6.isButtonDisabled,
			v9.extraButtonKey,
			v6.onExtraButtonClick,
			v6.isExtraButtonDisabled
		),
		onCloseClicked = v6.onClose,
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
						Text = v9.descriptionKey,
						TextSize = baseSize,
						TextColor3 = v8.Theme.TextDefault.Color,
						TextTransparency = v8.Theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						RichText = true
					})
				}
			)
		end,
		footerContent = getFFlagDisablePVUpsellDataConsent() and function(): nil
			return nil
		end or function()
			local createElement = React.createElement
			local v11 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local v12 = {
				ContentPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v8.Tokens.Size.Size_300)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, v8.Tokens.Size.Size_150)
				}),
				LegalTextContainer = 0,
				LegalButtonsContainer = 0
			}
			local v13

			if v6.requireLegalTextCheckbox then
				v13 = React.createElement(
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
						LegalCheckbox = React.createElement(checkbox, {
							onActivated = setState,
							isChecked = state,
							label = ""
						}),
						LegalText = React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Text = v9.legalTextKey,
							TextSize = baseSize * relativeSize,
							TextColor3 = v8.Theme.TextDefault.Color,
							TextTransparency = v8.Theme.TextDefault.Transparency,
							FontFace = normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextWrapped = true,
							Size = UDim2.new(1, -(26 + size_150), 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						})
					}
				)
			elseif v6.alwaysShowLegalText or v6.countryCode.prefix == "1" then
				v13 = React.createElement("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Text = v9.legalTextKey,
					TextSize = baseSize * relativeSize,
					TextColor3 = v8.Theme.TextDefault.Color,
					TextTransparency = v8.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			else
				v13 = false
			end

			v12.LegalTextContainer = v13
			local v14

			if v6.countryCode.prefix == "1" then
				v14 = React.createElement(
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
						TermsOfUseButton = React.createElement(linkButton, {
							text = v9.termsOfUseKey,
							onActivated = v6.onTermsOfUseClick,
							layoutOrder = 5,
							fontStyle = "CaptionBody",
							size = UDim2.fromScale(0.2, 0.2)
						}),
						TextButtonDivider = React.createElement("TextLabel", {
							LayoutOrder = 6,
							BackgroundTransparency = 1,
							Text = "-",
							TextSize = baseSize * relativeSize,
							TextColor3 = v8.Theme.TextDefault.Color,
							TextTransparency = v8.Theme.TextDefault.Transparency,
							FontFace = normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextWrapped = true,
							AutomaticSize = Enum.AutomaticSize.XY
						}),
						PrivacyPolicyButton = React.createElement(linkButton, {
							text = v9.privacyPolicyKey,
							onActivated = v6.onPrivacyPolicyClick,
							layoutOrder = 7,
							fontStyle = "CaptionBody"
						})
					}
				)
			else
				v14 = false
			end

			v12.LegalButtonsContainer = v14
			return createElement("Frame", v11, v12)
		end
	})
end

return InGameEntryView
