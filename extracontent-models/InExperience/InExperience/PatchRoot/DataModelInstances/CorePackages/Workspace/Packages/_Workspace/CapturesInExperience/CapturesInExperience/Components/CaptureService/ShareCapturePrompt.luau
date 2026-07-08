local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local View = Foundation.View
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local usePinInputStateWhileOpen = require(ParentParent.Hooks.usePinInputStateWhileOpen)
local useScreenSize = RobloxAppHooks.useScreenSize
local CapturePromptItem = require(ParentParent.Components.CaptureService.CapturePromptItem)
local EventNames = require(ParentParent.Analytics.EventNames)
local ShareCapturePromptFinished = require(ParentParent.Thunks.ShareCapturePromptFinished)

require(ParentParent.Types)

local FFlagCapturePermissionsPromptFreeMouse = require(ParentParent.Flags.FFlagCapturePermissionsPromptFreeMouse)

return function(t1: {[any]: any}) -- line: 40
	-- upvalues: useAnalytics (copy), useDispatch (copy), useScreenSize (copy), React (copy), useLocalization (copy), usePinInputStateWhileOpen (copy), FFlagCapturePermissionsPromptFreeMouse (copy), EventNames (copy), ShareCapturePromptFinished (copy), ButtonType (copy), View (copy), CapturePromptItem (copy), InteractiveAlert (copy)
	local v22 = useAnalytics()
	local v23 = useDispatch()
	local v24 = useScreenSize()
	local v25, v26 = React.useState(Vector2.new(0, 0))
	local v27, v28 = React.useState(Vector2.new(0, 0))
	local v29, v30 = React.useState(Vector2.new(0, 0))
	local content = t1.promptData.content
	local isU13LocalSavePrompt = t1.promptData.isU13LocalSavePrompt
	local v33 = t1.enableInputDelayed == nil or t1.enableInputDelayed
	local v34 = typeof(content) == "Content" and (content.Object ~= nil and content.Object:IsA("VideoCapture"))
	local v35 = useLocalization({
		no = "Feature.Captures.Action.NoThanks",
		saveBodyText = "Feature.Captures.Body.SaveCapturesPrompt",
		saveTitle = "Feature.Captures.Title.SaveCapturesPrompt",
		saveYes = "Feature.Captures.Action.Save",
		shareBodyText = "Feature.Captures.Body.ShareCapturePrompt",
		shareTitle = "Feature.Captures.Title.ShareCapturePrompt",
		shareYes = "Feature.Captures.Action.Share"
	})
	local v36 = if not isU13LocalSavePrompt then v35.shareBodyText else v35.saveBodyText
	local v37 = if not isU13LocalSavePrompt then v35.shareTitle else v35.saveTitle
	local v38 = if not isU13LocalSavePrompt then v35.shareYes else v35.saveYes

	usePinInputStateWhileOpen(FFlagCapturePermissionsPromptFreeMouse)
	React.useEffect(function() -- line: 71
		-- upvalues: isU13LocalSavePrompt (copy), v22 (copy), EventNames (copy), v34 (copy)
		if not isU13LocalSavePrompt then
			v22.fireEvent(EventNames.ShareCapturePromptViewed)

			if v34 then
				v22.fireEvent(EventNames.ShareCapturePromptVideoPrompted)
			end
		end
	end, {
		v22.fireEvent,
		isU13LocalSavePrompt,
		v34
	})

	local v39 = React.useCallback(function(p1) -- line: 80
		-- upvalues: v26 (copy)
		v26(p1.AbsoluteSize)
	end, { v26 })
	local v40 = React.useCallback(function(p2) -- line: 84
		-- upvalues: v28 (copy)
		v28(p2.AbsoluteSize)
	end, { v28 })
	local v41 = React.useCallback(function() -- line: 89
		-- upvalues: isU13LocalSavePrompt (copy), v22 (copy), EventNames (copy), v34 (copy), v23 (copy), ShareCapturePromptFinished (copy), t1 (copy)
		if not isU13LocalSavePrompt then
			v22.fireEvent(EventNames.ShareCapturePromptAccepted)

			if v34 then
				v22.fireEvent(EventNames.ShareCapturePromptVideoAccepted)
			end
		end

		v23(ShareCapturePromptFinished(t1.promptId, t1.promptData, true))
	end, {
		v22.fireEvent,
		v23,
		isU13LocalSavePrompt,
		v34,
		t1.promptData,
		t1.promptId
	})
	local v42 = React.useCallback(function() -- line: 103
		-- upvalues: isU13LocalSavePrompt (copy), v22 (copy), EventNames (copy), v34 (copy), v23 (copy), ShareCapturePromptFinished (copy), t1 (copy)
		if not isU13LocalSavePrompt then
			v22.fireEvent(EventNames.ShareCapturePromptRejected)

			if v34 then
				v22.fireEvent(EventNames.ShareCapturePromptVideoRejected)
			end
		end

		v23(ShareCapturePromptFinished(t1.promptId, t1.promptData, false))
	end, {
		v22.fireEvent,
		v23,
		isU13LocalSavePrompt,
		v34,
		t1.promptData,
		t1.promptId
	})
	local v43 = React.useCallback(function(p3) -- line: 116
		-- upvalues: v30 (copy)
		v30(p3.Resolution)
	end, { v30 })
	local v44 = React.useMemo(function() -- line: 120
		-- upvalues: v42 (copy), v35 (copy), ButtonType (copy), v33 (copy), v41 (copy), v38 (copy)
		return {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = v42,
						text = v35.no
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						delayInputSeconds = 2,
						enableInputDelayed = v33,
						isDelayedInput = v33,
						onActivated = v41,
						text = v38
					}
				}
			}
		}
	end, {
		v33,
		v35,
		v41,
		v42,
		v38
	})
	local v45 = React.useCallback(function() -- line: 146
		-- upvalues: v25 (copy), v27 (copy), v24 (copy), React (copy), View (copy), v40 (copy), CapturePromptItem (copy), content (copy)
		local v49 = v25.Y - v27.Y
		local v50 = v24.Y - 80 - v49

		return React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 200),
			sizeConstraint = {
				MaxSize = Vector2.new(1e999, v50)
			},
			onAbsoluteSizeChanged = v40
		}, {
			CapturePromptItem = React.createElement(CapturePromptItem, {
				isSelected = true,
				showCheckbox = false,
				content = content,
				updateSelected = function() -- line: 161
				end
			})
		})
	end, {
		v25,
		content,
		v27,
		v43,
		v29
	})

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		bodyText = v36,
		buttonStackInfo = v44,
		middleContent = v45,
		onAbsoluteSizeChanged = v39,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v24,
		title = v37
	})
end
