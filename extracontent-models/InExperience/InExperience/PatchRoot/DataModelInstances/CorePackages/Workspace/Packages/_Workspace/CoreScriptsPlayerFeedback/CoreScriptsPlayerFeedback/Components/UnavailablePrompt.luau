local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
		local createElement = React.createElement
		local v4 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local children = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			Header = 0,
			Hint = 0
		}

		local createElement2 = React.createElement
		local v5 = {
			BackgroundTransparency = 1,
			Text = text,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = v.Theme.TextEmphasis.Color,
			TextTransparency = v.Theme.TextEmphasis.Transparency,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			Size = 0,
			AutomaticSize = 0,
			LayoutOrder = 1
		}
		local font

		if not FoundationFontFaceMigration then
			font = header2.Font
		end

		v5.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v.Tokens.Typography.TitleLarge.Font)
		end

		v5.FontFace = fontFace

		v5.TextSize = textSize
		v5.Size = UDim2.new(1, 0, 0, 0)
		v5.AutomaticSize = Enum.AutomaticSize.Y
		children.Header = createElement2("TextLabel", v5)

		local createElement3 = React.createElement
		local v6 = {
			BackgroundTransparency = 1,
			Text = text2,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = v.Theme.TextMuted.Color,
			TextTransparency = v.Theme.TextMuted.Transparency,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			Size = 0,
			AutomaticSize = 0,
			LayoutOrder = 2
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = body.Font
		end

		v6.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
		end

		v6.FontFace = fontFace2

		v6.TextSize = textSize2
		v6.Size = UDim2.new(1, 0, 0, 0)
		v6.AutomaticSize = Enum.AutomaticSize.Y
		children.Hint = createElement3("TextLabel", v6)
		return createElement("Frame", v4, children)
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
