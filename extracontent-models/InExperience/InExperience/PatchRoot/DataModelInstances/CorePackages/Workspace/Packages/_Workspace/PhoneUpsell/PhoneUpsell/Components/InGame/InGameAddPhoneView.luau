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
local FFlagRenameDeprecatedUIBloxTokens = require(PhoneUpsellParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local t1 = {
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	prefix = "1",
	buttonKey = not FFlagInExperienceAddPhoneViewNewCopy and "Feature.VerificationUpsell.Action.Next" or "Feature.AccountSettings.Action.Verify"
}

local function getButtonStackProps(s1: string, p1: ((...any) -> ...any), b1: boolean, s2: string, p2: ((...any) -> ...any)) -- line: 69
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
local function InGameAddPhoneView(t3: {[any]: any}) -- line: 104
	-- upvalues: mergeProps (copy), t1 (copy), FFlagInExperienceAddPhoneViewNewCopy (copy), useStyle (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useLocalization (copy), React (copy), Text (copy), useExternalEvent (copy), UserInputService (copy), Roact (copy), CountryCodeButton (copy), GetFFlagAddMorePhoneUpsellEvents (copy), TextField (copy), InteractiveAlert (copy), getButtonStackProps (copy), CountryCodeDropdownContainer (copy)
	local v31 = mergeProps(t1, t3)
	local v32 = if not FFlagInExperienceAddPhoneViewNewCopy then {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v31.titleKey,
		descriptionKey = v31.descriptionKey,
		buttonKey = v31.buttonKey,
		legalTextKey = v31.legalTextKey
	} else {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		subtitleKey = "Feature.AccountSettings.Description.AddPhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.AccountSettings.Description.NotShownPublicly",
		titleKey = v31.titleKey,
		descriptionKey = v31.descriptionKey,
		buttonKey = v31.buttonKey,
		legalTextKey = v31.legalTextKey
	}

	if v31.extraButtonKey and v31.extraButtonKey ~= "" then
		v32.extraButtonKey = v31.extraButtonKey
	end

	local v33 = useStyle()
	local Tokens = v33.Tokens
	local v35 = if not FFlagRenameDeprecatedUIBloxTokens then Tokens.Component.TextField.Base.Field.Typography else Tokens.Typography.BodyLarge
	local Font = v35.Font
	local FontSize = v35.FontSize
	local v38 = useLocalization(v32)
	local BaseSize = v33.Font.BaseSize
	local RelativeSize = v33.Font.CaptionHeader.RelativeSize
	local isDisabled = v31.isDisabled
	local Small = Tokens.Gap.Small
	local Size_1200 = Tokens.Size.Size_1200
	local prefix = v31.countryCode.prefix
	local v45, v46 = React.useState(false)
	local v47 = math.max(Text.GetTextWidth(prefix, Font, FontSize) + 24, Size_1200)
	local v48, v49 = React.useState(300)
	local v50 = React.useRef(nil)
	local v51 = React.useRef(nil)
	local v52 = React.useRef(nil)
	local vector2 = Vector2.new(0, 0)
	local vector2_2 = Vector2.new(0, 0)
	local vector2_3 = Vector2.new(0, 0)

	if v50.current then
		vector2 = v50.current.AbsolutePosition
	end

	if v51.current then
		vector2_2 = v51.current.AbsolutePosition
	end

	if v52.current then
		vector2_3 = v52.current.AbsolutePosition
	end

	local u56 = math.min(v31.screenSize.Y - (vector2.Y + Size_1200 + Small - vector2_2.Y) - Small, 400)
	local v57 = React.useCallback(function(p3) -- line: 187
		-- upvalues: Size_1200 (copy), Small (copy), vector2_3 (ref), v48 (copy), u56 (ref), v47 (copy), v45 (copy), v46 (copy)
		local v63 = Size_1200 + Small
		local v64 = p3.Position.X > vector2_3.X and (p3.Position.X < vector2_3.X + v48 and (p3.Position.Y > vector2_3.Y + v63 and p3.Position.Y < vector2_3.Y + v63 + u56))
		local v65 = p3.Position.X > vector2_3.X and (p3.Position.X < vector2_3.X + v47 and (p3.Position.Y > vector2_3.Y and p3.Position.Y < vector2_3.Y + Size_1200))

		if v45 and (not v64 and not v65) then
			v46(false)
		end
	end, {
		v45,
		vector2_3,
		v48,
		v47,
		Size_1200
	})

	useExternalEvent(UserInputService.InputBegan, v57)

	local v58 = v31.errorMessage and v31.errorMessage ~= ""
	local v59 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = v50
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
				onButtonClick = function() -- line: 240
					-- upvalues: v46 (copy), v45 (copy), GetFFlagAddMorePhoneUpsellEvents (copy), v31 (copy)
					v46(not v45)

					if GetFFlagAddMorePhoneUpsellEvents then
						v31.onCountryCodeSelectorClick()
					end
				end,
				size = UDim2.new(0, v47, 0, Tokens.Size.Size_1200),
				font = Font,
				textSize = FontSize,
				forwardRef = v52,
				error = v58
			}),
			PhoneInputBox = React.createElement(TextField, {
				placeholder = "",
				required = true,
				LayoutOrder = 2,
				text = v31.phoneNumber,
				onChange = function(s3: string) -- line: 257
					-- upvalues: v31 (copy)
					v31.onPhoneNumberTextChange({
						Text = s3
					})
				end,
				width = UDim.new(1, -(v47 + Small)),
				error = v58,
				textInputType = if not v31.usePhoneNumberTextType then Enum.TextInputType.Number else Enum.TextInputType.Phone,
				onFocusGained = if not GetFFlagAddMorePhoneUpsellEvents() then nil else v31.onPhoneInputFocus
			})
		}),
		ErrorText = v58 and React.createElement("TextLabel", {
			TextTransparency = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Text = v31.errorMessage,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = Tokens.Color.System.Alert.Color3,
			Font = v33.Font.Body.Font,
			TextSize = BaseSize * v33.Font.CaptionSmall.RelativeSize,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	})
	local v60 = React.createElement(InteractiveAlert, {
		screenSize = v31.screenSize,
		buttonStackInfo = getButtonStackProps(v38.buttonKey, v31.onSetPhoneNumber, isDisabled, v38.extraButtonKey, v31.onExtraButtonClick),
		position = v31.isKeyboardShowing and UDim2.new(0.5, 0, 1, -v31.keyboardHeight) or UDim2.fromScale(0.5, 0.5),
		anchorPoint = v31.isKeyboardShowing and Vector2.new(0.5, 1) or nil,
		title = v38.titleKey,
		onAbsoluteSizeChanged = function(p4) -- line: 157
			-- upvalues: v49 (copy)
			v49(p4.AbsoluteSize.X)
		end,
		onCloseClicked = v31.onClose,
		middleContent = not FFlagInExperienceAddPhoneViewNewCopy and function() -- line: 360
			-- upvalues: React (copy), Tokens (copy), v59 (copy), v38 (copy), BaseSize (copy), RelativeSize (copy), v33 (copy)
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
					PhoneInput = v59,
					PrivacyText = React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v38.disclaimerKey,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v33.Theme.TextEmphasis.Color,
						TextTransparency = v33.Theme.TextEmphasis.Transparency,
						Font = v33.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				})
			})
		end or function() -- line: 301
			-- upvalues: React (copy), Tokens (copy), v38 (copy), BaseSize (copy), v33 (copy), v59 (copy), RelativeSize (copy)
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
						Text = v38.subtitleKey,
						TextSize = BaseSize,
						TextColor3 = v33.Theme.TextEmphasis.Color,
						TextTransparency = v33.Theme.TextEmphasis.Transparency,
						Font = v33.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}),
					PhoneInput = v59,
					PhonePrivacyText = React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v38.phonePrivacyDisclaimerKey,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v33.Theme.TextEmphasis.Color,
						TextTransparency = v33.Theme.TextEmphasis.Transparency,
						Font = v33.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}),
					PrivacyText = React.createElement("TextLabel", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v38.disclaimerKey,
						TextSize = BaseSize * RelativeSize,
						TextColor3 = v33.Theme.TextEmphasis.Color,
						TextTransparency = v33.Theme.TextEmphasis.Transparency,
						Font = v33.Font.Body.Font,
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
		[Roact.Ref] = v51
	}, {
		AddPhoneView = v60,
		CountryCodeSelectorFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0, v48 - 24, 0, 0),
			Position = UDim2.new(0, vector2.X - vector2_2.X, 0, vector2.Y + Size_1200 + Small - vector2_2.Y)
		}, {
			CountryCodeDropdown = React.createElement(CountryCodeDropdownContainer, {
				dropdownVisible = v45,
				position = UDim2.new(0, 0, 0, 0),
				maxHeight = u56,
				onCountryCodeSelected = function(p5) -- line: 419
					-- upvalues: v31 (copy), v46 (copy)
					v31.setCountryCode(p5)
					v46(false)
				end
			})
		})
	})
end

return InGameAddPhoneView
