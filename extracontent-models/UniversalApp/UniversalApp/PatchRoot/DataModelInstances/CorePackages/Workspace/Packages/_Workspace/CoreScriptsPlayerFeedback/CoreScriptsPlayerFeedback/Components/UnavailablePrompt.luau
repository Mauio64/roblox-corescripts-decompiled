local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local CoreScriptsPlayerFeedbackParent = CoreScriptsPlayerFeedback.Parent
local React = require(CoreScriptsPlayerFeedbackParent.React)
local UIBlox = require(CoreScriptsPlayerFeedbackParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useScreenSize = require(CoreScriptsPlayerFeedbackParent.CoreScriptsRoactCommon).useScreenSize
local useLastInputMethod = require(CoreScriptsPlayerFeedbackParent.FocusNavigationUtils).useLastInputMethod
local GuiService = game:GetService("GuiService")
local useEscapeDismiss = require(CoreScriptsPlayerFeedback.Hooks.useEscapeDismiss)
local useLocalization = require(CoreScriptsPlayerFeedbackParent.Localization).Hooks.useLocalization

return (React.memo(function(t1: {[any]: any}) -- line: 28
	-- upvalues: useScreenSize (copy), useStyle (copy), React (copy), useLastInputMethod (copy), useLocalization (copy), useEscapeDismiss (copy), GuiService (copy), ButtonType (copy), InteractiveAlert (copy)
	local v14 = useScreenSize()
	local v15 = useStyle()
	local v16 = React.useRef(nil)
	local v17 = useLastInputMethod()
	local v18, v19 = React.useState(false)

	React.useEffect(function() -- line: 36
		-- upvalues: v18 (copy), v17 (copy), v19 (copy)
		if not v18 and (v17 == "Keyboard" or v17 == "Gamepad") then
			v19(true)
		end
	end, {
		v18,
		v17
	})

	local v20 = useLocalization({
		Title = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Title",
		HeaderUnder13 = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Header.Under13",
		HintUnder13 = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Hint.Under13",
		HeaderRateLimited = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Header.RateLimited",
		HintRateLimited = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Hint.RateLimited",
		HeaderDefault = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Header.Default",
		HintDefault = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.Hint.Default",
		OkayButton = "CoreScripts.FeedbackPrompt.FeedbackPrompt.Unavailable.OkayButton"
	})
	local _ = v20.Title
	local HeaderUnder13, HintUnder13

	if t1.reason == "Under13" then
		HeaderUnder13 = v20.HeaderUnder13
		HintUnder13 = v20.HintUnder13
	elseif t1.reason == "RateLimited" then
		HeaderUnder13 = v20.HeaderRateLimited
		HintUnder13 = v20.HintRateLimited
	else
		HeaderUnder13 = v20.HeaderDefault
		HintUnder13 = v20.HintDefault
	end

	local v24 = React.useCallback(function() -- line: 68
		-- upvalues: v15 (copy), React (copy), HeaderUnder13 (ref), HintUnder13 (ref)
		local Body = v15.Font.Body
		local v29 = v15.Font.Header2 or v15.Font.Body
		local BaseSize = v15.Font.BaseSize
		local v31 = math.floor(v29.RelativeSize * BaseSize)
		local v32 = math.floor(Body.RelativeSize * BaseSize)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			Header = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 1,
				Text = HeaderUnder13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = v15.Theme.TextEmphasis.Color,
				TextTransparency = v15.Theme.TextEmphasis.Transparency,
				Font = v29.Font,
				TextSize = v31,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			Hint = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 2,
				Text = HintUnder13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = v15.Theme.TextMuted.Color,
				TextTransparency = v15.Theme.TextMuted.Transparency,
				Font = Body.Font,
				TextSize = v32,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		})
	end, {
		v15,
		HeaderUnder13,
		HintUnder13
	})
	local v25 = React.useCallback(function() -- line: 116
		-- upvalues: t1 (copy)
		t1.closePrompt()
	end, { t1.closePrompt })

	useEscapeDismiss("UnavailablePromptCancel", v25)

	local v26 = React.useCallback(function(p1) -- line: 122
		-- upvalues: v16 (copy), v18 (copy), GuiService (copy)
		v16.current = p1

		if v18 and p1 then
			pcall(function() -- line: 125
				-- upvalues: GuiService (copy), p1 (copy)
				GuiService:Select(p1)
			end)
		end
	end, { v18 })

	React.useEffect(function() -- line: 131
		-- upvalues: v18 (copy), v16 (copy), GuiService (copy)
		if not v18 then
			return
		end

		local current = v16.current

		if current then
			pcall(function() -- line: 137
				-- upvalues: GuiService (copy), current (copy)
				GuiService:Select(current)
			end)
		end
	end, { v18 })

	local v27 = React.useMemo(function() -- line: 143
		-- upvalues: ButtonType (copy), v25 (copy), v20 (copy), v26 (copy), v18 (copy)
		return {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					isDelayedInput = false,
					enableInputDelayed = false,
					delayInputSeconds = 1,
					isDisabled = false,
					onActivated = v25,
					text = v20.OkayButton,
					buttonRef = v26
				},
				isDefaultChild = v18
			}}
		}
	end, {
		v25,
		v20.OkayButton,
		v18,
		v26
	})

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		title = v20.Title,
		buttonStackInfo = v27,
		middleContent = v24,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v14,
		defaultChildRef = if not v18 then nil else v16,
		isRoactGamepadEnabled = v18,
		onCloseClicked = v25
	})
end))
