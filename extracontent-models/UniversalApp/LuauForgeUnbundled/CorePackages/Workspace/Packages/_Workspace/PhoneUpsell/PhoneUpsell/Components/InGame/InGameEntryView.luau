local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
			local createElement = React.createElement
			local v11 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}

			local createElement2 = React.createElement
			local v14 = {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Text = v9.descriptionKey,
				TextSize = baseSize,
				TextColor3 = v8.Theme.TextDefault.Color,
				TextTransparency = v8.Theme.TextDefault.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0,
				RichText = true
			}
			local v15 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
			v14.Font = v15

			local v16 = if foundationFontFaceMigration then normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font) else nil
			v14.FontFace = v16

			v14.TextXAlignment = Enum.TextXAlignment.Left

			v14.Size = UDim2.new(1, 0, 0, 0)
			v14.AutomaticSize = Enum.AutomaticSize.Y
			return createElement("Frame", v11, {
				BodyText = createElement2("TextLabel", v14)
			})
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
				local createElement2 = React.createElement
				local v15 = {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}
				local v16 = {
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
					LegalText = 0
				}

				local createElement3 = React.createElement
				local v18 = {
					BackgroundTransparency = 1,
					Text = v9.legalTextKey,
					TextSize = baseSize * relativeSize,
					TextColor3 = v8.Theme.TextDefault.Color,
					TextTransparency = v8.Theme.TextDefault.Transparency,
					Font = 0,
					FontFace = 0,
					TextXAlignment = 0,
					TextWrapped = true,
					Size = 0,
					AutomaticSize = 0
				}
				local v19 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
				v18.Font = v19

				local v20 = if foundationFontFaceMigration then normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font) else nil
				v18.FontFace = v20

				v18.TextXAlignment = Enum.TextXAlignment.Left

				v18.Size = UDim2.new(1, -(26 + size_150), 0, 0)
				v18.AutomaticSize = Enum.AutomaticSize.Y
				v16.LegalText = createElement3("TextLabel", v18)
				v13 = createElement2("Frame", v15, v16)
			elseif v6.alwaysShowLegalText or v6.countryCode.prefix == "1" then
				local createElement2 = React.createElement
				local v15 = {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Text = v9.legalTextKey,
					TextSize = baseSize * relativeSize,
					TextColor3 = v8.Theme.TextDefault.Color,
					TextTransparency = v8.Theme.TextDefault.Transparency,
					Font = 0,
					FontFace = 0,
					TextXAlignment = 0,
					TextWrapped = true,
					Size = 0,
					AutomaticSize = 0
				}
				local v16 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
				v15.Font = v16

				local v17 = if foundationFontFaceMigration then normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font) else nil
				v15.FontFace = v17

				v15.TextXAlignment = Enum.TextXAlignment.Left

				v15.Size = UDim2.new(1, 0, 0, 0)
				v15.AutomaticSize = Enum.AutomaticSize.Y
				v13 = createElement2("TextLabel", v15)
			else
				v13 = false
			end

			v12.LegalTextContainer = v13
			local v14

			if v6.countryCode.prefix == "1" then
				local createElement2 = React.createElement
				local v16 = {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}
				local children = {
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
					TextButtonDivider = 0,
					PrivacyPolicyButton = 0
				}

				local createElement3 = React.createElement
				local v18 = {
					LayoutOrder = 6,
					BackgroundTransparency = 1,
					Text = "-",
					TextSize = baseSize * relativeSize,
					TextColor3 = v8.Theme.TextDefault.Color,
					TextTransparency = v8.Theme.TextDefault.Transparency,
					Font = 0,
					FontFace = 0,
					TextXAlignment = 0,
					TextWrapped = true,
					AutomaticSize = 0
				}
				local v19 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
				v18.Font = v19

				local v20 = if foundationFontFaceMigration then normalizeFontFace(v8.Tokens.Typography.BodyLarge.Font) else nil
				v18.FontFace = v20

				v18.TextXAlignment = Enum.TextXAlignment.Center

				v18.AutomaticSize = Enum.AutomaticSize.XY
				children.TextButtonDivider = createElement3("TextLabel", v18)

				children.PrivacyPolicyButton = React.createElement(linkButton, {
					text = v9.privacyPolicyKey,
					onActivated = v6.onPrivacyPolicyClick,
					layoutOrder = 7,
					fontStyle = "CaptionBody"
				})
				v14 = createElement2("Frame", v16, children)
			else
				v14 = false
			end

			v12.LegalButtonsContainer = v14
			return createElement("Frame", v11, v12)
		end
	})
end

return InGameEntryView
