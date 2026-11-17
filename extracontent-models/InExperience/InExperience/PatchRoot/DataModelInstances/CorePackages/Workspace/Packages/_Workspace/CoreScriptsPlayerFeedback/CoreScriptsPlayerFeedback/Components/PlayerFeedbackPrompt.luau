local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService

local constants = require(CoreScriptsPlayerFeedback.constants)
local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local useScreenSize = CoreScriptsRoactCommon.useScreenSize
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMethod = FocusNavigationUtils.useLastInputMethod

local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local TelemetryService = game:GetService("TelemetryService")

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local component_assetscircle_21 = Images["component_assets/circle_21"]

return (React.memo(function(p)
	local screenSize = useScreenSize()
	local v = useStyle()
	local v2 = useLastInputMethod()
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not state and (v2 == "Keyboard" or v2 == "Gamepad") then
			setState(true)
		end
	end, { state, v2 })

	local v3 = useLocalization({
		Title = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Title",
		Submit = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Submit",
		Submitting = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Submitting",
		Placeholder = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Placeholder",
		Intro = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Intro",
		Footer = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Footer"
	})

	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if not state then
			return
		end

		local current = ref.current

		if current then
			pcall(function()
				GuiService:Select(current)
			end)
		end
	end, { state })

	local MIN_FEEDBACK_LENGTH = constants.MIN_FEEDBACK_LENGTH
	local MAX_FEEDBACK_LENGTH = constants.MAX_FEEDBACK_LENGTH
	local DELAYED_INPUT_ANIM_SEC = constants.DELAYED_INPUT_ANIM_SEC

	React.useEffect(function()
		MouseIconOverrideService.push("PlayerFeedbackPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)
		return function()
			MouseIconOverrideService.pop("PlayerFeedbackPromptOverride")
		end
	end, {})

	local onActivated = React.useCallback(function()
		if #state2 < MIN_FEEDBACK_LENGTH or MAX_FEEDBACK_LENGTH < #state2 then
			return
		end

		setState3(true)
		pcall(function()
			TelemetryService:LogCounter({
				eventName = "FeedbackPrompt_Submitted",
				backends = { "RobloxTelemetryCounter" }
			}, { customFields = {} }, 1)
		end)
		pcall(function()
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionCompleted then
				SocialService:SignalFeedbackSubmissionCompleted(state2)
			end
		end)
		p.closePrompt()
	end, { state2 })

	local onCloseClicked = React.useCallback(function()
		pcall(function()
			TelemetryService:LogCounter({
				eventName = "FeedbackPrompt_Cancelled",
				backends = { "RobloxTelemetryCounter" }
			}, { customFields = {} }, 1)
		end)
		pcall(function()
			local SocialService = game:GetService("SocialService")

			if SocialService.SignalFeedbackSubmissionPermissionDenied then
				SocialService:SignalFeedbackSubmissionPermissionDenied()
			end
		end)
		p.closePrompt()
	end, {})

	useEscapeDismiss("FeedbackPromptCancel", onCloseClicked)

	React.useEffect(function()
		ContextActionService:BindCoreActionAtPriority("FeedbackPromptDisableGameControls", function(_, _, p2)
			if p2 and p2.KeyCode == Enum.KeyCode.Escape then
				return Enum.ContextActionResult.Pass
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.Low.Value, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump)

		ContextActionService:BindCoreAction("FeedbackPromptSubmit", function(_, p2)
			if p2 ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end

			local selectedCoreObject = GuiService.SelectedCoreObject

			if selectedCoreObject and selectedCoreObject:IsA("TextBox") then
				return Enum.ContextActionResult.Pass
			end

			onActivated()
			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.ButtonA, Enum.KeyCode.Return)

		return function()
			ContextActionService:UnbindCoreAction("FeedbackPromptDisableGameControls")
			ContextActionService:UnbindCoreAction("FeedbackPromptSubmit")
		end
	end, { onActivated, onCloseClicked })

	React.useEffect(function()
		local function trySelect()
			local current = ref.current

			if current then
				pcall(function()
					GuiService:Select(current)
				end)
			end
		end

		task.delay(0.05, trySelect)
		task.delay(0.1, trySelect)
		task.delay(0.15000000000000002, trySelect)
		task.delay(0.2, trySelect)
		task.delay(0.25, trySelect)

		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			local selectedCoreObject = GuiService.SelectedCoreObject
			local current = (selectedCoreObject == nil or selectedCoreObject and not selectedCoreObject.Parent)
				and ref.current

			if current then
				pcall(function()
					GuiService:Select(current)
				end)
			end
		end)
		return function()
			selectedCoreObjectChangedConnection:Disconnect()
		end
	end, {})

	local title = v3.Title
	local submitting = state3 and v3.Submitting or v3.Submit
	local placeholder = v3.Placeholder
	local v4

	if MIN_FEEDBACK_LENGTH <= #state2 then
		v4 = #state2 <= MAX_FEEDBACK_LENGTH
	else
		v4 = false
	end

	local v5 = React.useCallback(function(p2)
		setState2(p2.Text)
	end, {})

	local middleContent = React.useCallback(function()
		local body = v.Font.Body
		local baseSize = v.Font.BaseSize
		local textSize = math.floor(body.RelativeSize * baseSize)

		local v6 = math.clamp(screenSize.Y - 320, constants.MIN_TEXTBOX_HEIGHT, constants.MAX_TEXTBOX_HEIGHT)

		local v7 = math.max(constants.MIN_TEXTBOX_HEIGHT, (math.min(constants.MAX_TEXTBOX_HEIGHT, v6)))

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v7 + 16 + 24),
			Selectable = false
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			Intro = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = v3.Intro,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = v.Theme.TextEmphasis.Color,
				TextTransparency = v.Theme.TextEmphasis.Transparency,
				FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
				TextSize = textSize,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 0,
				Selectable = false
			}),
			TextBoxFrame = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v7),
					LayoutOrder = 1,
					Selectable = false
				},
				{
					InputBg = React.createElement(ImageSetLabel, {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Image = component_assetscircle_21,
						ImageTransparency = v.Theme.UIMuted.Transparency,
						ImageColor3 = v.Theme.UIMuted.Color,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9),
						Selectable = false
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
							Text = state2,
							PlaceholderText = placeholder,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							TextColor3 = v.Theme.TextEmphasis.Color,
							TextTransparency = v.Theme.TextEmphasis.Transparency,
							PlaceholderColor3 = v.Theme.TextMuted.Color,
							FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
							TextSize = textSize,
							ClearTextOnFocus = false,
							MultiLine = true,
							OverlayNativeInput = true,
							ref = ref,
							[React.Change.Text] = v5,
							[React.Tag] = "data-testid=feedbackTextBox"
						})
					})
				}
			)
		})
	end, { v, state2, v5 })

	local buttonStackInfo = React.useMemo(function()
		return {
			buttons = {
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						onActivated = onActivated,
						text = submitting,
						isDelayedInput = p.enableInputDelayed,
						enableInputDelayed = p.enableInputDelayed,
						delayInputSeconds = DELAYED_INPUT_ANIM_SEC,
						isDisabled = not v4,
						isLoading = state3
					}
				}
			}
		}
	end, { onActivated, submitting, p.enableInputDelayed, v4, state3 })

	local footer = v3.Footer

	local footerContent = React.useCallback(function()
		local text = footer

		if type(text) == "string" and string.find(text, "Roblox Terms of Use", 1, true) then
			text = string.gsub(text, "Roblox Terms of Use", "<u>Roblox Terms of Use</u>", 1)
		end

		return React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				Pad = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 12) }),
				Note = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = text,
					RichText = true,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = math.floor(v.Font.CaptionHeader.RelativeSize * v.Font.BaseSize),
					FontFace = normalizeFontFace(v.Tokens.Typography.CaptionLarge.Font),
					TextColor3 = v.Theme.TextMuted.Color,
					TextTransparency = v.Theme.TextMuted.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 1,
					Selectable = false
				})
			}
		)
	end, { v, footer })

	local createElement = React.createElement
	local v6 = {
		title = title,
		onCloseClicked = onCloseClicked,
		buttonStackInfo = buttonStackInfo,
		isMiddleContentFocusable = true,
		middleContent = middleContent,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		defaultChildRef = 0,
		isRoactGamepadEnabled = 0,
		footerContent = 0
	}
	local defaultChildRef

	if state then
		defaultChildRef = ref
	end

	v6.defaultChildRef = defaultChildRef
	v6.isRoactGamepadEnabled = state
	v6.footerContent = footerContent
	return createElement(InteractiveAlert, v6)
end))
