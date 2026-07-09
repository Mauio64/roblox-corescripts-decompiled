local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local TextField = UIBlox.App.Input.TextField
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local GetFFlagAddMorePhoneUpsellEvents = require(Parent.SharedFlags).GetFFlagAddMorePhoneUpsellEvents

local function getButtonStackProps(s1: string, p1: ((...any) -> ...any), b1: boolean, s2: string?, p2: ((...any) -> ...any)?) -- line: 35
	-- upvalues: ButtonType (copy)
	local t1 = {{
		buttonType = ButtonType.Secondary,
		props = {
			onActivated = p1,
			text = s1,
			isDisabled = b1
		}
	}}

	if p2 and (s2 and s2 ~= "") then
		table.insert(t1, 1, {
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
		forcedFillDirection = Enum.FillDirection.Horizontal,
		buttons = t1
	}
end
local function InGameVerifyPhoneView(t2: {[any]: any}) -- line: 72
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), InteractiveAlert (copy), getButtonStackProps (copy), TextField (copy), GetFFlagAddMorePhoneUpsellEvents (copy)
	local v19 = useStyle()
	local Tokens = v19.Tokens
	local t3 = {
		titleKey = "Feature.VerificationUpsell.Heading.VerifyYourPhone",
		verificationCodeKey = "Feature.VerificationUpsell.Heading.VerificationCode",
		placeholderKey = "Feature.VerificationUpsell.Label.SixDigitCode",
		descriptionKey = "Feature.VerificationUpsell.Label.EnterCode",
		buttonKey = "Feature.VerificationUpsell.Action.ResendCode",
		buttonDisabledKey = "Feature.VerificationUpsell.Action.CodeResent",
		changePhoneNumberKey = "Feature.VerificationUpsell.Action.ChangePhoneNumber",
		editPhoneDescriptionKey = "Feature.VerificationUpsell.Action.EditPhoneNumber"
	}

	if t2.extraButtonKey and t2.extraButtonKey ~= "" then
		t3.extraButtonKey = t2.extraButtonKey
	end

	local v22 = useLocalization(t3)
	local v23, v24 = React.useState(0)
	local v25 = v23 ~= 0

	local function getBodyText(s3: string) -- line: 97
		-- upvalues: t2 (copy)
		return s3:gsub("{phoneNumber}", "+" .. t2.prefix .. t2.phoneNumber)
	end
	local function handleResendButtonClick() -- line: 101
		-- upvalues: t2 (copy), v24 (copy)
		t2.onResendPhoneCode()
		v24(10)

		local timestamp = tick()

		local function countDown() -- line: 106
			-- upvalues: timestamp (copy), v24 (copy), countDown (copy)
			local v34 = 10 - (tick() - timestamp)

			if v34 > 0 then
				v24((math.ceil(v34)))
				task.delay(1, countDown)

				return
			end

			v24(0)
		end

		local v33 = 10 - (tick() - timestamp)

		if v33 > 0 then
			v24((math.ceil(v33)))
			task.delay(1, countDown)

			return
		end

		v24(0)
	end

	local v28 = if not v25 then v22.buttonKey else v22.buttonDisabledKey .. " (" .. v23 .. ")"
	local v29 = t2.errorMessage and t2.errorMessage ~= ""

	return React.createElement(InteractiveAlert, {
		title = v22.titleKey,
		screenSize = t2.screenSize,
		buttonStackInfo = getButtonStackProps(v28, handleResendButtonClick, v25, v22.editPhoneDescriptionKey, t2.onExtraButtonClick),
		onCloseClicked = t2.onClose,
		position = t2.isKeyboardShowing and UDim2.new(0.5, 0, 1, -t2.keyboardHeight) or nil,
		anchorPoint = t2.isKeyboardShowing and Vector2.new(0.5, 1) or nil,
		middleContent = function() -- line: 139
			-- upvalues: React (copy), Tokens (copy), TextField (copy), t2 (copy), v29 (copy), GetFFlagAddMorePhoneUpsellEvents (copy), v19 (copy), v22 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, Tokens.Size.Size_200)
				}),
				React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						Padding = UDim.new(0, Tokens.Size.Size_200)
					}),
					TextBox = React.createElement(TextField, {
						placeholder = "",
						required = true,
						LayoutOrder = 1,
						text = t2.code,
						onChange = function(p3) -- line: 165
							-- upvalues: t2 (copy)
							t2.onCodeTextChange({
								Text = p3
							})
						end,
						width = UDim.new(1, 0),
						error = v29,
						textInputType = if not t2.useOTPInputType then Enum.TextInputType.Number else Enum.TextInputType.OneTimePassword,
						onFocusGained = if not GetFFlagAddMorePhoneUpsellEvents() then nil else t2.onCodeInputFocus
					}),
					ErrorText = v29 and React.createElement("TextLabel", {
						TextTransparency = 0,
						TextWrapped = true,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Text = t2.errorMessage,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Tokens.Color.System.Alert.Color3,
						Font = v19.Font.Body.Font,
						TextSize = v19.Font.BaseSize * v19.Font.CaptionSmall.RelativeSize,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				}),
				BodyText = React.createElement("TextLabel", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Text = v22.descriptionKey:gsub("{phoneNumber}", "+" .. t2.prefix .. t2.phoneNumber),
					TextSize = v19.Font.BaseSize * v19.Font.CaptionHeader.RelativeSize,
					TextColor3 = v19.Theme.TextDefault.Color,
					TextTransparency = v19.Theme.TextDefault.Transparency,
					Font = v19.Font.Body.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				})
			})
		end
	})
end

return InGameVerifyPhoneView
