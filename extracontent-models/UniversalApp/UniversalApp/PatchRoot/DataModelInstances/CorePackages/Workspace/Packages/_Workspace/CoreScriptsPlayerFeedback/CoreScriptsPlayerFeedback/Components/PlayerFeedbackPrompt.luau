local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local CoreScriptsPlayerFeedbackParent = CoreScriptsPlayerFeedback.Parent
local React = require(CoreScriptsPlayerFeedbackParent.React)
local UIBlox = require(CoreScriptsPlayerFeedbackParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local MouseIconOverrideService = require(CoreScriptsPlayerFeedbackParent.CoreScriptsCommon).MouseIconOverrideService
local constants = require(CoreScriptsPlayerFeedback.constants)
local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)
local useScreenSize = require(CoreScriptsPlayerFeedbackParent.CoreScriptsRoactCommon).useScreenSize
local useLastInputMethod = require(CoreScriptsPlayerFeedbackParent.FocusNavigationUtils).useLastInputMethod
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local TelemetryService = game:GetService("TelemetryService")
local useLocalization = require(CoreScriptsPlayerFeedbackParent.Localization).Hooks.useLocalization
local v19 = Images["component_assets/circle_21"]

return (React.memo(function(t1: {[any]: any}) -- line: 42
	-- upvalues: useScreenSize (copy), useStyle (copy), useLastInputMethod (copy), React (copy), useLocalization (copy), GuiService (copy), constants (copy), MouseIconOverrideService (copy), TelemetryService (copy), useEscapeDismiss (copy), ContextActionService (copy), ImageSetLabel (copy), v19 (copy), ButtonType (copy), InteractiveAlert (copy)
	local v21 = useScreenSize()
	local v22 = useStyle()
	local v23 = useLastInputMethod()
	local v24, v25 = React.useState(false)

	React.useEffect(function() -- line: 48
		-- upvalues: v24 (copy), v23 (copy), v25 (copy)
		if not v24 and (v23 == "Keyboard" or v23 == "Gamepad") then
			v25(true)
		end
	end, {
		v24,
		v23
	})

	local v26 = useLocalization({
		Title = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Title",
		Submit = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Submit",
		Submitting = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Submitting",
		Placeholder = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Placeholder",
		Intro = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Intro",
		Footer = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Footer"
	})
	local v27, v28 = React.useState("")
	local v29, v30 = React.useState(false)
	local v31 = React.useRef(nil)

	React.useEffect(function() -- line: 67
		-- upvalues: v24 (copy), v31 (copy), GuiService (copy)
		if not v24 then
			return
		end

		local current = v31.current

		if current then
			pcall(function() -- line: 74
				-- upvalues: GuiService (copy), current (copy)
				GuiService:Select(current)
			end)
		end
	end, { v24 })

	local MIN_FEEDBACK_LENGTH = constants.MIN_FEEDBACK_LENGTH
	local MAX_FEEDBACK_LENGTH = constants.MAX_FEEDBACK_LENGTH
	local DELAYED_INPUT_ANIM_SEC = constants.DELAYED_INPUT_ANIM_SEC

	React.useEffect(function() -- line: 84
		-- upvalues: MouseIconOverrideService (copy)
		MouseIconOverrideService.push("PlayerFeedbackPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)

		return function() -- line: 86
			-- upvalues: MouseIconOverrideService (copy)
			MouseIconOverrideService.pop("PlayerFeedbackPromptOverride")
		end
	end, {})

	local v35 = React.useCallback(function() -- line: 91
		-- upvalues: v27 (copy), MIN_FEEDBACK_LENGTH (copy), MAX_FEEDBACK_LENGTH (copy), v30 (copy), TelemetryService (copy), t1 (copy)
		if #v27 < MIN_FEEDBACK_LENGTH then
			return
		end

		if #v27 > MAX_FEEDBACK_LENGTH then
			return
		end

		v30(true)
		pcall(function() -- line: 99
			-- upvalues: TelemetryService (copy)
			TelemetryService:LogCounter({
				eventName = "FeedbackPrompt_Submitted",
				backends = { "RobloxTelemetryCounter" }
			}, {
				customFields = {}
			}, 1)
		end)
		pcall(function() -- line: 106
			-- upvalues: v27 (copy)
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionCompleted then
				SocialService:SignalFeedbackSubmissionCompleted(v27)
			end
		end)
		t1.closePrompt()
	end, { v27 })
	local v36 = React.useCallback(function() -- line: 115
		-- upvalues: TelemetryService (copy), t1 (copy)
		pcall(function() -- line: 116
			-- upvalues: TelemetryService (copy)
			TelemetryService:LogCounter({
				eventName = "FeedbackPrompt_Cancelled",
				backends = { "RobloxTelemetryCounter" }
			}, {
				customFields = {}
			}, 1)
		end)
		pcall(function() -- line: 123
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionPermissionDenied then
				SocialService:SignalFeedbackSubmissionPermissionDenied()
			end
		end)
		t1.closePrompt()
	end, {})

	useEscapeDismiss("FeedbackPromptCancel", v36)
	React.useEffect(function() -- line: 134
		-- upvalues: ContextActionService (copy), GuiService (copy), v35 (copy)
		ContextActionService:BindCoreActionAtPriority("FeedbackPromptDisableGameControls", function(_, _, p3) -- line: 137
			if p3 and p3.KeyCode == Enum.KeyCode.Escape then
				return Enum.ContextActionResult.Pass
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.Low.Value, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump)
		ContextActionService:BindCoreAction("FeedbackPromptSubmit", function(_, p5) -- line: 152
			-- upvalues: GuiService (copy), v35 (copy)
			if p5 == Enum.UserInputState.Begin then
				local SelectedCoreObject = GuiService.SelectedCoreObject

				if SelectedCoreObject and SelectedCoreObject:IsA("TextBox") then
					return Enum.ContextActionResult.Pass
				end

				v35()

				return Enum.ContextActionResult.Sink
			end

			return Enum.ContextActionResult.Pass
		end, false, Enum.KeyCode.ButtonA, Enum.KeyCode.Return)

		return function() -- line: 164
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("FeedbackPromptDisableGameControls")
			ContextActionService:UnbindCoreAction("FeedbackPromptSubmit")
		end
	end, {
		v35,
		v36
	})
	React.useEffect(function() -- line: 170
		-- upvalues: v31 (copy), GuiService (copy)
		local function trySelect() -- line: 171
			-- upvalues: v31 (copy), GuiService (copy)
			local current = v31.current

			if current then
				pcall(function() -- line: 174
					-- upvalues: GuiService (copy), current (copy)
					GuiService:Select(current)
				end)
			end
		end

		task.delay(0.05, trySelect)
		task.delay(0.1, trySelect)
		task.delay(0.15000000000000002, trySelect)
		task.delay(0.2, trySelect)
		task.delay(0.25, trySelect)

		local connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 182
			-- upvalues: GuiService (copy), v31 (copy)
			local SelectedCoreObject = GuiService.SelectedCoreObject

			if SelectedCoreObject == nil or SelectedCoreObject and not SelectedCoreObject.Parent then
				local current = v31.current

				if current then
					pcall(function() -- line: 174
						-- upvalues: GuiService (copy), current (copy)
						GuiService:Select(current)
					end)
				end
			end
		end)

		return function() -- line: 188
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local Title = v26.Title
	local v38 = v29 and v26.Submitting or v26.Submit
	local Placeholder = v26.Placeholder
	local v40 = MIN_FEEDBACK_LENGTH <= #v27 and MAX_FEEDBACK_LENGTH >= #v27
	local v41 = React.useCallback(function(p6) -- line: 199
		-- upvalues: v28 (copy)
		local p6Text = p6.Text

		v28(p6Text)
	end, {})
	local v42 = React.useCallback(function() -- line: 204
		-- upvalues: v22 (copy), v21 (copy), constants (copy), React (copy), v26 (copy), ImageSetLabel (copy), v19 (copy), v27 (copy), Placeholder (copy), v31 (copy), v41 (copy)
		local Body = v22.Font.Body
		local BaseSize = v22.Font.BaseSize
		local v53 = math.floor(Body.RelativeSize * BaseSize)
		local v54 = math.clamp(v21.Y - 320, constants.MIN_TEXTBOX_HEIGHT, constants.MAX_TEXTBOX_HEIGHT)
		local v55 = math.max(constants.MIN_TEXTBOX_HEIGHT, (math.min(constants.MAX_TEXTBOX_HEIGHT, v54)))

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.new(1, 0, 0, v55 + 16 + 24)
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			Intro = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 0,
				Selectable = false,
				Text = v26.Intro,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = v22.Theme.TextEmphasis.Color,
				TextTransparency = v22.Theme.TextEmphasis.Transparency,
				Font = Body.Font,
				TextSize = v53,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			TextBoxFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Selectable = false,
				Size = UDim2.new(1, 0, 0, v55)
			}, {
				InputBg = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Selectable = false,
					Size = UDim2.new(1, 0, 1, 0),
					Image = v19,
					ImageTransparency = v22.Theme.UIMuted.Transparency,
					ImageColor3 = v22.Theme.UIMuted.Color,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 12),
						PaddingBottom = UDim.new(0, 12),
						PaddingLeft = UDim.new(0, 12),
						PaddingRight = UDim.new(0, 12)
					}),
					TextBox = React.createElement("TextBox", {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Text = v27,
						PlaceholderText = Placeholder,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = v22.Theme.TextEmphasis.Color,
						TextTransparency = v22.Theme.TextEmphasis.Transparency,
						PlaceholderColor3 = v22.Theme.TextMuted.Color,
						Font = Body.Font,
						TextSize = v53,
						ClearTextOnFocus = false,
						MultiLine = true,
						OverlayNativeInput = true,
						ref = v31,
						[React.Change.Text] = v41,
						[React.Tag] = "data-testid=feedbackTextBox"
					})
				})
			})
		})
	end, {
		v22,
		v27,
		v41
	})
	local v43 = React.useMemo(function() -- line: 288
		-- upvalues: ButtonType (copy), v35 (copy), v38 (copy), t1 (copy), DELAYED_INPUT_ANIM_SEC (copy), v40 (copy), v29 (copy)
		return {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = v35,
					text = v38,
					isDelayedInput = t1.enableInputDelayed,
					enableInputDelayed = t1.enableInputDelayed,
					delayInputSeconds = DELAYED_INPUT_ANIM_SEC,
					isDisabled = not v40,
					isLoading = v29
				}
			}}
		}
	end, {
		v35,
		v38,
		t1.enableInputDelayed,
		v40,
		v29
	})
	local Footer = v26.Footer
	local v45 = React.useCallback(function() -- line: 309
		-- upvalues: Footer (copy), React (copy), v22 (copy)
		local v56 = Footer

		if type(v56) == "string" and string.find(v56, "Roblox Terms of Use", 1, true) then
			v56 = string.gsub(v56, "Roblox Terms of Use", "<u>Roblox Terms of Use</u>", 1)
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Pad = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12)
			}),
			Note = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				RichText = true,
				TextWrapped = true,
				LayoutOrder = 1,
				Selectable = false,
				Text = v56,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = math.floor(v22.Font.CaptionHeader.RelativeSize * v22.Font.BaseSize),
				Font = v22.Font.CaptionHeader.Font,
				TextColor3 = v22.Theme.TextMuted.Color,
				TextTransparency = v22.Theme.TextMuted.Transparency,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		})
	end, {
		v22,
		Footer
	})

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = true,
		title = Title,
		onCloseClicked = v36,
		buttonStackInfo = v43,
		middleContent = v42,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v21,
		defaultChildRef = if not v24 then nil else v31,
		isRoactGamepadEnabled = v24,
		footerContent = v45
	})
end))
