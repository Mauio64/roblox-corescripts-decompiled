local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local FoundationText = Foundation.Text
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local PermissionPromptFinished = require(ParentParent.Thunks.PermissionPromptFinished)

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useDispatch (copy), useLocalization (copy), useScreenSize (copy), React (copy), PermissionPromptFinished (copy), ButtonType (copy), FoundationText (copy), InteractiveAlert (copy)
	local v17 = useDispatch()
	local v18 = useLocalization({
		allowAccessToCapturesTitle = "Feature.Captures.Title.AllowAccessToCaptures",
		allowAccessToCapturesBody = "Feature.Captures.Body.AllowAccessToCaptures",
		allow = "Feature.Captures.Action.Allow",
		dontAllow = "Feature.Captures.Action.DontAllow"
	})
	local v19 = useScreenSize()
	local v20 = React.useCallback(function() -- line: 37
		-- upvalues: v17 (copy), PermissionPromptFinished (copy), t1 (copy)
		v17(PermissionPromptFinished(t1.promptId, true))
	end, { t1.promptId })
	local v21 = React.useCallback(function() -- line: 43
		-- upvalues: v17 (copy), PermissionPromptFinished (copy), t1 (copy)
		v17(PermissionPromptFinished(t1.promptId, false))
	end, { t1.promptId })
	local v22 = React.useMemo(function() -- line: 49
		-- upvalues: ButtonType (copy), v20 (copy), v18 (copy), v21 (copy)
		return {
			buttons = {
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v20,
						text = v18.allow
					}
				},
				{
					isDefaultChild = true,
					props = {
						onActivated = v21,
						text = v18.dontAllow
					}
				}
			}
		}
	end, {
		v20,
		v21
	})
	local v23 = React.useCallback(function() -- line: 71
		-- upvalues: React (copy), FoundationText (copy), v18 (copy)
		return React.createElement(FoundationText, {
			tag = "size-full-1200 text-align-x-center text-body-large text-wrap",
			Text = v18.allowAccessToCapturesBody
		})
	end, {})

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		buttonStackInfo = v22,
		middleContent = v23,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v19,
		title = v18.allowAccessToCapturesTitle
	})
end
