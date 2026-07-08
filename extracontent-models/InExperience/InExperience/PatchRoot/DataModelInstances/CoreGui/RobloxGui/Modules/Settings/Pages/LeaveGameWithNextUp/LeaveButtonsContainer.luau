local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local v12 = require(RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")):IsEnabled()
local Foundation = require(CorePackages.Packages.Foundation)
local Telemetry = require(script.Parent.Telemetry)
local NextUpState = require(script.Parent.NextUpState)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local FFlagEnableNextUpImageLatencyTelemetry = require(script.Parent.Flags.FFlagEnableNextUpImageLatencyTelemetry)
local v25 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v26 = if not v25 then nil else require(RobloxGui.Modules.Chrome.Service)
local v27 = if not v25 then nil else require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutRemoveRespawnOnLeavePage = SharedFlags.FFlagChromeShortcutRemoveRespawnOnLeavePage

local function LeaveButtonsContainer(t1: {[any]: any}) -- line: 48
	-- upvalues: useTokens (copy), React (copy), useLastInputMode (copy), useFocusGuiObject (copy), useLocalization (copy), Constants (copy), FFlagEnableConsoleExpControls (copy), v25 (copy), v26 (copy), v27 (copy), FFlagChromeShortcutRemoveRespawnOnLeavePage (copy), ContextActionService (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), Telemetry (copy), NextUpState (copy), leaveGame (copy), Utility (copy), v12 (copy), View (copy), FoundationText (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	local v33 = useTokens()
	local v34 = React.useRef(nil)
	local v35 = useLastInputMode()
	local v36 = useFocusGuiObject()
	local v37 = useLocalization({
		[Constants.ConfirmLeaveGameLocalizedKey] = Constants.ConfirmLeaveGameLocalizedKey,
		[Constants.LeaveGameLocalizedKey] = Constants.LeaveGameLocalizedKey,
		[Constants.DontLeaveGameLocalizedKey] = Constants.DontLeaveGameLocalizedKey
	})
	local v38 = React.useCallback(function(_, p2, p3) -- line: 60
		-- upvalues: t1 (copy)
		if p2 == Enum.UserInputState.Begin then
			local v47 = p3.UserInputType == Enum.UserInputType.Gamepad1 or (p3.UserInputType == Enum.UserInputType.Gamepad2 or (p3.UserInputType == Enum.UserInputType.Gamepad3 or p3.UserInputType == Enum.UserInputType.Gamepad4))

			t1.onDontLeave(v47)
		end
	end, { t1.onDontLeave })

	React.useEffect(function() -- line: 71
		-- upvalues: FFlagEnableConsoleExpControls (copy), v25 (copy), v26 (copy), v27 (copy), FFlagChromeShortcutRemoveRespawnOnLeavePage (copy), ContextActionService (copy), v38 (copy)
		if FFlagEnableConsoleExpControls then
			if v25 and v26 and v27 then
				if FFlagChromeShortcutRemoveRespawnOnLeavePage then
					v26:setShortcutBar(v27.TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID)
				else
					v26:setShortcutBar(v27.TILTMENU_DIALOG_SHORTCUTBAR_ID)
				end
			end
		else
			ContextActionService:BindCoreAction("LeaveGameCancelAction", v38, false, Enum.KeyCode.ButtonB)
		end

		return function() -- line: 84
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("LeaveGameCancelAction")
		end
	end, { v38 })
	React.useEffect(function() -- line: 89
		-- upvalues: v35 (copy), v36 (copy), v34 (copy)
		if v35 == "Focus" then
			v36(v34.current)

			return
		end

		v36(nil)
	end, {
		v35,
		v34.current
	})

	local v39 = if not FFlagEnableNextUpImageLatencyTelemetry then nil else React.useRef(false)
	local v40 = if not FFlagEnableNextUpImageLatencyTelemetry then nil else function(p4) -- line: 99
		-- upvalues: v39 (copy), Telemetry (copy)
		if v39.current then
			return
		end

		v39.current = true
		Telemetry.logNextUpExitModalAction(p4)
	end

	if FFlagEnableNextUpImageLatencyTelemetry then
		React.useEffect(function() -- line: 109
			-- upvalues: v40 (copy), Telemetry (copy)
			return function() -- line: 110
				-- upvalues: v40 (copy), Telemetry (copy)
				v40(Telemetry.NextUpSortViewActionType.CloseExitModalEscape)
			end
		end, {})
	end

	local v41 = React.useCallback(function() -- line: 116
		-- upvalues: FFlagEnableNextUpImageLatencyTelemetry (copy), v40 (copy), Telemetry (copy), NextUpState (copy), leaveGame (copy)
		if FFlagEnableNextUpImageLatencyTelemetry then
			v40(Telemetry.NextUpSortViewActionType.LeaveGame)
		else
			Telemetry.logNextUpSortView(NextUpState.getNextUpTilesLoaded())
		end

		leaveGame(true)
	end, {})
	local v42 = React.useCallback(function() -- line: 125
		-- upvalues: FFlagEnableNextUpImageLatencyTelemetry (copy), v40 (copy), Telemetry (copy), NextUpState (copy), t1 (copy), Utility (copy)
		if FFlagEnableNextUpImageLatencyTelemetry then
			v40(Telemetry.NextUpSortViewActionType.CloseExitModalClick)
		else
			Telemetry.logNextUpSortView(NextUpState.getNextUpTilesLoaded())
		end

		t1.onDontLeave(Utility:IsUsingGamepad())
	end, { t1.onDontLeave })
	local s1 = "text-heading-medium"

	if Utility:IsSmallTouchScreen() then
		s1 = "text-heading-small"
	elseif v12 then
		s1 = "text-heading-large"
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-large",
		LayoutOrder = 1,
		Position = UDim2.new(0, 0, 0, not v12 and 0 or 100)
	}, {
		LeaveGameText = React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = v37[Constants.ConfirmLeaveGameLocalizedKey],
			tag = `text-wrap { s1 } auto-y size-full-0`,
			textStyle = v33.Color.Extended.White.White_100
		}),
		LeaveButtonsContainer = React.createElement(View, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y row align-x-center gap-medium wrap flex-x-fill"
		}, {
			LeaveGameButton = React.createElement(Button, {
				LayoutOrder = 1,
				text = v37[Constants.LeaveGameLocalizedKey],
				size = InputSize.Medium,
				variant = ButtonVariant.SoftEmphasis,
				width = UDim.new(0, t1.buttonSize),
				ref = v34,
				onActivated = v41
			}),
			DontLeaveGameButton = React.createElement(Button, {
				LayoutOrder = 2,
				text = v37[Constants.DontLeaveGameLocalizedKey],
				size = InputSize.Medium,
				variant = ButtonVariant.Standard,
				width = UDim.new(0, t1.buttonSize),
				onActivated = v42
			})
		})
	})
end

return React.memo(LeaveButtonsContainer)
