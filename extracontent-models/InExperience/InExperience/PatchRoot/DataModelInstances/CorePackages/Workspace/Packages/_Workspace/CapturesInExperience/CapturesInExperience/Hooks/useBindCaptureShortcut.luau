local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local getCaptureShortcutSetupKeys = require(ParentParent.Utils.getCaptureShortcutSetupKeys)
local TakeCapture = require(ParentParent.Thunks.TakeCapture)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useKeyboardEnabled = require(ParentParent.Hooks.useKeyboardEnabled)
local usePlayShutterSound = require(ParentParent.Hooks.usePlayShutterSound)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function() -- line: 35
	-- upvalues: useAnalytics (copy), useDispatch (copy), useSelector (copy), Constants (copy), usePlayShutterSound (copy), useKeyboardEnabled (copy), useEffect (copy), SocialStopwatch (copy), EventNames (copy), TakeCapture (copy), ContextActionService (copy), getCaptureShortcutSetupKeys (copy), UserInputService (copy)
	local v20 = useAnalytics()
	local v21 = useDispatch()
	local v22 = useSelector(function(p1) -- line: 39
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].IsActive
	end)
	local v23 = useSelector(function(p2) -- line: 43
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].IsCapturesCoreGuiEnabled
	end)
	local v24 = usePlayShutterSound()
	local v25 = useKeyboardEnabled()

	useEffect(function() -- line: 50
		-- upvalues: v25 (copy), v23 (copy), v24 (copy), SocialStopwatch (copy), v20 (copy), EventNames (copy), v21 (copy), TakeCapture (copy), ContextActionService (copy), getCaptureShortcutSetupKeys (copy), UserInputService (copy)
		if not v25 then
			return
		end

		if not v23 then
			return
		end

		local function v28() -- line: 59
			-- upvalues: v24 (copy), SocialStopwatch (copy), v20 (copy), EventNames (copy), v21 (copy), TakeCapture (copy)
			v24()

			if not SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CaptureTaken) then
				SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.CaptureTaken)
			end

			v20.fireEvent(EventNames.CapturesEntrypointActivated)
			v20.fireEvent(EventNames.CapturesDesktopHotkeyCaptureTriggered)
			v21(TakeCapture())
		end

		ContextActionService:BindCoreAction("CaptureShortcutAction", function(_, p4) -- line: 70
			-- upvalues: getCaptureShortcutSetupKeys (copy), UserInputService (copy), v28 (copy)
			if p4 == Enum.UserInputState.Begin then
				local g34 = nil
				local v33 = nil

				for _, v32 in (getCaptureShortcutSetupKeys()) do
					if UserInputService:IsKeyDown(v32) then
						v33 = true
						g34 = true
					end

					if g34 then
						break
					end
				end

				if not g34 then
					v33 = false
				end

				g34 = false

				if v33 then
					v28()

					return Enum.ContextActionResult.Sink
				end
			end

			return Enum.ContextActionResult.Pass
		end, false, Enum.KeyCode.One)

		return function() -- line: 79
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("CaptureShortcutAction")
		end
	end, {
		v22,
		v23,
		v25
	})
end
