local module = require("@luauforge/bundled/ibe")

local module2 = require("@luauforge/bundled/ibd")

local function useSupportOverlayMonolithDependencies()
	local v5 = module.useContext(module2)
	assert(
		v5,
		"useSupportOverlayMonolithDependencies must be used within a SupportOverlayMonolithDependenciesContext.Provider"
	)

	return v5
end

return useSupportOverlayMonolithDependencies
