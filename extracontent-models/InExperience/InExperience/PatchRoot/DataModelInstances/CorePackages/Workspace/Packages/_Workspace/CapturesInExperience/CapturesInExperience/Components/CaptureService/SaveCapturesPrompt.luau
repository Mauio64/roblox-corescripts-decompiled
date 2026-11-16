local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local CapturePromptItem = require(parent.Components.CaptureService.CapturePromptItem)

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useLocalization = Localization.Hooks.useLocalization
local usePinInputStateWhileOpen = require(parent.Hooks.usePinInputStateWhileOpen)
local useScreenSize = RobloxAppHooks.useScreenSize

local EventNames = require(parent.Analytics.EventNames)
local SaveCapturesPromptFinished = require(parent.Thunks.SaveCapturesPromptFinished)
require(parent.Types)

local FFlagCapturePermissionsPromptFreeMouse = require(parent.Flags.FFlagCapturePermissionsPromptFreeMouse)

local function fn(p) -- 3 equivalent calls inferred from this helper
	return typeof(p) == "Content" and p.Object ~= nil and p.Object:IsA("VideoCapture")
end

local function fn2(contents): boolean -- 1 equivalent call inferred from this helper
	for _, item in contents do
		if fn(item) then -- inferred equivalent call
			return true
		end
	end

	return false
end

return function(props)
	local v = useAnalytics()
	local v2 = useDispatch()
	local screenSize = useScreenSize()

	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local state3, setState3 = React.useState(1)
	local state4, setState4 = React.useState({})

	local contents = props.promptData.contents
	local v3 = props.enableInputDelayed == nil or props.enableInputDelayed
	local v4 = fn2(contents) -- inferred equivalent call
	local v5 = useLocalization({
		bodyText = "Feature.Captures.Body.SaveCapturesPrompt",
		no = "Feature.Captures.Action.NoThanks",
		title = "Feature.Captures.Title.SaveCapturesPrompt",
		yes = "Feature.Captures.Action.Save"
	})

	usePinInputStateWhileOpen(FFlagCapturePermissionsPromptFreeMouse)

	React.useEffect(function()
		v.fireEvent(EventNames.SaveCapturesPromptViewed)
	end, {})

	React.useEffect(function()
		if v4 then
			v.fireEvent(EventNames.SaveCapturesPromptVideoPrompted)
		end
	end, { v4 })

	useEffectOnce(function()
		local set = {}

		for k, _ in contents do
			set[k] = true
		end

		setState4(set)
	end, { contents })

	local updateSelected = React.useCallback(function(flag: boolean)
		setState4(function(p)
			local clone = table.clone(p)
			clone[state3] = flag
			return clone
		end)
	end, { state3 })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, { setState })

	local onAbsoluteSizeChanged2 = React.useCallback(function(p)
		setState2(p.AbsoluteSize)
	end, { setState2 })

	local onActivated = React.useCallback(function()
		local v6 = {}
		local count = 0
		local count2 = 0
		local flag = false

		for k, v7 in state4 do
			v6[contents[k]] = v7

			if v7 then
				count += 1

				if fn(contents[k]) then -- inferred equivalent call
					flag = true
				end
			end

			count2 += 1
		end

		if flag then
			v.fireEvent(EventNames.SaveCapturesPromptVideoAccepted)
		end

		v.fireEvent(EventNames.SaveCapturesPromptAccepted, {
			savedCaptures = count,
			totalCaptures = count2
		})

		v2(SaveCapturesPromptFinished(props.promptId, v6))
	end, { props.promptData, props.promptId, state4 })

	local onActivated2 = React.useCallback(function()
		local flag = true
		local flag2

		for _, content in props.promptData.contents do
			if fn(content) then -- inferred equivalent call
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			v.fireEvent(EventNames.SaveCapturesPromptVideoRejected)
		end

		v.fireEvent(EventNames.SaveCapturesPromptRejected)
		local v6 = {}

		for _, content in props.promptData.contents do
			v6[content] = false
		end

		v2(SaveCapturesPromptFinished(props.promptId, v6))
	end, { props.promptData, props.promptId })

	local onActivated3 = React.useCallback(function()
		setState3((math.max(1, state3 - 1)))
	end, { state3 })

	local onActivated4 = React.useCallback(function()
		setState3((math.min(#contents, state3 + 1)))
	end, { contents, state3 })

	local buttonStackInfo = React.useMemo(function()
		return {
			buttons = {
				{
					props = { onActivated = onActivated2, text = v5.no },
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						delayInputSeconds = 2,
						enableInputDelayed = v3,
						isDelayedInput = v3,
						onActivated = onActivated,
						text = v5.yes
					},
					isDefaultChild = false
				}
			}
		}
	end, { v5, onActivated, onActivated2 })

	local middleContent = React.useCallback(function()
		local v6 = state.Y - state2.Y
		local v7 = screenSize.Y - 80 - v6

		local createElement = React.createElement
		local v8 = {
			Size = UDim2.new(1, 0, 0, 200),
			sizeConstraint = { MaxSize = Vector2.new(1e999, v7) },
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2
		}

		local v9 = {
			CapturePromptItem = React.createElement(CapturePromptItem, {
				content = contents[state3],
				isSelected = state4[state3],
				showCheckbox = #contents > 1,
				updateSelected = updateSelected
			}),
			Overlay = 0
		}

		local createElement2 = React.createElement

		local v10 = {
			CountView = React.createElement(View, {
				tag = "bg-over-media-0 anchor-top-left auto-xy clip padding-x-small padding-y-xsmall position-top-left radius-circle",
				Visible = #contents > 1
			}, {
				Count = React.createElement(Text, {
					tag = "auto-xy content-emphasis text-body-small",
					Text = `{state3}/{#contents}`
				})
			}),
			PrevCaptureButton = 0,
			NextCaptureButton = 0
		}
		local prevCaptureButton

		if state3 > 1 then
			prevCaptureButton = React.createElement(
				View,
				{
					tag = "bg-over-media-0 anchor-center-left auto-xy clip position-center-left radius-circle",
					onActivated = onActivated3
				},
				{
					CycleLeftIcon = React.createElement(Icon, { name = "icons/actions/cycleLeft" })
				}
			)
		end

		v10.PrevCaptureButton = prevCaptureButton
		local nextCaptureButton

		if state3 < #contents then
			nextCaptureButton = React.createElement(
				View,
				{
					tag = "bg-over-media-0 anchor-center-right auto-xy clip position-center-right radius-circle",
					onActivated = onActivated4
				},
				{},
				{
					CycleRightIcon = React.createElement(Icon, { name = "icons/actions/cycleRight" })
				}
			)
		end

		v10.NextCaptureButton = nextCaptureButton
		v9.Overlay = createElement2(View, {
			LayoutOrder = 2,
			tag = "padding-small size-full",
			ZIndex = 2
		}, v10)
		return createElement(View, v8, v9)
	end, {
		state,
		contents,
		state2,
		state3,
		onAbsoluteSizeChanged2,
		onActivated4,
		onActivated3,
		screenSize,
		state4,
		updateSelected
	})

	return React.createElement(InteractiveAlert, {
		bodyText = v5.bodyText,
		buttonStackInfo = buttonStackInfo,
		isMiddleContentFocusable = false,
		middleContent = middleContent,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		title = v5.title
	})
end
