local module = require("@luauforge/bundled/hHX")
local module2 = require("@luauforge/bundled/hHY")
local useSelector = require("@luauforge/bundled/hHZ").Hooks.RoactRodux.useSelector
local module3 = require("@luauforge/bundled/hIa")
local networkStatus = require("@luauforge/bundled/hId").roduxNetworking.Enum.NetworkStatus
local module4 = require("@luauforge/bundled/hIz")

local function useCrossPlaySettings()
	local v5 = module3()
	local v6 = useSelector(module4)
	local v7 = useSelector(function(p2): boolean
		local values = module2.Dictionary.values(p2.CrossPlaySettings.NetworkStatus)

		return module2.List.find(values, networkStatus.Fetching) ~= nil
	end)

	local v8 = useSelector(function(p2)
		return p2.CrossPlaySettings.HttpError
	end)

	local v9 = useSelector(function(p2)
		return p2.CrossPlaySettings.DispatchError
	end)

	local v10 = useSelector(function(p2)
		return p2.CrossPlaySettings.SystemError
	end)
	local v11 = v8 or v9 or v10
	return {
		isEnabled = v6,
		systemPrivileges = useSelector(function(p2)
			return p2.CrossPlaySettings.SystemPrivileges
		end),
		hasError = v11 ~= nil,
		isLoading = v7 and not v11,
		toggle = module.useCallback(function()
			return v5.update(not v6)
		end, { v5.update, v6 }),
		reload = v5.fetch,
		invokeSystemUi = v5.invokeSystemUi
	}
end

return useCrossPlaySettings
