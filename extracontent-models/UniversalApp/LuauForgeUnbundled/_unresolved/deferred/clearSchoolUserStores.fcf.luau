local module = require("@luauforge/deferred/ekB")
local module2 = require("@luauforge/deferred/fcg")
local module3 = require("@luauforge/deferred/fcl")

local function clearSchoolUserStores()
	module(false).clear()

	if module3 then
		module2(false).clear()
	end
end

return clearSchoolUserStores
