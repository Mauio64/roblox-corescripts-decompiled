local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local TextInputBoxWithBorder = require(PhoneUpsellParent.AuthCommon).Components.TextInputBoxWithBorder
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local LinkButton = UIBlox.App.Button.LinkButton
local GetFFlagDisableVerifyPhoneViewOnSuccess = require(PhoneUpsell.Flags.GetFFlagDisableVerifyPhoneViewOnSuccess)
local FFlagPhoneUpsellEnforceCodeInputLimit = require(PhoneUpsellParent.SharedFlags).FFlagPhoneUpsellEnforceCodeInputLimit

local function VerifyPhoneView(t1: {[any]: any}) -- line: 44
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), ButtonType (copy), GetFFlagDisableVerifyPhoneViewOnSuccess (copy), getPartialPageModalMiddleContentWidth (copy), PartialPageModal (copy), TextInputBoxWithBorder (copy), FFlagPhoneUpsellEnforceCodeInputLimit (copy), LinkButton (copy)
	local v16 = useStyle()
	local t2 = {
		titleKey = "Feature.VerificationUpsell.Heading.VerifyYourPhone",
		verificationCodeKey = "Feature.VerificationUpsell.Heading.VerificationCode",
		placeholderKey = "Feature.VerificationUpsell.Label.SixDigitCode",
		descriptionKey = "Feature.VerificationUpsell.Label.EnterCode",
		buttonKey = "Feature.VerificationUpsell.Action.ResendCode",
		buttonDisabledKey = "Feature.VerificationUpsell.Action.CodeResent",
		changePhoneNumberKey = "Feature.VerificationUpsell.Action.ChangePhoneNumber"
	}

	if t1.extraButtonKey and t1.extraButtonKey ~= "" then
		t2.extraButtonKey = t1.extraButtonKey
	end

	local v18 = useLocalization(t2)
	local v19, v20 = React.useState(false)
	local v21, v22 = React.useState(0)

	local function getButtonStackProps(s1: string, s2: string, n1: number, p1: ((...any) -> ...any), s3: string?, p2: ((...any) -> ...any)?) -- line: 64
		-- upvalues: v20 (copy), v22 (copy), v19 (copy), v21 (copy), ButtonType (copy), GetFFlagDisableVerifyPhoneViewOnSuccess (copy), t1 (copy)
		local function handleButtonClick() -- line: 72
			-- upvalues: p1 (copy), v20 (copy), v22 (copy), n1 (copy)
			p1()
			v20(true)
			v22(n1)

			local timestamp = tick()

			local function countDown() -- line: 78
				-- upvalues: timestamp (copy), n1 (copy), v22 (copy), countDown (copy), v20 (copy)
				local v38 = tick() - timestamp
				local v39 = n1 - v38

				if v39 > 0 then
					v22((math.round(v39)))
					task.delay(1, countDown)

					return
				end

				v22(0)
				v20(false)
			end

			countDown()
		end
		local function getButtonText() -- line: 93
			-- upvalues: v19 (copy), s2 (copy), v21 (copy), s1 (copy)
			if v19 then
				return s2 .. " (" .. v21 .. ")"
			end

			return s1
		end

		local t3 = {{
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = handleButtonClick,
				text = if not v19 then s1 else s2 .. " (" .. v21 .. ")",
				isDisabled = v19 or GetFFlagDisableVerifyPhoneViewOnSuccess() and t1.isDisabled
			}
		}}

		if p2 and (s3 and s3 ~= "") then
			table.insert(t3, 1, {
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = p2,
					text = s3,
					isDisabled = GetFFlagDisableVerifyPhoneViewOnSuccess() and t1.isDisabled
				}
			})
		end

		return {
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = t3
		}
	end
	local function getBodyText(s4: string) -- line: 132
		-- upvalues: t1 (copy)
		return s4:gsub("{phoneNumber}", "+" .. t1.prefix .. t1.phoneNumber)
	end

	local v25 = getPartialPageModalMiddleContentWidth(t1.screenSize.X)

	return React.createElement(PartialPageModal, {
		title = v18.titleKey,
		screenSize = t1.screenSize,
		buttonStackProps = getButtonStackProps(v18.buttonKey, v18.buttonDisabledKey, 10, t1.onResendPhoneCode, v18.extraButtonKey, t1.onExtraButtonClick),
		onCloseClicked = t1.onClose,
		position = t1.isKeyboardShowing and UDim2.new(0.5, 0, 1, -t1.keyboardHeight) or nil,
		anchorPoint = t1.isKeyboardShowing and Vector2.new(0.5, 1) or nil
	}, {
		Middle = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 12)
			}),
			BodyText = React.createElement("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = v18.descriptionKey:gsub("{phoneNumber}", "+" .. t1.prefix .. t1.phoneNumber),
				TextSize = v16.Font.BaseSize,
				TextColor3 = v16.Theme.TextDefault.Color,
				TextTransparency = v16.Theme.TextDefault.Transparency,
				Font = v16.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v25, 0, 0)
			}),
			TextBox = React.createElement(TextInputBoxWithBorder, {
				textInputHeight = 36,
				layoutOrder = 2,
				text = t1.code,
				textInputType = t1.useOTPInputType and Enum.TextInputType.OneTimePassword or Enum.TextInputType.Number,
				placeholderText = v18.placeholderKey,
				errorText = t1.errorMessage,
				onChangeTextCallback = t1.onCodeTextChange,
				Size = UDim2.new(1, 0, 0, 0),
				onFocused = t1.onCodeInputFocus,
				maxLength = if not FFlagPhoneUpsellEnforceCodeInputLimit then nil else 6
			}),
			ChangePhoneButton = React.createElement(LinkButton, {
				layoutOrder = 3,
				fontStyle = "CaptionBody",
				minPaddingX = 0,
				minPaddingY = 0,
				text = v18.changePhoneNumberKey,
				onActivated = t1.returnToAddPhone
			})
		})
	})
end

return VerifyPhoneView
