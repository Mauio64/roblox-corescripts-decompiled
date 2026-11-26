local module = require("@luauforge/deferred/gNV")
local mutedError = require("@luauforge/deferred/gNT").mutedError

local module2 = require("@luauforge/deferred/gNR")

local context = module.createContext(nil)

local function FoldersStoreProvider(p2)
	local v5 = module.useMemo(function()
		return module2()
	end, {})

	module.useEffect(function()
		return function()
			v5.cleanup()
		end
	end, { v5 })

	return module.createElement(context.Provider, { value = v5 }, p2.children)
end

return {
	Context = context,
	Provider = FoldersStoreProvider,
	useFoldersStore = function()
		local v5 = module.useContext(context)

		if v5 ~= nil then
			return v5
		end

		mutedError("useFoldersStore must be used within a FoldersStoreProvider")
		return module2()
	end
}
