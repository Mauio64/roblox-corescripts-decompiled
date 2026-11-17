local parent = script:FindFirstAncestor("AmpV2Wizard").Parent

local Signals = require(parent.Signals)

local function createParentModeChromeThemeStore()
	local signal, setIsActive = Signals.createSignal(false)
	return { getIsActive = signal, setIsActive = setIsActive }
end

return Signals.createComputed(createParentModeChromeThemeStore)
