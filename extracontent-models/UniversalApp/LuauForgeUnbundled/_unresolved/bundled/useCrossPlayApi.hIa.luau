local module = require("@luauforge/bundled/hHX")
local useDispatch = require("@luauforge/bundled/hHZ").Hooks.RoactRodux.useDispatch
local linkingProtocol = require("@luauforge/bundled/hIb").LinkingProtocol
local useAppPolicy = require("@luauforge/bundled/hIc").useAppPolicy
local getUserSettingsPlatform = require("@luauforge/bundled/hId").thunks.GetUserSettingsPlatform
local updateUserSettingsPlatform = require("@luauforge/bundled/hId").thunks.UpdateUserSettingsPlatform
local module2 = require("@luauforge/bundled/hIl")
local module3 = require("@luauforge/bundled/hIn")
local module4 = require("@luauforge/bundled/hIo")
local module5 = require("@luauforge/bundled/hIp")
local module6 = require("@luauforge/bundled/hIq")
local module7 = require("@luauforge/bundled/hIr")
local module8 = require("@luauforge/bundled/hIs")
local module9 = require("@luauforge/bundled/hIu")
local module10 = require("@luauforge/bundled/hIv")

local function useCrossPlayApi()
	local v5 = useAppPolicy(function(p2)
		return p2.useLegacyCrossPlayApi()
	end)

	local v6 = useAppPolicy(function(p2)
		return p2.useCrossPlaySystemUi()
	end)

	local v7 = useAppPolicy(function(p2)
		return p2.getCrossPlayUri()
	end)

	local v8 = useAppPolicy(function(p2)
		return p2.getCrossPlayCapabilities()
	end)

	local v9 = useAppPolicy(function(p2)
		return p2.getCrossPlaySettingsKey()
	end)

	local v10 = useAppPolicy(function(p2)
		return p2.getCrossPlayQueryParam()
	end)

	local v11 = useDispatch()

	local v12 = module.useCallback(function()
		return v11(getUserSettingsPlatform.API(v10, v9, v5))
	end, { v11, v10, v9, v5 })

	local v13 = module.useCallback(function(p2)
		return v11(updateUserSettingsPlatform.API(v10, v9, p2, v5))
	end, { v11, v10, v9, v5 })

	local v14 = module.useCallback(function(p2)
		v11(module9())

		return module10(v8):andThen(function(p3)
			v11(module6(p3))

			if p3.CrossPlatform.CanJoinGame == p2 then
				return
			end

			return v13(p3.CrossPlatform.CanJoinGame):catch(function(p4)
				v11(module4(p4))
			end)
		end):catch(function(p3)
			v11(module7(p3))
		end)
	end, { v11, v8, v13 })

	local v15 = module.useCallback(function()
		return v12():andThen(function(p2)
			if v6 then
				return v14(p2.responseBody[v9].isEnabled)
			end

			module10(v8):andThen(function(p3)
				v11(module8(p3))
			end)
		end):catch(function(p2)
			v11(module2(p2))
		end)
	end, { v11, v9, v14, v12, v6 })

	local v16 = module.useCallback(function()
		if v6 and v7 then
			linkingProtocol.default:openURL(v7)
		end
	end, { v6, v7 })

	local v17 = module.useCallback(function(p2)
		if v6 then
			v16()
		else
			v11(module5(p2))

			return v13(p2):andThen(function()
				v15()
			end):catch(function(p3)
				v11(module4(p3))
			end)
		end
	end, { v11, v13, v15, v16 })

	local v18 = module.useCallback(function()
		v11(module3())
	end, { v11 })

	return (module.useMemo(function()
		return { fetch = v15, reset = v18, update = v17, invokeSystemUi = v16 }
	end, { v15, v18, v17, v16 }))
end

return useCrossPlayApi
