local module = require("@luauforge/bundled/dDg")

local module2 = require("@luauforge/bundled/dDh")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useSelector = module2.Hooks.RoactRodux.useSelector

local module3 = require("@luauforge/bundled/dDA")

local module4 = require("@luauforge/bundled/dDd")

local useRoactService = require("@luauforge/bundled/dDi").useRoactService

local roactNetworking = require("@luauforge/bundled/dDj").RoactNetworking

local toLegacyGameInfoModel = require("@luauforge/bundled/dDB").toLegacyGameInfoModel

local module5 = require("@luauforge/bundled/dDE")

require("@luauforge/bundled/dDc")
require("@luauforge/bundled/dDs")

local v5 = {}

return function(p2)
	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)

	local v8 = useSelector(function(p3)
		return p2 and module3.GetFetchingStatus(p3, p2) or nil
	end)

	local v9 = useSelector(function(p3)
		if p2 then
			return p3.Personalization[module4.key][p2] or v5
		end

		return v5
	end)

	local v10 = module5.useGameInfos(v9)
	local v11 = module.useMemo(function()
		local result = {}

		for k, v12 in v9 do
			local v13 = v10[tostring(v12)]

			if v13 then
				table.insert(result, toLegacyGameInfoModel(v13))
			end
		end

		return result
	end, { v9, v10 })

	local v12 = module.useCallback(function()
		if p2 then
			v6(module3.Fetch(v7, p2))
		end
	end, { v6, v7, p2 })

	module.useEffect(function()
		v12()
	end, { v12 })

	return { fetchStatus = v8, refetchSongExperiences = v12, songExperiences = v11 }
end
