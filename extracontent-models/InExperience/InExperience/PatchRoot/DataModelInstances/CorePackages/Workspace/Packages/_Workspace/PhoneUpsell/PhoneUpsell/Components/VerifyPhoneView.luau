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

local function VerifyPhoneView(t1: {[any]: any}) -- line: 43
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), ButtonType (copy), GetFFlagDisableVerifyPhoneViewOnSuccess (copy), getPartialPageModalMiddleContentWidth (copy), PartialPageModal (copy), TextInputBoxWithBorder (copy), LinkButton (copy)
	local v15 = useStyle()
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

	local v17 = useLocalization(t2)
	local v18, v19 = React.useState(false)
	local v20, v21 = React.useState(0)

	local function getButtonStackProps(s1: string, s2: string, n1: number, p1: ((...any) -> ...any), s3: string?, p2: ((...any) -> ...any)?) -- line: 63
		-- upvalues: v19 (copy), v21 (copy), v18 (copy), v20 (copy), ButtonType (copy), GetFFlagDisableVerifyPhoneViewOnSuccess (copy), t1 (copy)
		local function handleButtonClick() -- line: 71
			-- upvalues: p1 (copy), v19 (copy), v21 (copy), n1 (copy)
			p1()
			v19(true)
			v21(n1)

			local timestamp = tick()

			local function countDown() -- line: 77
				-- upvalues: timestamp (copy), n1 (copy), v21 (copy), countDown (copy), v19 (copy)
				local v37 = tick() - timestamp
				local v38 = n1 - v37

				if v38 > 0 then
					v21((math.round(v38)))
					task.delay(1, countDown)

					return
				end

				v21(0)
				v19(false)
			end

			countDown()
		end
		local function getButtonText() -- line: 92
			-- upvalues: v18 (copy), s2 (copy), v20 (copy), s1 (copy)
			if v18 then
				return s2 .. " (" .. v20 .. ")"
			end

			return s1
		end

		local t3 = {{
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = handleButtonClick,
				text = if not v18 then s1 else s2 .. " (" .. v20 .. ")",
				isDisabled = v18 or GetFFlagDisableVerifyPhoneViewOnSuccess() and t1.isDisabled
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
	local function getBodyText(s4: string) -- line: 131
		-- upvalues: t1 (copy)
		return s4:gsub("{phoneNumber}", "+" .. t1.prefix .. t1.phoneNumber)
	end

	local v24 = getPartialPageModalMiddleContentWidth(t1.screenSize.X)

	return React.createElement(PartialPageModal, {
		title = v17.titleKey,
		screenSize = t1.screenSize,
		buttonStackProps = getButtonStackProps(v17.buttonKey, v17.buttonDisabledKey, 10, t1.onResendPhoneCode, v17.extraButtonKey, t1.onExtraButtonClick),
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
				Text = v17.descriptionKey:gsub("{phoneNumber}", "+" .. t1.prefix .. t1.phoneNumber),
				TextSize = v15.Font.BaseSize,
				TextColor3 = v15.Theme.TextDefault.Color,
				TextTransparency = v15.Theme.TextDefault.Transparency,
				Font = v15.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v24, 0, 0)
			}),
			TextBox = React.createElement(TextInputBoxWithBorder, {
				textInputHeight = 36,
				layoutOrder = 2,
				maxLength = 6,
				text = t1.code,
				textInputType = t1.useOTPInputType and Enum.TextInputType.OneTimePassword or Enum.TextInputType.Number,
				placeholderText = v17.placeholderKey,
				errorText = t1.errorMessage,
				onChangeTextCallback = t1.onCodeTextChange,
				Size = UDim2.new(1, 0, 0, 0),
				onFocused = t1.onCodeInputFocus
			}),
			ChangePhoneButton = React.createElement(LinkButton, {
				layoutOrder = 3,
				fontStyle = "CaptionBody",
				minPaddingX = 0,
				minPaddingY = 0,
				text = v17.changePhoneNumberKey,
				onActivated = t1.returnToAddPhone
			})
		})
	})
end

return VerifyPhoneView
