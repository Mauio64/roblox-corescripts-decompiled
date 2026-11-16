local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local parent = UiShellEvents.Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local focusNavigationTelemetry = require(UiShellEvents.Analytics.focusNavigationTelemetry)

local defineFastFlag = game:DefineFastFlag("LogFocusNavExitTriggerKey", false)

local function isHoldAction(value: string): boolean -- 1 equivalent call inferred from this helper
	return string.find(value, "^HoldTo") ~= nil
end

local function getFocusNavEntryExitInputType(p) -- 1 equivalent call inferred from this helper
	if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
		return "Gamepad"
	end

	return if p ~= "None" then p else nil
end

local function isFocusNavActive(p, flag: boolean, flag2: boolean) -- 1 equivalent call inferred from this helper
	return p == "Focus" or flag and not flag2
end

local function useLogFocusNavigationTelemetry(page: string?)
	local v, v2 = FocusNavigationUtils.useLastInputMode()
	local v3 = FocusNavigationUtils.useLastInputMethod()
	local v4 = FocusNavigationUtils.useGamepadCursorEnabled()

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if not ref.current and v == "Focus" and v3 == "Keyboard" then
			ref.current = true
			focusNavigationTelemetry.logKeyboardFocusModeEntered()
		end
	end, { v, v3 })

	React.useEffect(function()
		local function logFocusNavEntryExit()
			local current = ref2.current
			local focusNavActive = isFocusNavActive(v, GuiService.SelectedCoreObject ~= nil, v4) -- inferred equivalent call
			local focusNavEntryExitInputType = getFocusNavEntryExitInputType(v3) -- inferred equivalent call

			if focusNavActive and current == nil then
				if defineFastFlag then
					local triggerKey

					if focusNavEntryExitInputType == "Keyboard" then
						triggerKey = v2
					end

					ref2.current = {
						inputType = focusNavEntryExitInputType,
						startTime = os.clock(),
						triggerKey = triggerKey
					}
					local logFocusNavToggled = focusNavigationTelemetry.logFocusNavToggled
					local v5 = {
						entry = "enter",
						input_type = focusNavEntryExitInputType,
						page = page,
						keyboard_navigation_trigger = 0
					}
					local keyboard_navigation_trigger

					if triggerKey then
						keyboard_navigation_trigger = triggerKey.Name
					end

					v5.keyboard_navigation_trigger = keyboard_navigation_trigger
					logFocusNavToggled(v5)
				else
					ref2.current = {
						inputType = focusNavEntryExitInputType,
						startTime = os.clock()
					}
					local logFocusNavToggled = focusNavigationTelemetry.logFocusNavToggled
					local v5 = {
						entry = "enter",
						input_type = focusNavEntryExitInputType,
						page = page,
						keyboard_navigation_trigger = 0
					}
					local keyboard_navigation_trigger

					if focusNavEntryExitInputType == "Keyboard" and v2 then
						keyboard_navigation_trigger = v2.Name
					end

					v5.keyboard_navigation_trigger = keyboard_navigation_trigger
					logFocusNavToggled(v5)
				end
			elseif not focusNavActive and current ~= nil then
				ref2.current = nil
				local logFocusNavToggled = focusNavigationTelemetry.logFocusNavToggled
				local v5 = {
					entry = "exit",
					input_type = focusNavEntryExitInputType,
					page = page,
					keyboard_navigation_trigger = 0,
					keyboard_navigation_duration = 0
				}
				local keyboard_navigation_trigger

				if defineFastFlag and current.triggerKey then
					keyboard_navigation_trigger = current.triggerKey.Name
				end

				v5.keyboard_navigation_trigger = keyboard_navigation_trigger
				local keyboard_navigation_duration

				if current.inputType == "Keyboard" then
					keyboard_navigation_duration = math.floor((os.clock() - current.startTime) * 1000)
				end

				v5.keyboard_navigation_duration = keyboard_navigation_duration
				logFocusNavToggled(v5)
			end
		end

		logFocusNavEntryExit()
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(logFocusNavEntryExit)
		return function()
			selectedCoreObjectChangedConnection:Disconnect()
		end
	end, { v, v3, v2, v4, page })

	local v5 = React.useCallback(function(action: string, p, p2)
		if v ~= "Focus" and v4 then
			return
		end

		local logFocusNavShortcutToggle = focusNavigationTelemetry.logFocusNavShortcutToggle
		local v5 = {
			btn = not p and "Unknown" or p.Name,
			action = action,
			page = page,
			input_type = 0
		}
		local input_type

		if p2 then
			input_type = FocusNavigationUtils.getInputMethod(p2)
		end

		v5.input_type = input_type
		logFocusNavShortcutToggle(v5)
	end, { v, v4, page })

	React.useEffect(function()
		local buttonHoldCompletedSignalConnection = FocusNavigationUtils.ButtonHoldCompletedSignal:connect(v5)
		return function()
			buttonHoldCompletedSignalConnection:disconnect()
		end
	end, { v5 })

	local v6 = React.useCallback(function(data)
		local eventData = data.eventData

		if
			not data.synthetic
			and eventData
			and eventData.UserInputState == Enum.UserInputState.Begin
			and not isHoldAction(data.eventName) -- inferred equivalent call
		then
			v5(data.eventName, eventData.KeyCode, eventData.UserInputType)
		end
	end, { v5 })
	ReactFocusNavigation.useEventDispatched(v6)
end

return useLogFocusNavigationTelemetry
