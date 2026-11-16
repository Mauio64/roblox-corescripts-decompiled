local UserInputService = game:GetService("UserInputService")

local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local parent = CoreGuiCommon.Parent
local IXPServiceWrapper = require(parent.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect
local Telemetry = require(CoreGuiCommon.Telemetry)
local LogTopBarToggled = Telemetry.LogTopBarToggled

local defineFastFlag = game:DefineFastFlag("EnableDesktopUILessMode", false)
local defineFastString = game:DefineFastString("AddUILessModeIxpLayer", "")

return function()
	local signal, _ = createSignal(defineFastFlag and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse)

	local signal2, setUIVisible = createSignal(not signal(false))

	local effect = createEffect(function(p)
		if signal(false) then
			LogTopBarToggled(signal2(p))
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
		setUIVisible = setUIVisible,
		cleanup = cleanup
	}
end
