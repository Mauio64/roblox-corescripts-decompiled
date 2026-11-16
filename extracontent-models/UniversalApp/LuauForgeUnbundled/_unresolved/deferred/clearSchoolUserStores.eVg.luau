local module = require("@luauforge/deferred/ehh")
local module2 = require("@luauforge/deferred/eVh")
local module3 = require("@luauforge/deferred/eVm")

local function clearSchoolUserStores()
	module(false).clear()

	if module3 then
		module2(false).clear()
	end
end

return clearSchoolUserStores
