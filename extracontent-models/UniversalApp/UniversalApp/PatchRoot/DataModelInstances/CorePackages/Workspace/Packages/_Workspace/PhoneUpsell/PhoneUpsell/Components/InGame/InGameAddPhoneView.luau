local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local UserInputService = game:GetService("UserInputService")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)
local Roact = require(PhoneUpsellParent.Roact)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local AuthCommon = require(PhoneUpsellParent.AuthCommon)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local TextField = UIBlox.App.Input.TextField
local CountryCodeButton = require(PhoneUpsell.Components.InGame.CountryCodeButton)
local Text = require(PhoneUpsellParent.AppCommonLib).Text
local CountryCodeDropdownContainer = AuthCommon.Components.InGame.CountryCodeDropdownContainer
local useExternalEvent = require(PhoneUpsellParent.RoactUtils).Hooks.useExternalEvent
local GetFFlagAddMorePhoneUpsellEvents = require(PhoneUpsellParent.SharedFlags).GetFFlagAddMorePhoneUpsellEvents
local FFlagInExperienceAddPhoneViewNewCopy = require(PhoneUpsellParent.SharedFlags).FFlagInExperienceAddPhoneViewNewCopy
local t1 = {
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	prefix = "1",
	buttonKey = not FFlagInExperienceAddPhoneViewNewCopy and "Feature.VerificationUpsell.Action.Next" or "Feature.AccountSettings.Action.Verify"
}

local function getButtonStackProps(s1: string, p1: ((...any) -> ...any), b1: boolean, s2: string, p2: ((...any) -> ...any)) -- line: 68
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
				isDisabled = false,
				onActivated = p2,
				text = s2
			}
		})
	end

	return {
		buttonHeight = 48,
		buttons = t2
	}
