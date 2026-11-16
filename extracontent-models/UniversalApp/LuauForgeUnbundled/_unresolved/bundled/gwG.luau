local module = require("@luauforge/bundled/gwH")

local function createParentModeChromeThemeStore()
	local signal, v5 = module.createSignal(false)
	return { getIsActive = signal, setIsActive = v5 }
end

return module.createComputed(createParentModeChromeThemeStore)
