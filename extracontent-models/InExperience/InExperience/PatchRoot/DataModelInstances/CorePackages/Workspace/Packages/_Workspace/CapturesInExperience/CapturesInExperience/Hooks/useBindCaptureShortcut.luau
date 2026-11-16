local parent = script.Parent.Parent
local parent2 = parent.Parent

local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local SocialStopwatch = require(parent2.SocialStopwatch)

local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local getCaptureShortcutSetupKeys = require(parent.Utils.getCaptureShortcutSetupKeys)
local TakeCapture = require(parent.Thunks.TakeCapture)

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useKeyboardEnabled = require(parent.Hooks.useKeyboardEnabled)
local usePlayShutterSound = require(parent.Hooks.usePlayShutterSound)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function fn(): boolean -- 1 equivalent call inferred from this helper
	local captureShortcutSetupKeys = getCaptureShortcutSetupKeys()

	for _, captureShortcutSetupKey in captureShortcutSetupKeys do
		if UserInputService:IsKeyDown(captureShortcutSetupKey) then
			return true
		end
	end

	return false
end

return function()
	local v = useAnalytics()
	local v2 = useDispatch()

	local v3 = useSelector(function(p)
		return p[Constants.RoduxKey].IsActive
	end)

	local v4 = useSelector(function(p)
		return p[Constants.RoduxKey].IsCapturesCoreGuiEnabled
	end)

	local v5 = usePlayShutterSound()
	local v6 = useKeyboardEnabled()

	useEffect(function()
		if not (v6 and v4) then
			return
		end

		local function fn2()
			v5()

			if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureTaken) then
				SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureTaken)
			end

			v.fireEvent(EventNames.CapturesEntrypointActivated)
			v.fireEvent(EventNames.CapturesDesktopHotkeyCaptureTriggered)
			v2(TakeCapture())
		end

		ContextActionService:BindCoreAction("CaptureShortcutAction", function(_, p)
			if p == Enum.UserInputState.Begin and fn() then -- inferred equivalent call
				fn2()
				return Enum.ContextActionResult.Sink
			end

			return Enum.ContextActionResult.Pass
		end, false, Enum.KeyCode.One)

		return function()
			ContextActionService:UnbindCoreAction("CaptureShortcutAction")
		end
	end, { v3, v4, v6 })
end
