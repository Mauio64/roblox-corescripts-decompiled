local UserInputService = game:GetService("UserInputService")
local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local CoreGuiCommonParent = CoreGuiCommon.Parent
local IXPServiceWrapper = require(CoreGuiCommonParent.IXPServiceWrapper).IXPServiceWrapper
local Signals = require(CoreGuiCommonParent.Signals)
local createSignal = Signals.createSignal
local createEffect = Signals.createEffect
local LogTopBarToggled = require(CoreGuiCommon.Telemetry).LogTopBarToggled
local v9 = game:DefineFastFlag("EnableDesktopUILessMode", false)
local v10 = game:DefineFastString("AddUILessModeIxpLayer", "")

return function() -- line: 25
	-- upvalues: createSignal (copy), v9 (copy), UserInputService (copy), createEffect (copy), LogTopBarToggled (copy), IXPServiceWrapper (copy), v10 (copy)
	local v11, _ = createSignal(v9 and UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse)
	local v13, v14 = createSignal(not v11(false))
	local v15 = createEffect(function(p1) -- line: 31
		-- upvalues: v11 (copy), LogTopBarToggled (copy), v13 (copy)
		if v11(false) then
			LogTopBarToggled(v13(p1))
		end
	end)

	if v11(false) then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v10)
	end

	return {
		getUILessModeEnabled = v11,
		getUIVisible = v13,
		setUIVisible = v14,
		cleanup = function() -- line: 37
			-- upvalues: v15 (copy)
			v15()
		end
	}
end
