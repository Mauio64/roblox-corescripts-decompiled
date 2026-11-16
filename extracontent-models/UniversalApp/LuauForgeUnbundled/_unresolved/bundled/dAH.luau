local module = require("@luauforge/bundled/dAI")
local module2 = require("@luauforge/bundled/dAJ")
local useDispatch = module2.Hooks.RoactRodux.useDispatch
local useSelector = module2.Hooks.RoactRodux.useSelector

local useRoactService = require("@luauforge/bundled/dAK").useRoactService

local roactNetworking = require("@luauforge/bundled/dAL").RoactNetworking

local module3 = require("@luauforge/bundled/dAM")
local module4 = require("@luauforge/bundled/dAD")

return function(p2)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)

	local v7 = useSelector(function(p3)
		return p3.Personalization[module4.key] and p3.Personalization[module4.key][p2] or {}
	end)

	module.useEffect(function()
		v5(module3.Fetch(v6, p2))
	end, { v5, v6, p2 })

	return { songIds = v7 }
end
