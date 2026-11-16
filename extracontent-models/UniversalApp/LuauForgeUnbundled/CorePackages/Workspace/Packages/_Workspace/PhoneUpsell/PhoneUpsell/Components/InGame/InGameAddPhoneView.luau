local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AuthCommon")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Style")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AppCommonLib").Text

local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")
local textField = UIBlox.App.Input.TextField
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/InGame/CountryCodeButton")
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
	local v10

	if foundationFontFaceMigration then
		v10 = Style.GetTextSize(prefix, fontSize, font, vector2).X
	else
		v10 = text.GetTextWidth(prefix, font, fontSize)
	end

	local v11 = math.max(v10 + 24, size_1200)
	local state2, setState2 = React.useState(300)

	local function onAbsoluteSizeChanged(p3)
		setState2(p3.AbsoluteSize.X)
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v12 = Vector2.new(0, 0)
	local v13 = Vector2.new(0, 0)
	local v14 = Vector2.new(0, 0)

	if ref.current then
		v12 = ref.current.AbsolutePosition
	end

	if ref2.current then
		v13 = ref2.current.AbsolutePosition
	end

	if ref3.current then
		v14 = ref3.current.AbsolutePosition
	end

	local v15 = math.min(v6.screenSize.Y - (v12.Y + size_1200 + small - v13.Y) - small, 400)

	local v16 = React.useCallback(function(p3)
		local v17 = size_1200 + small
		local v18

		if p3.Position.X > v14.X and p3.Position.X < v14.X + state2 and p3.Position.Y > v14.Y + v17 then
			v18 = p3.Position.Y < v14.Y + v17 + v15
		else
			v18 = false
		end

		local v19

		if p3.Position.X > v14.X and p3.Position.X < v14.X + v11 and p3.Position.Y > v14.Y then
			v19 = p3.Position.Y < v14.Y + size_1200
		else
			v19 = false
		end

		if state and not (v18 or v19) then
			setState(false)
		end
	end, { state, v14, state2, v11, size_1200 })

	useExternalEvent(UserInputService.InputBegan, v16)

	local v17 = v6.errorMessage and v6.errorMessage ~= ""

	local createElement = React.createElement
	local refsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = ref
	}
	local v19 = {
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
	local v21 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 0
	}

	local v22 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, small)
		}),
		CountryCodeButton = React.createElement(module8, {
			countryPrefix = "+" .. prefix,
			onButtonClick = function()
				setState(not state)

				if getFFlagAddMorePhoneUpsellEvents then
					v6.onCountryCodeSelectorClick()
				end
			end,
			size = UDim2.new(0, v11, 0, tokens.Size.Size_1200),
			layoutOrder = 1,
			font = font,
			textSize = fontSize,
			forwardRef = ref3,
			error = v17
		}),
		PhoneInputBox = 0
	}

	local createElement3 = React.createElement
	local v24 = {
		text = v6.phoneNumber,
		placeholder = "",
		required = true,
		onChange = function(p3)
			v6.onPhoneNumberTextChange({ Text = p3 })
		end,
		LayoutOrder = 2,
		width = UDim.new(1, -(v11 + small)),
		error = v17,
		textInputType = 0,
		onFocusGained = 0
	}

	local v25 = if v6.usePhoneNumberTextType then Enum.TextInputType.Phone else Enum.TextInputType.Number
	v24.textInputType = v25

	local v26 = if getFFlagAddMorePhoneUpsellEvents() then v6.onPhoneInputFocus else nil
	v24.onFocusGained = v26
	v22.PhoneInputBox = createElement3(textField, v24)
	v19.PhoneInputContainer = createElement2("Frame", v21, v22)

	if v17 then
		local createElement4 = React.createElement
		local v28 = {
			Text = v6.errorMessage,
			TextTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = tokens.Color.System.Alert.Color3,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			Size = 0,
			AutomaticSize = 0,
			LayoutOrder = 1
		}
		local v29 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
		v28.Font = v29

		local v30 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.BodyLarge.Font) else nil
		v28.FontFace = v30

		v28.TextSize = baseSize * v8.Font.CaptionSmall.RelativeSize
		v28.Size = UDim2.new(1, 0, 0, 0)
		v28.AutomaticSize = Enum.AutomaticSize.Y
		v17 = createElement4("TextLabel", v28)
	end

	v19.ErrorText = v17
	local element = createElement("Frame", refsByRef, v19)

	local createElement4 = React.createElement
	local v28 = {
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
	local v29

	if fFlagInExperienceAddPhoneViewNewCopy then
		v29 = function()
			local createElement5 = React.createElement
			local v31 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}

			local createElement6 = React.createElement
			local v34 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local children = {
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, tokens.Size.Size_200)
				}),
				SubtitleText = 0,
				PhoneInput = 0,
				PhonePrivacyText = 0,
				PrivacyText = 0
			}

			local createElement7 = React.createElement
			local v36 = {
				LayoutOrder = -1,
				BackgroundTransparency = 1,
				Text = v9.subtitleKey,
				TextSize = baseSize,
				TextColor3 = v8.Theme.TextEmphasis.Color,
				TextTransparency = v8.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local v37 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
			v36.Font = v37

			local v38 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.BodyLarge.Font) else nil
			v36.FontFace = v38

			v36.TextXAlignment = Enum.TextXAlignment.Left

			v36.Size = UDim2.new(1, 0, 0, 0)
			v36.AutomaticSize = Enum.AutomaticSize.Y
			children.SubtitleText = createElement7("TextLabel", v36)

			children.PhoneInput = element
			local createElement8 = React.createElement
			local v40 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = v9.phonePrivacyDisclaimerKey,
				TextSize = baseSize * relativeSize,
				TextColor3 = v8.Theme.TextEmphasis.Color,
				TextTransparency = v8.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local v41 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
			v40.Font = v41

			local v42 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.BodyLarge.Font) else nil
			v40.FontFace = v42

			v40.TextXAlignment = Enum.TextXAlignment.Left

			v40.Size = UDim2.new(1, 0, 0, 0)
			v40.AutomaticSize = Enum.AutomaticSize.Y
			children.PhonePrivacyText = createElement8("TextLabel", v40)

			local createElement9 = React.createElement
			local v44 = {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Text = v9.disclaimerKey,
				TextSize = baseSize * relativeSize,
				TextColor3 = v8.Theme.TextEmphasis.Color,
				TextTransparency = v8.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local v45 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
			v44.Font = v45

			local v46 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.BodyLarge.Font) else nil
			v44.FontFace = v46

			v44.TextXAlignment = Enum.TextXAlignment.Left

			v44.Size = UDim2.new(1, 0, 0, 0)
			v44.AutomaticSize = Enum.AutomaticSize.Y
			children.PrivacyText = createElement9("TextLabel", v44)
			return createElement5("Frame", v31, {
				AddPhoneViewFrame = createElement6("Frame", v34, children)
			})
		end
	else
		v29 = function()
			local createElement5 = React.createElement
			local v31 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}

			local createElement6 = React.createElement
			local v34 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local v35 = {
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, tokens.Size.Size_200)
				}),
				PhoneInput = element,
				PrivacyText = 0
			}

			local createElement7 = React.createElement
			local v37 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = v9.disclaimerKey,
				TextSize = baseSize * relativeSize,
				TextColor3 = v8.Theme.TextEmphasis.Color,
				TextTransparency = v8.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local v38 = if not foundationFontFaceMigration then v8.Font.Body.Font else nil
			v37.Font = v38

			local v39 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.BodyLarge.Font) else nil
			v37.FontFace = v39

			v37.TextXAlignment = Enum.TextXAlignment.Left

			v37.Size = UDim2.new(1, 0, 0, 0)
			v37.AutomaticSize = Enum.AutomaticSize.Y
			v35.PrivacyText = createElement7("TextLabel", v37)
			return createElement5("Frame", v31, {
				AddPhoneViewFrame = createElement6("Frame", v34, v35)
			})
		end
	end

	v28.middleContent = v29
	local element2 = createElement4(interactiveAlert, v28)

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
				Position = UDim2.new(0, v12.X - v13.X, 0, v12.Y + size_1200 + small - v13.Y)
			}, {
				CountryCodeDropdown = React.createElement(countryCodeDropdownContainer, {
					dropdownVisible = state,
					position = UDim2.new(0, 0, 0, 0),
					maxHeight = v15,
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
