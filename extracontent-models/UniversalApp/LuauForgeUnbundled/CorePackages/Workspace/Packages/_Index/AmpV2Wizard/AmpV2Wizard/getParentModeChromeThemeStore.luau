local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Signals")

local function createParentModeChromeThemeStore()
	local signal, v5 = Signals.createSignal(false)
	return { getIsActive = signal, setIsActive = v5 }
end

return Signals.createComputed(createParentModeChromeThemeStore)
