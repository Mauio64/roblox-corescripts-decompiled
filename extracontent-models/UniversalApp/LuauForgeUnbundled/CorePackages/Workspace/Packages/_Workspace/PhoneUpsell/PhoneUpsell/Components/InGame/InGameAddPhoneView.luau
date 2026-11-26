local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AuthCommon")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Style")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation").Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")
local textField = UIBlox.App.Input.TextField
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/InGame/CountryCodeButton")
local countryCodeDropdownContainer = AuthCommon.Components.InGame.CountryCodeDropdownContainer
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactUtils").Hooks.useExternalEvent

local getFFlagAddMorePhoneUpsellEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFFlagAddMorePhoneUpsellEvents
local fFlagInExperienceAddPhoneViewNewCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").FFlagInExperienceAddPhoneViewNewCopy

local vector2 = Vector2.new(10000, 10000)

local v5 = {
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	buttonKey = fFlagInExperienceAddPhoneViewNewCopy and "Feature.AccountSettings.Action.Verify" or "Feature.VerificationUpsell.Action.Next",
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	prefix = "1"
}

local function getButtonStackProps(buttonKey, onActivated, isDisabled, extraButtonKey, onActivated2)
	local v6 = {
		{
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = onActivated,
				text = buttonKey,
				isDisabled = isDisabled
			}
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(v6, 1, {
			buttonType = buttonType.Secondary,
			props = {
				onActivated = onActivated2,
				text = extraButtonKey,
				isDisabled = false
			}
		})
	end

	return { buttonHeight = 48, buttons = v6 }
end

local function InGameAddPhoneView(p2)
	local v6 = mergeProps(v5, p2)
	local v7

	if fFlagInExperienceAddPhoneViewNewCopy then
		v7 = {
			phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
			disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
			termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
			privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
			subtitleKey = "Feature.AccountSettings.Description.AddPhoneNumber",
			phonePrivacyDisclaimerKey = "Feature.AccountSettings.Description.NotShownPublicly",
			titleKey = v6.titleKey,
			descriptionKey = v6.descriptionKey,
			buttonKey = v6.buttonKey,
			legalTextKey = v6.legalTextKey
		}
	else
		v7 = {
			phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
			disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
			termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
			privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
			titleKey = v6.titleKey,
			descriptionKey = v6.descriptionKey,
			buttonKey = v6.buttonKey,
			legalTextKey = v6.legalTextKey
		}
	end

	if v6.extraButtonKey and v6.extraButtonKey ~= "" then
		v7.extraButtonKey = v6.extraButtonKey
	end

	local v8 = useStyle()
	local tokens = v8.Tokens
	local bodyLarge = tokens.Typography.BodyLarge
	local font = bodyLarge.Font
	local fontSize = bodyLarge.FontSize

	local v9 = useLocalization(v7)

	local baseSize = v8.Font.BaseSize
	local relativeSize = v8.Font.CaptionHeader.RelativeSize
	local isDisabled = v6.isDisabled

	local small = tokens.Gap.Small
	local size_1200 = tokens.Size.Size_1200

	local prefix = v6.countryCode.prefix
	local state, setState = React.useState(false)
	local v10 = math.max(Style.GetTextSize(prefix, fontSize, font, vector2).X + 24, size_1200)
	local state2, setState2 = React.useState(300)

	local function onAbsoluteSizeChanged(p3)
		setState2(p3.AbsoluteSize.X)
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v11 = Vector2.new(0, 0)
	local v12 = Vector2.new(0, 0)
	local v13 = Vector2.new(0, 0)

	if ref.current then
		v11 = ref.current.AbsolutePosition
	end

	if ref2.current then
		v12 = ref2.current.AbsolutePosition
	end

	if ref3.current then
		v13 = ref3.current.AbsolutePosition
	end

	local v14 = math.min(v6.screenSize.Y - (v11.Y + size_1200 + small - v12.Y) - small, 400)

	local v15 = React.useCallback(function(p3)
		local v16 = size_1200 + small
		local v17

		if p3.Position.X > v13.X and p3.Position.X < v13.X + state2 and p3.Position.Y > v13.Y + v16 then
			v17 = p3.Position.Y < v13.Y + v16 + v14
		else
			v17 = false
		end

		local v18

		if p3.Position.X > v13.X and p3.Position.X < v13.X + v10 and p3.Position.Y > v13.Y then
			v18 = p3.Position.Y < v13.Y + size_1200
		else
			v18 = false
		end

		if state and not (v17 or v18) then
			setState(false)
		end
	end, { state, v13, state2, v10, size_1200 })

	useExternalEvent(UserInputService.InputBegan, v15)

	local v16 = v6.errorMessage and v6.errorMessage ~= ""

	local createElement = React.createElement
	local refsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = ref
	}
	local v18 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, tokens.Size.Size_200)
		}),
		PhoneInputContainer = 0,
		ErrorText = 0
	}

	local createElement2 = React.createElement
	local v20 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 0
	}

	local v21 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, small)
		}),
		CountryCodeButton = React.createElement(module7, {
			countryPrefix = "+" .. prefix,
			onButtonClick = function()
				setState(not state)

				if getFFlagAddMorePhoneUpsellEvents then
					v6.onCountryCodeSelectorClick()
				end
			end,
			size = UDim2.new(0, v10, 0, tokens.Size.Size_1200),
			layoutOrder = 1,
			font = font,
			textSize = fontSize,
			forwardRef = ref3,
			error = v16
		}),
		PhoneInputBox = 0
	}

	local createElement3 = React.createElement
	local v23 = {
		text = v6.phoneNumber,
		placeholder = "",
		required = true,
		onChange = function(p3)
			v6.onPhoneNumberTextChange({ Text = p3 })
		end,
		LayoutOrder = 2,
		width = UDim.new(1, -(v10 + small)),
		error = v16,
		textInputType = 0,
		onFocusGained = 0
	}

	local v24 = if v6.usePhoneNumberTextType then Enum.TextInputType.Phone else Enum.TextInputType.Number
	v23.textInputType = v24

	local v25 = if getFFlagAddMorePhoneUpsellEvents() then v6.onPhoneInputFocus else nil
	v23.onFocusGained = v25
	v21.PhoneInputBox = createElement3(textField, v23)
	v18.PhoneInputContainer = createElement2("Frame", v20, v21)

	v18.ErrorText = v16 and React.createElement("TextLabel", {
		Text = v6.errorMessage,
		TextTransparency = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextColor3 = tokens.Color.System.Alert.Color3,
		FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
		TextSize = baseSize * v8.Font.CaptionSmall.RelativeSize,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	})
	local element = createElement("Frame", refsByRef, v18)

	local createElement4 = React.createElement
	local v27 = {
		screenSize = v6.screenSize,
		buttonStackInfo = getButtonStackProps(
			v9.buttonKey,
			v6.onSetPhoneNumber,
			isDisabled,
			v9.extraButtonKey,
			v6.onExtraButtonClick
		),
		position = v6.isKeyboardShowing and UDim2.new(0.5, 0, 1, -v6.keyboardHeight) or UDim2.fromScale(0.5, 0.5),
		anchorPoint = v6.isKeyboardShowing and Vector2.new(0.5, 1) or nil,
		title = v9.titleKey,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		onCloseClicked = v6.onClose,
		middleContent = 0
	}
	local v28

	if fFlagInExperienceAddPhoneViewNewCopy then
		v28 = function()
			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					AddPhoneViewFrame = React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						},
						{
							ListLayout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, tokens.Size.Size_200)
							}),
							SubtitleText = React.createElement("TextLabel", {
								LayoutOrder = -1,
								BackgroundTransparency = 1,
								Text = v9.subtitleKey,
								TextSize = baseSize,
								TextColor3 = v8.Theme.TextEmphasis.Color,
								TextTransparency = v8.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							}),
							PhoneInput = element,
							PhonePrivacyText = React.createElement("TextLabel", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								Text = v9.phonePrivacyDisclaimerKey,
								TextSize = baseSize * relativeSize,
								TextColor3 = v8.Theme.TextEmphasis.Color,
								TextTransparency = v8.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							}),
							PrivacyText = React.createElement("TextLabel", {
								LayoutOrder = 3,
								BackgroundTransparency = 1,
								Text = v9.disclaimerKey,
								TextSize = baseSize * relativeSize,
								TextColor3 = v8.Theme.TextEmphasis.Color,
								TextTransparency = v8.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							})
						}
					)
				}
			)
		end
	else
		v28 = function()
			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					AddPhoneViewFrame = React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						},
						{
							ListLayout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, tokens.Size.Size_200)
							}),
							PhoneInput = element,
							PrivacyText = React.createElement("TextLabel", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								Text = v9.disclaimerKey,
								TextSize = baseSize * relativeSize,
								TextColor3 = v8.Theme.TextEmphasis.Color,
								TextTransparency = v8.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							})
						}
					)
				}
			)
		end
	end

	v27.middleContent = v28
	local element2 = createElement4(interactiveAlert, v27)

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			[Roact.Ref] = ref2
		},
		{
			AddPhoneView = element2,
			CountryCodeSelectorFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, state2 - 24, 0, 0),
				ZIndex = 2,
				BorderSizePixel = 0,
				Position = UDim2.new(0, v11.X - v12.X, 0, v11.Y + size_1200 + small - v12.Y)
			}, {
				CountryCodeDropdown = React.createElement(countryCodeDropdownContainer, {
					dropdownVisible = state,
					position = UDim2.new(0, 0, 0, 0),
					maxHeight = v14,
					onCountryCodeSelected = function(p3)
						v6.setCountryCode(p3)
						setState(false)
					end
				})
			})
		}
	)
end

return InGameAddPhoneView
