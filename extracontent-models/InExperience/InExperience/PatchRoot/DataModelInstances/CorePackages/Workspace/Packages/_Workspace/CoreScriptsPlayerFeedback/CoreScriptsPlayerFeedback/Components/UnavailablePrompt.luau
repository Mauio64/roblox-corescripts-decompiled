local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local useScreenSize = CoreScriptsRoactCommon.useScreenSize
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMethod = FocusNavigationUtils.useLastInputMethod

local GuiService = game:GetService("GuiService")

local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

return (React.memo(function(p)
	local screenSize = useScreenSize()
	local v = useStyle()
	local ref = React.useRef(nil)

	local v2 = useLastInputMethod()
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not state and (v2 == "Keyboard" or v2 == "Gamepad") then
			setState(true)
		end
	end, { state, v2 })

	local v3 = useLocalization({
		Title = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Title",
		HeaderUnder13 = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Header.Under13",
		HintUnder13 = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Hint.Under13",
		HeaderRateLimited = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Header.RateLimited",
		HintRateLimited = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Hint.RateLimited",
		HeaderDefault = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Header.Default",
		HintDefault = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Hint.Default",
		OkayButton = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.OkayButton"
	})

	local _title = v3.Title
	local text, text2

	if p.reason == "Under13" then
		text = v3.HeaderUnder13
		text2 = v3.HintUnder13
	elseif p.reason == "RateLimited" then
		text = v3.HeaderRateLimited
		text2 = v3.HintRateLimited
	else
		text = v3.HeaderDefault
		text2 = v3.HintDefault
	end

	local middleContent = React.useCallback(function()
		local body = v.Font.Body
		local header2 = v.Font.Header2 or v.Font.Body
		local baseSize = v.Font.BaseSize
		local textSize = math.floor(header2.RelativeSize * baseSize)
		local textSize2 = math.floor(body.RelativeSize * baseSize)
		return React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left
				}),
				Header = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = text,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = v.Theme.TextEmphasis.Color,
					TextTransparency = v.Theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(v.Tokens.Typography.TitleLarge.Font),
					TextSize = textSize,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 1
				}),
				Hint = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = text2,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = v.Theme.TextMuted.Color,
					TextTransparency = v.Theme.TextMuted.Transparency,
					FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
					TextSize = textSize2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 2
				})
			}
		)
	end, { v, text, text2 })

	local v4 = React.useCallback(function()
		p.closePrompt()
	end, { p.closePrompt })

	useEscapeDismiss("UnavailablePromptCancel", v4)

	local buttonRef = React.useCallback(function(current)
		ref.current = current

		if state and current then
			pcall(function()
				GuiService:Select(current)
			end)
		end
	end, { state })

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

	local buttonStackInfo = React.useMemo(function()
		return {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v4,
						text = v3.OkayButton,
						isDelayedInput = false,
						enableInputDelayed = false,
						delayInputSeconds = 1,
						isDisabled = false,
						buttonRef = buttonRef
					},
					isDefaultChild = state
				}
			}
		}
	end, { v4, v3.OkayButton, state, buttonRef })

	local createElement = React.createElement
	local v5 = {
		title = v3.Title,
		buttonStackInfo = buttonStackInfo,
		isMiddleContentFocusable = false,
		middleContent = middleContent,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		defaultChildRef = 0,
		isRoactGamepadEnabled = 0,
		onCloseClicked = 0
	}
	local defaultChildRef

	if state then
		defaultChildRef = ref
	end

	v5.defaultChildRef = defaultChildRef
	v5.isRoactGamepadEnabled = state
	v5.onCloseClicked = v4
	return createElement(InteractiveAlert, v5)
end))
