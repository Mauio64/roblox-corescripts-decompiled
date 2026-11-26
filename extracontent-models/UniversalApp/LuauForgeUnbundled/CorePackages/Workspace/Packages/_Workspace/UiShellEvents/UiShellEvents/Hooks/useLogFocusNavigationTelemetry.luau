local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/FocusNavigationUtils")
local focusNavigationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/UiShellEvents/Analytics/focusNavigationTelemetry")

local defineFastFlag = game:DefineFastFlag("LogFocusNavExitTriggerKey", false)

local function isHoldAction(value): boolean
	return string.find(value, "^HoldTo") ~= nil
end

local function getFocusNavEntryExitInputType(p2)
	if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
		return "Gamepad"
	end

	if p2 == "None" then
		return nil
	end

	return p2
end

local function isFocusNavActive(p2, p3, p4)
	return p2 == "Focus" or p3 and not p4
end

local function useLogFocusNavigationTelemetry(p2)
	local v5, v6 = FocusNavigationUtils.useLastInputMode()
	local v7 = FocusNavigationUtils.useLastInputMethod()
	local v8 = FocusNavigationUtils.useGamepadCursorEnabled()

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if not ref.current and v5 == "Focus" and v7 == "Keyboard" then
			ref.current = true
			focusNavigationTelemetry.logKeyboardFocusModeEntered()
		end
	end, { v5, v7 })

	React.useEffect(function()
		local function logFocusNavEntryExit()
			local current = ref2.current
			local v9 = GuiService.SelectedCoreObject ~= nil
			local v11 = v5 == "Focus" or v9 and not v8

			local v12 = v7

			if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
				v12 = "Gamepad"
			elseif v12 == "None" then
				v12 = nil
			end

			if v11 and current == nil then
				if defineFastFlag then
					local v13 = if v12 == "Keyboard" then v6 else nil
					ref2.current = {
						inputType = v12,
						startTime = os.clock(),
						triggerKey = v13
					}
					local logFocusNavToggled = focusNavigationTelemetry.logFocusNavToggled
					local v14 = {
						entry = "enter",
						input_type = v12,
						page = p2,
						keyboard_navigation_trigger = 0
					}

					local v15 = if v13 then v13.Name else nil
					v14.keyboard_navigation_trigger = v15
					logFocusNavToggled(v14)
				else
					ref2.current = { inputType = v12, startTime = os.clock() }
					local logFocusNavToggled = focusNavigationTelemetry.logFocusNavToggled
					local v13 = {
						entry = "enter",
						input_type = v12,
						page = p2,
						keyboard_navigation_trigger = 0
					}

					local v14 = if v12 == "Keyboard" and v6 then v6.Name else nil
					v13.keyboard_navigation_trigger = v14
					logFocusNavToggled(v13)
				end
			elseif not v11 and current ~= nil then
				ref2.current = nil
				local logFocusNavToggled = focusNavigationTelemetry.logFocusNavToggled
				local v13 = {
					entry = "exit",
					input_type = v12,
					page = p2,
					keyboard_navigation_trigger = 0,
					keyboard_navigation_duration = 0
				}

				local v14 = if defineFastFlag and current.triggerKey then current.triggerKey.Name else nil
				v13.keyboard_navigation_trigger = v14

				local v15 = if current.inputType == "Keyboard" then math.floor((os.clock() - current.startTime) * 1000) else nil
				v13.keyboard_navigation_duration = v15
				logFocusNavToggled(v13)
			end
		end

		logFocusNavEntryExit()
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(logFocusNavEntryExit)
		return function()
			selectedCoreObjectChangedConnection:Disconnect()
		end
	end, { v5, v7, v6, v8, p2 })

	local v9 = React.useCallback(function(p3, p4, p5)
		if v5 ~= "Focus" and v8 then
			return
		end

		local logFocusNavShortcutToggle = focusNavigationTelemetry.logFocusNavShortcutToggle
		local v11 = {
			btn = not p4 and "Unknown" or p4.Name,
			action = p3,
			page = p2,
			input_type = 0
		}

		local v12 = if p5 then FocusNavigationUtils.getInputMethod(p5) else nil
		v11.input_type = v12
		logFocusNavShortcutToggle(v11)
	end, { v5, v8, p2 })

	React.useEffect(function()
		local buttonHoldCompletedSignalConnection = FocusNavigationUtils.ButtonHoldCompletedSignal:connect(v9)
		return function()
			buttonHoldCompletedSignalConnection:disconnect()
		end
	end, { v9 })

	local v10 = React.useCallback(function(data)
		local eventData = data.eventData

		if not data.synthetic and eventData and eventData.UserInputState == Enum.UserInputState.Begin then
			local eventName = data.eventName

			if string.find(eventName, "^HoldTo") == nil then
				v9(data.eventName, eventData.KeyCode, eventData.UserInputType)
			end
		end
	end, { v9 })
	ReactFocusNavigation.useEventDispatched(v10)
end

return useLogFocusNavigationTelemetry
