local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Checkbox = dependencies.Foundation.Checkbox
local useStyle = UIBlox.Core.Style.useStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local LinkButton = UIBlox.App.Button.LinkButton
local debounce = require(ParentParent.Utils.debounce)
local useLocalization = dependencies.Localization.Hooks.useLocalization
local useDesignTokens = dependencies.Style.useDesignTokens
local useState = React.useState
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)
local otpLoginConstants = require(ParentParent.Common.otpLoginConstants)
local InputField = require(script.Parent.InputField)
local v19 = game:DefineFastFlag("EnableKoreaKISAComplianceModularized", false)

local function EnterCodeView(t1: {[any]: any}) -- line: 52
	-- upvalues: useStyle (copy), useDesignTokens (copy), getPartialPageModalMiddleContentWidth (copy), React (copy), otpLoginConstants (copy), useLocalization (copy), useState (copy), ButtonType (copy), debounce (copy), AnalyticsEvents (copy), EventConstants (copy), LinkButton (copy), v19 (copy), PartialPageModal (copy), Checkbox (copy), InputField (copy)
	local v22 = useStyle()
	local v23 = useDesignTokens()
	local v24 = getPartialPageModalMiddleContentWidth(t1.screenSize.X)
	local v25, v26 = React.useState(true)
	local v27, v28 = React.useState(otpLoginConstants.DEFAULT_TIMER_COOLDOWN)
	local v29 = useLocalization({
		placeholderKey = "Authentication.OneTimePasscode.Label.SixDigitCode",
		buttonKey = "Authentication.OneTimePasscode.Action.Resend",
		buttonDisabledKey = "Authentication.OneTimePasscode.Label.CodeSent",
		footerDescriptionKey = "Authentication.OneTimePasscode.Description.DidntReceiveCode",
		changeEmailKey = "Authentication.OneTimePasscode.Action.ChangeEmailV2",
		helpButtonKey = "Authentication.OneTimePasscode.Action.GetHelp",
		complianceCheckboxMessageKey = t1.complianceCheckboxMessageKey
	})
	local v30, v31 = useState("")
	local v32, v33 = useState(false)

	local function handleComplianceBoxClick(b1: boolean) -- line: 71
		-- upvalues: v33 (copy)
		v33(b1)
	end
	local function countDown(n1: number, n2: number) -- line: 75
		-- upvalues: v28 (copy), countDown (copy), v26 (copy)
		local v44 = n2 - (tick() - n1)

		if v44 > 0 then
			v28((math.round(v44)))
			task.delay(1, function() -- line: 81
				-- upvalues: countDown (copy), n1 (copy), n2 (copy)
				countDown(n1, n2)
			end)

			return
		end

		v28(0)
		v26(false)
	end
	local function getButtonStackProps(s1: string, s2: string, n3: number, p1: ((...any) -> ...any)) -- line: 90
		-- upvalues: v26 (copy), v28 (copy), countDown (copy), v25 (copy), v27 (copy), ButtonType (copy), t1 (copy), v23 (copy)
		local function handleButtonClick() -- line: 96
			-- upvalues: p1 (copy), v26 (copy), v28 (copy), n3 (copy), countDown (copy)
			p1()
			v26(true)
			v28(n3)

			local timestamp = tick()

			countDown(timestamp, n3)
		end
		local function getButtonText() -- line: 104
			-- upvalues: v25 (copy), s2 (copy), v27 (copy), s1 (copy)
			if v25 then
				return s2 .. " (" .. v27 .. ")"
			end

			return s1
		end

		local t2 = {{
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = handleButtonClick,
				text = if not v25 then s1 else s2 .. " (" .. v27 .. ")",
				isDisabled = v25 or t1.isDisabled
			}
		}}

		return {
			buttonHeight = v23.Size.Size_1200,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = t2
		}
	end

	local v37 = React.useCallback(function(s3: string) -- line: 130
		-- upvalues: t1 (copy)
		return s3:gsub("{email}", t1.email)
	end, { t1.email })
	local v38 = React.useCallback(debounce(function(p2) -- line: 135
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), otpLoginConstants (copy), v31 (copy)
		AnalyticsEvents.sendFormInteractionEvent(EventConstants.ctx.enterOtp, t1.origin, EventConstants.field.code)

		if p2.Text then
			p2.Text = string.sub(p2.Text:gsub("%D", ""), 1, otpLoginConstants.DEFAULT_CODE_LENGTH)
			v31(p2.Text)
			t1.clearErrorMessage()
		end
	end, 0.5), { v31 })

	local function footer() -- line: 148
		-- upvalues: React (copy), v23 (copy), v29 (copy), v22 (copy), LinkButton (copy), t1 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v23.Size.Size_400)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v23.Size.Size_200)
			}),
			FooterText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = v29.footerDescriptionKey,
				TextSize = v23.FontSize.FontSize_400,
				TextColor3 = v22.Theme.TextDefault.Color,
				TextTransparency = v22.Theme.TextDefault.Transparency,
				Font = v22.Font.Body.Font
			}),
			LinkFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				LinkListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal
				}),
				ChangeEmailButton = React.createElement(LinkButton, {
					layoutOrder = 6,
					text = v29.changeEmailKey,
					onActivated = t1.returnToEnterEmail,
					position = UDim2.fromScale(0.25, 0)
				}),
				Hyphen = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = "-",
					LayoutOrder = 7,
					TextSize = v23.FontSize.FontSize_400,
					TextColor3 = v22.Theme.TextDefault.Color,
					TextTransparency = v22.Theme.TextDefault.Transparency,
					Font = v22.Font.Footer.Font
				}),
				HelpButton = React.createElement(LinkButton, {
					layoutOrder = 8,
					text = v29.helpButtonKey,
					onActivated = t1.navigateToHelp,
					position = UDim2.fromScale(0.75, 0)
				})
			})
		})
	end
	local function shouldShowComplianceCheckbox() -- line: 210
		-- upvalues: v19 (copy), t1 (copy)
		return v19 and (t1.complianceCheckboxMessageKey and t1.complianceCheckboxMessageKey ~= "")
	end

	React.useEffect(function() -- line: 216
		-- upvalues: countDown (copy), otpLoginConstants (copy), AnalyticsEvents (copy), EventConstants (copy), t1 (copy)
		countDown(tick(), otpLoginConstants.DEFAULT_TIMER_COOLDOWN)
		AnalyticsEvents.sendPageLoadEvent(EventConstants.ctx.enterOtp, t1.origin)
	end, {})
	React.useEffect(function() -- line: 223
		-- upvalues: v30 (copy), otpLoginConstants (copy), t1 (copy), v32 (copy)
		if string.len(v30) == otpLoginConstants.DEFAULT_CODE_LENGTH then
			if t1.complianceCheckboxMessageKey then
				if v32 then
					t1.onSubmitCode(v30)

					return
				end
			else
				t1.onSubmitCode(v30)
			end
		end
	end, {
		v30,
		(tostring(v32))
	})

	return React.createElement(PartialPageModal, {
		title = t1.enterCodeTitle,
		screenSize = t1.screenSize,
		buttonStackProps = getButtonStackProps(v29.buttonKey, v29.buttonDisabledKey, otpLoginConstants.DEFAULT_TIMER_COOLDOWN, t1.onResendCode),
		footerContent = footer,
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
				PaddingTop = UDim.new(0, v23.Size.Size_600),
				PaddingBottom = UDim.new(0, v23.Size.Size_600)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v23.Size.Size_300)
			}),
			BodyText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 1,
				Text = v37(t1.enterCodeDescription),
				TextSize = v22.Font.BaseSize,
				TextColor3 = v22.Theme.TextDefault.Color,
				TextTransparency = v22.Theme.TextDefault.Transparency,
				Font = v22.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v24, 0, 0)
			}),
			ComplianceCheckboxContainer = v19 and (t1.complianceCheckboxMessageKey and t1.complianceCheckboxMessageKey ~= "") and React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v24, 0, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Checkbox = React.createElement(Checkbox, {
					label = "",
					LayoutOrder = 2,
					isChecked = v32,
					onActivated = function() -- line: 295
						-- upvalues: v32 (copy), v33 (copy)
						local v54 = v32

						v33(not v54)
					end
				}),
				CheckboxBodyText = React.createElement("TextButton", {
					BackgroundTransparency = 1,
					Text = v29.complianceCheckboxMessageKey,
					TextSize = v22.Font.BaseSize,
					TextColor3 = v22.Theme.TextDefault.Color,
					TextTransparency = v22.Theme.TextDefault.Transparency,
					Font = v22.Font.Body.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Size = UDim2.new(0, v24 * 0.9, 0, 0),
					LayoutOrder = 3,
					[React.Event.Activated] = function() -- line: 313
						-- upvalues: v32 (copy), v33 (copy)
						local v55 = v32

						v33(not v55)
					end
				})
			}),
			CodeInput = React.createElement(InputField, {
				LayoutOrder = 3,
				text = v30,
				textInputType = Enum.TextInputType.Number,
				disabled = t1.isDisabled,
				onChange = v38,
				errorMessage = t1.errorMessage,
				placeholder = v29.placeholderKey
			})
		})
	})
end

return EnterCodeView