end
local function InGameAddPhoneView(t3: {[any]: any}) -- line: 103
	-- upvalues: mergeProps (copy), t1 (copy), FFlagInExperienceAddPhoneViewNewCopy (copy), useStyle (copy), useLocalization (copy), React (copy), Text (copy), useExternalEvent (copy), UserInputService (copy), Roact (copy), CountryCodeButton (copy), GetFFlagAddMorePhoneUpsellEvents (copy), TextField (copy), InteractiveAlert (copy), getButtonStackProps (copy), CountryCodeDropdownContainer (copy)
	local v30 = mergeProps(t1, t3)
	local v31 = if not FFlagInExperienceAddPhoneViewNewCopy then {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v30.titleKey,
		descriptionKey = v30.descriptionKey,
		buttonKey = v30.buttonKey,
		legalTextKey = v30.legalTextKey
	} else {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		subtitleKey = "Feature.AccountSettings.Description.AddPhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.AccountSettings.Description.NotShownPublicly",
		titleKey = v30.titleKey,
		descriptionKey = v30.descriptionKey,
		buttonKey = v30.buttonKey,
		legalTextKey = v30.legalTextKey
	}

	if v30.extraButtonKey and v30.extraButtonKey ~= "" then
		v31.extraButtonKey = v30.extraButtonKey
	end

	local v32 = useStyle()
	local Tokens = v32.Tokens
	local TextField2 = Tokens.Component.TextField
	local TypographyFont = TextField2.Base.Field.Typography.Font
	local FontSize = TextField2.Base.Field.Typography.FontSize
	local v37 = useLocalization(v31)
	local BaseSize = v32.Font.BaseSize
	local RelativeSize = v32.Font.CaptionHeader.RelativeSize
	local isDisabled = v30.isDisabled
	local Small = Tokens.Gap.Small
	local Size_1200 = Tokens.Size.Size_1200
	local prefix = v30.countryCode.prefix
	local v44, v45 = React.useState(false)
	local v46 = math.max(Text.GetTextWidth(prefix, TypographyFont, FontSize) + 24, Size_1200)
	local v47, v48 = React.useState(300)
	local v49 = React.useRef(nil)
	local v50 = React.useRef(nil)
	local v51 = React.useRef(nil)
	local vector2 = Vector2.new(0, 0)
	local vector2_2 = Vector2.new(0, 0)
	local vector2_3 = Vector2.new(0, 0)

	if v49.current then
		vector2 = v49.current.AbsolutePosition
	end

	if v50.current then
		vector2_2 = v50.current.AbsolutePosition
	end

	if v51.current then
		vector2_3 = v51.current.AbsolutePosition
	end

	local u55 = math.min(v30.screenSize.Y - (vector2.Y + Size_1200 + Small - vector2_2.Y) - Small, 400)
	local v56 = React.useCallback(function(p3) -- line: 184
		-- upvalues: Size_1200 (copy), Small (copy), vector2_3 (ref), v47 (copy), u55 (ref), v46 (copy), v44 (copy), v45 (copy)
		local v62 = Size_1200 + Small
		local v63 = p3.Position.X > vector2_3.X and (p3.Position.X < vector2_3.X + v47 and (p3.Position.Y > vector2_3.Y + v62 and p3.Position.Y < vector2_3.Y + v62 + u55))
		local v64 = p3.Position.X > vector2_3.X and (p3.Position.X < vector2_3.X + v46 and (p3.Position.Y > vector2_3.Y and p3.Position.Y < vector2_3.Y + Size_1200))

		if v44 and (not v63 and not v64) then
			v45(false)
		end
	end, {
		v44,
		vector2_3,
		v47,
		v46,
		Size_1200
	})

	useExternalEvent(UserInputService.InputBegan, v56)

	local v57 = v30.errorMessage and v30.errorMessage ~= ""
	local v58 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = v49
	}, {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, Tokens.Size.Size_200)
		}),
		PhoneInputContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, Small)
			}),
			CountryCodeButton = React.createElement(CountryCodeButton, {
				layoutOrder = 1,
				countryPrefix = "+" .. prefix,
				onButtonClick = function() -- line: 237
					-- upvalues: v45 (copy), v44 (copy), GetFFlagAddMorePhoneUpsellEvents (copy), v30 (copy)
					v45(not v44)

					if GetFFlagAddMorePhoneUpsellEvents then
						v30.onCountryCodeSelectorClick()
					end
				end,
				size = UDim2.new(0, v46, 0, Tokens.Size.Size_1200),
				font = TypographyFont,
				textSize = FontSize,
				forwardRef = v51,
				error = v57
			}),
			PhoneInputBox = React.createElement(TextField, {
				placeholder = "",
				required = true,
				LayoutOrder = 2,
				text = v30.phoneNumber,
				onChange = function(s3: string) -- line: 254
					-- upvalues: v30 (copy)
					v30.onPhoneNumberTextChange({
						Text = s3
					})
				end,
				width = UDim.new(1, -(v46 + Small)),
				error = v57,
				textInputType = if not v30.usePhoneNumberTextType then Enum.TextInputType.Number else Enum.TextInputType.Phone,
				onFocusGained = if not GetFFlagAddMorePhoneUpsellEvents() then nil else v30.onPhoneInputFocus
			})
		}),
		ErrorText = v57 and React.createElement("TextLabel", {
			TextTransparency = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Text = v30.errorMessage,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = Tokens.Color.System.Alert.Color3,
			Font = v32.Font.Body.Font,
			TextSize = BaseSize * v32.Font.CaptionSmall.RelativeSize,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	})
	local v59 = React.createElement(InteractiveAlert, {
		screenSize = v30.screenSize,
		buttonStackInfo = getButtonStackProps(v37.buttonKey, v30.onSetPhoneNumber, isDisabled, v37.extraButtonKey, v30.onExtraButtonClick),
		position = v30.isKeyboardShowing and UDim2.new(0.5, 0, 1, -v30.keyboardHeight) or UDim2.fromScale(0.5, 0.5),
		anchorPoint = v30.isKeyboardShowing and Vector2.new(0.5, 1) or nil,
		title = v37.titleKey,
		onAbsoluteSizeChanged = function(p4) -- line: 154
			-- upvalues: v48 (copy)
			v48(p4.AbsoluteSize.X)
		end,
		onCloseClicked = v30.onClose,
		middleContent = not FFlagInExperienceAddPhoneViewNewCopy and function() -- line: 357
			-- upvalues: React (copy), Tokens (copy), v58 (copy), v37 (copy), BaseSize (copy), RelativeSize (copy), v32 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				AddPhoneViewFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, Tokens.Size.Size_200)
					}),
					PhoneInput = v58,
					PrivacyText = React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v37.disclaimerKey,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v32.Theme.TextEmphasis.Color,
						TextTransparency = v32.Theme.TextEmphasis.Transparency,
						Font = v32.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				})
			})
		end or function() -- line: 298
			-- upvalues: React (copy), Tokens (copy), v37 (copy), BaseSize (copy), v32 (copy), v58 (copy), RelativeSize (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				AddPhoneViewFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, Tokens.Size.Size_200)
					}),
					SubtitleText = React.createElement("TextLabel", {
						LayoutOrder = -1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v37.subtitleKey,
						TextSize = BaseSize,
						TextColor3 = v32.Theme.TextEmphasis.Color,
						TextTransparency = v32.Theme.TextEmphasis.Transparency,
						Font = v32.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}),
					PhoneInput = v58,
					PhonePrivacyText = React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v37.phonePrivacyDisclaimerKey,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v32.Theme.TextEmphasis.Color,
						TextTransparency = v32.Theme.TextEmphasis.Transparency,
						Font = v32.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}),
					PrivacyText = React.createElement("TextLabel", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v37.disclaimerKey,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v32.Theme.TextEmphasis.Color,
						TextTransparency = v32.Theme.TextEmphasis.Transparency,
						Font = v32.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				})
			})
		end
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		[Roact.Ref] = v50
	}, {
		AddPhoneView = v59,
		CountryCodeSelectorFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0, v47 - 24, 0, 0),
			Position = UDim2.new(0, vector2.X - vector2_2.X, 0, vector2.Y + Size_1200 + Small - vector2_2.Y)
		}, {
			CountryCodeDropdown = React.createElement(CountryCodeDropdownContainer, {
				dropdownVisible = v44,
				position = UDim2.new(0, 0, 0, 0),
				maxHeight = u55,
				onCountryCodeSelected = function(p5) -- line: 416
					-- upvalues: v30 (copy), v45 (copy)
					v30.setCountryCode(p5)
					v45(false)
				end
			})
		})
	})
end

return InGameAddPhoneView
