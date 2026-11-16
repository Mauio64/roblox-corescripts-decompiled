local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)

local Text = Foundation.Text

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize

local PermissionPromptFinished = require(parent.Thunks.PermissionPromptFinished)

return function(p)
	local v = useDispatch()
	local v2 = useLocalization({
		allowAccessToCapturesTitle = "Feature.Captures.Title.AllowAccessToCaptures",
		allowAccessToCapturesBody = "Feature.Captures.Body.AllowAccessToCaptures",
		allow = "Feature.Captures.Action.Allow",
		dontAllow = "Feature.Captures.Action.DontAllow"
	})

	local screenSize = useScreenSize()

	local onActivated = React.useCallback(function()
		v(PermissionPromptFinished(p.promptId, true))
	end, { p.promptId })

	local onActivated2 = React.useCallback(function()
		v(PermissionPromptFinished(p.promptId, false))
	end, { p.promptId })

	local buttonStackInfo = React.useMemo(function()
		return {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onActivated, text = v2.allow },
					isDefaultChild = false
				},
				{
					props = { onActivated = onActivated2, text = v2.dontAllow },
					isDefaultChild = true
				}
			}
		}
	end, { onActivated, onActivated2 })

	local middleContent = React.useCallback(function()
		return React.createElement(Text, {
			tag = "size-full-1200 text-align-x-center text-body-large text-wrap",
			Text = v2.allowAccessToCapturesBody
		})
	end, {})

	return React.createElement(InteractiveAlert, {
		buttonStackInfo = buttonStackInfo,
		isMiddleContentFocusable = false,
		middleContent = middleContent,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		title = v2.allowAccessToCapturesTitle
	})
end
