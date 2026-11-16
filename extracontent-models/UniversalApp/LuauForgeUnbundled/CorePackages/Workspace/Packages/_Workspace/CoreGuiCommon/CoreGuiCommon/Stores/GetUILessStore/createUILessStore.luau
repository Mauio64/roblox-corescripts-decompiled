local UserInputService = game:GetService("UserInputService")

local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/IxpServiceWrapper").IXPServiceWrapper
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect
local logTopBarToggled = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Telemetry").LogTopBarToggled

local defineFastFlag = game:DefineFastFlag("EnableDesktopUILessMode", false)
local defineFastString = game:DefineFastString("AddUILessModeIxpLayer", "")

return function()
	local signal, v5 = createSignal(defineFastFlag and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse)

	local signal2, v6 = createSignal(not signal(false))

	local effect = createEffect(function(p2)
		if signal(false) then
			logTopBarToggled(signal2(p2))
		end
	end)

	local function cleanup()
		effect()
	end

	if signal(false) then
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
	end

	return {
		getUILessModeEnabled = signal,
		getUIVisible = signal2,
		setUIVisible = v6,
		cleanup = cleanup
	}
end
