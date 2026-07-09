local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local Checkbox = require(PhoneUpsellParent.Foundation).Checkbox
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local LinkButton = UIBlox.App.Button.LinkButton
local GetFFlagDisablePVUpsellDataConsent = require(PhoneUpsellParent.SharedFlags).GetFFlagDisablePVUpsellDataConsent

local function noOp() -- line: 51
end

local t1 = {
	isButtonDisabled = false,
	isExtraButtonDisabled = false,
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	prefix = "1",
	onClose = noOp,
	onExtraButtonClick = noOp
}

local function getButtonStackProps(s1: string, n1: number, p1: ((...any) -> ...any), b1: boolean, s2: string, p2: ((...any) -> ...any), b2: boolean) -- line: 64
	-- upvalues: ButtonType (copy)
	local t2 = {{
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = p1,
			text = s1,
			isDisabled = b1
		}
	}}

	if s2 and s2 ~= "" then
		table.insert(t2, 1, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = p2,
				text = s2,
				isDisabled = b2
			}
		})
	end

	return {
		buttonHeight = n1,
		buttons = t2
	}
end
local function InGameEntryView(t3: {[any]: any}) -- line: 100
	-- upvalues: mergeProps (copy), t1 (copy), React (copy), useStyle (copy), useLocalization (copy), InteractiveAlert (copy), getButtonStackProps (copy), GetFFlagDisablePVUpsellDataConsent (copy), Checkbox (copy), LinkButton (copy)
	local v26 = mergeProps(t1, t3)
	local v27, v28 = React.useState(false)
	local t4 = {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.VerificationUpsell.Description.PhoneNumberNeverPublic",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v26.titleKey,
		descriptionKey = v26.descriptionKey,
		buttonKey = v26.buttonKey,
		legalTextKey = v26.legalTextKey
	}

	if v26.extraButtonKey and v26.extraButtonKey ~= "" then
		t4.extraButtonKey = v26.extraButtonKey
	end

	local v30 = useStyle()
	local BaseSize = v30.Font.BaseSize
	local RelativeSize = v30.Font.CaptionHeader.RelativeSize
	local Size_150 = v30.Tokens.Size.Size_150
	local v34 = useLocalization(t4)

	v34.legalTextKey = v34.legalTextKey:gsub("{buttonText}", v34.buttonKey)

	return React.createElement(InteractiveAlert, {
		title = v34.titleKey,
		screenSize = v26.screenSize,
		buttonStackInfo = getButtonStackProps(v34.buttonKey, v30.Tokens.Size.Size_1200, v26.onButtonClick, v26.isButtonDisabled, v34.extraButtonKey, v26.onExtraButtonClick, v26.isExtraButtonDisabled),
		onCloseClicked = v26.onClose,
		middleContent = function() -- line: 139
			-- upvalues: React (copy), v34 (copy), BaseSize (copy), v30 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				BodyText = React.createElement("TextLabel", {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					TextWrapped = true,
					RichText = true,
					Text = v34.descriptionKey,
					TextSize = BaseSize,
					TextColor3 = v30.Theme.TextDefault.Color,
					TextTransparency = v30.Theme.TextDefault.Transparency,
					Font = v30.Font.Body.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			})
		end,
		footerContent = GetFFlagDisablePVUpsellDataConsent() and function() -- line: 267
			return nil
		end or function() -- line: 162
			-- upvalues: React (copy), v30 (copy), v26 (copy), Size_150 (copy), Checkbox (copy), v28 (copy), v27 (copy), v34 (copy), BaseSize (copy), RelativeSize (copy), LinkButton (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				ContentPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v30.Tokens.Size.Size_300)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, v30.Tokens.Size.Size_150)
				}),
				LegalTextContainer = if not v26.requireLegalTextCheckbox then (v26.alwaysShowLegalText or v26.countryCode.prefix == "1") and React.createElement("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Text = v34.legalTextKey,
					TextSize = BaseSize * RelativeSize,
					TextColor3 = v30.Theme.TextDefault.Color,
					TextTransparency = v30.Theme.TextDefault.Transparency,
					Font = v30.Font.Body.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}) else React.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, Size_150)
					}),
					LegalCheckbox = React.createElement(Checkbox, {
						label = "",
						onActivated = v28,
						isChecked = v27
					}),
					LegalText = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v34.legalTextKey,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v30.Theme.TextDefault.Color,
						TextTransparency = v30.Theme.TextDefault.Transparency,
						Font = v30.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -(26 + Size_150), 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				}),
				LegalButtonsContainer = v26.countryCode.prefix == "1" and React.createElement("Frame", {
					LayoutOrder = 4,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 5)
					}),
					TermsOfUseButton = React.createElement(LinkButton, {
						layoutOrder = 5,
						fontStyle = "CaptionBody",
						text = v34.termsOfUseKey,
						onActivated = v26.onTermsOfUseClick,
						size = UDim2.fromScale(0.2, 0.2)
					}),
					TextButtonDivider = React.createElement("TextLabel", {
						LayoutOrder = 6,
						BackgroundTransparency = 1,
						Text = "-",
						TextWrapped = true,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v30.Theme.TextDefault.Color,
						TextTransparency = v30.Theme.TextDefault.Transparency,
						Font = v30.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Center,
						AutomaticSize = Enum.AutomaticSize.XY
					}),
					PrivacyPolicyButton = React.createElement(LinkButton, {
						layoutOrder = 7,
						fontStyle = "CaptionBody",
						text = v34.privacyPolicyKey,
						onActivated = v26.onPrivacyPolicyClick
					})
				})
			})
		end
	})
end

return InGameEntryView
