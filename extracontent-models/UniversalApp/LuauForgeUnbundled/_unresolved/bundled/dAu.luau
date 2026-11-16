local module = require("@luauforge/bundled/dAb")

local module2 = require("@luauforge/bundled/dAc")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useSelector = module2.Hooks.RoactRodux.useSelector

local module3 = require("@luauforge/bundled/dAv")

local module4 = require("@luauforge/bundled/dzY")

local useRoactService = require("@luauforge/bundled/dAd").useRoactService

local roactNetworking = require("@luauforge/bundled/dAe").RoactNetworking

local module5 = require("@luauforge/bundled/dAw")
local gameInfosReducer = module5.GameInfosReducer
local toLegacyGameInfoModel = module5.toLegacyGameInfoModel

local module6 = require("@luauforge/bundled/dAz")
local fFlagMigrateGameInfoToStore = require("@luauforge/bundled/dAm").FFlagMigrateGameInfoToStore

require("@luauforge/bundled/dzX")
require("@luauforge/bundled/dAn")

local v5 = {}

return function(p2)
	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)

	local v8 = useSelector(function(p3)
		return p2 and module3.GetFetchingStatus(p3, p2) or nil
	end)
	local v9

	if fFlagMigrateGameInfoToStore then
		local v10 = useSelector(function(p3)
			if p2 then
				return p3.Personalization[module4.key][p2] or v5
			end

			return v5
		end)

		local v11 = module6.useGameInfos(v10)
		v9 = module.useMemo(function()
			local result = {}

			for k, v12 in v10 do
				local v13 = v11[tostring(v12)]

				if v13 then
					table.insert(result, toLegacyGameInfoModel(v13))
				end
			end

			return result
		end, { v10, v11 })
	else
		v9 = useSelector(function(p3)
			if not p2 then
				return {}
			end

			local v10 = p3.Personalization[module4.key][p2]

			if not v10 then
				return {}
			end

			local result = {}

			for k, v11 in v10 do
				local v12 = p3.Personalization[gameInfosReducer.key][v11]

				if v12 then
					table.insert(result, v12)
				end
			end

			return result
		end)
	end

	local v10 = module.useCallback(function()
		if p2 then
			v6(module3.Fetch(v7, p2))
		end
	end, { v6, v7, p2 })

	module.useEffect(function()
		v10()
	end, { v10 })

	return { fetchStatus = v8, refetchSongExperiences = v10, songExperiences = v9 }
end
