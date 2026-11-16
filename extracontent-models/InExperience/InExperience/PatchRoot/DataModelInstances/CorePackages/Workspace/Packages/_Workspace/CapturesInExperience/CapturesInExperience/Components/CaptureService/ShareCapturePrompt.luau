local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)

local View = Foundation.View

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local usePinInputStateWhileOpen = require(parent.Hooks.usePinInputStateWhileOpen)
local useScreenSize = RobloxAppHooks.useScreenSize

local CapturePromptItem = require(parent.Components.CaptureService.CapturePromptItem)
local EventNames = require(parent.Analytics.EventNames)
local ShareCapturePromptFinished = require(parent.Thunks.ShareCapturePromptFinished)
require(parent.Types)

local FFlagCapturePermissionsPromptFreeMouse = require(parent.Flags.FFlagCapturePermissionsPromptFreeMouse)

return function(props)
	local v = useAnalytics()
	local v2 = useDispatch()
	local screenSize = useScreenSize()

	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local state3, setState3 = React.useState(Vector2.new(0, 0))

	local content = props.promptData.content
	local isU13LocalSavePrompt = props.promptData.isU13LocalSavePrompt
	local v3 = props.enableInputDelayed == nil or props.enableInputDelayed
	local v4

	if typeof(content) == "Content" and content.Object ~= nil then
		v4 = content.Object:IsA("VideoCapture")
	else
		v4 = false
	end

	local v5 = useLocalization({
		no = "Feature.Captures.Action.NoThanks",
		saveBodyText = "Feature.Captures.Body.SaveCapturesPrompt",
		saveTitle = "Feature.Captures.Title.SaveCapturesPrompt",
		saveYes = "Feature.Captures.Action.Save",
		shareBodyText = "Feature.Captures.Body.ShareCapturePrompt",
		shareTitle = "Feature.Captures.Title.ShareCapturePrompt",
		shareYes = "Feature.Captures.Action.Share"
	})
	local bodyText

	if isU13LocalSavePrompt then
		bodyText = v5.saveBodyText
	else
		bodyText = v5.shareBodyText
	end

	local title

	if isU13LocalSavePrompt then
		title = v5.saveTitle
	else
		title = v5.shareTitle
	end

	local text

	if isU13LocalSavePrompt then
		text = v5.saveYes
	else
		text = v5.shareYes
	end

	usePinInputStateWhileOpen(FFlagCapturePermissionsPromptFreeMouse)

	React.useEffect(function()
		if not isU13LocalSavePrompt then
			v.fireEvent(EventNames.ShareCapturePromptViewed)

			if v4 then
				v.fireEvent(EventNames.ShareCapturePromptVideoPrompted)
			end
		end
	end, { v.fireEvent, isU13LocalSavePrompt, v4 })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, { setState })

	local onAbsoluteSizeChanged2 = React.useCallback(function(p)
		setState2(p.AbsoluteSize)
	end, { setState2 })

	local onActivated = React.useCallback(function()
		if not isU13LocalSavePrompt then
			v.fireEvent(EventNames.ShareCapturePromptAccepted)

			if v4 then
				v.fireEvent(EventNames.ShareCapturePromptVideoAccepted)
			end
		end

		v2(ShareCapturePromptFinished(props.promptId, props.promptData, true))
	end, { v.fireEvent, v2, isU13LocalSavePrompt, v4, props.promptData, props.promptId })

	local onActivated2 = React.useCallback(function()
		if not isU13LocalSavePrompt then
			v.fireEvent(EventNames.ShareCapturePromptRejected)

			if v4 then
				v.fireEvent(EventNames.ShareCapturePromptVideoRejected)
			end
		end

		v2(ShareCapturePromptFinished(props.promptId, props.promptData, false))
	end, { v.fireEvent, v2, isU13LocalSavePrompt, v4, props.promptData, props.promptId })

	local v6 = React.useCallback(function(p)
		setState3(p.Resolution)
	end, { setState3 })

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
						text = text
					},
					isDefaultChild = false
				}
			}
		}
	end, { v3, v5, onActivated, onActivated2, text })

	local middleContent = React.useCallback(function()
		local v7 = state.Y - state2.Y
		local v8 = screenSize.Y - 80 - v7

		return React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 200),
			sizeConstraint = { MaxSize = Vector2.new(1e999, v8) },
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2
		}, {
			CapturePromptItem = React.createElement(CapturePromptItem, {
				content = content,
				isSelected = true,
				showCheckbox = false,
				updateSelected = function() end
			})
		})
	end, { state, content, state2, v6, state3 })

	return React.createElement(InteractiveAlert, {
		bodyText = bodyText,
		buttonStackInfo = buttonStackInfo,
		isMiddleContentFocusable = false,
		middleContent = middleContent,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		title = title
	})
end
