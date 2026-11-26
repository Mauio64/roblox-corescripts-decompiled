local module = require("@luauforge/bundled/dDg")

local module2 = require("@luauforge/bundled/dDh")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useSelector = module2.Hooks.RoactRodux.useSelector

require("@luauforge/bundled/dDc")

local module3 = require("@luauforge/bundled/dDu")
local module4 = require("@luauforge/bundled/dDa")

local useRoactService = require("@luauforge/bundled/dDi").useRoactService

local roactNetworking = require("@luauforge/bundled/dDj").RoactNetworking

require("@luauforge/bundled/dDs")

return function(p2)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)

	local v7 = useSelector(function(p3)
		return p2 and module3.GetFetchingStatus(p3, p2) or nil
	end)

	local v8 = useSelector(function(p3)
		return p2 and p3.Personalization[module4.key][p2] or nil
	end)

	local v9 = module.useCallback(function()
		if p2 then
			v5(module3.Fetch(v6, { p2 }))
		end
	end, { v5, v6, p2 })

	module.useEffect(function()
		v9()
	end, { v9 })

	return { fetchStatus = v7, refetchSongDetail = v9, songDetail = v8, songId = p2 }
end
