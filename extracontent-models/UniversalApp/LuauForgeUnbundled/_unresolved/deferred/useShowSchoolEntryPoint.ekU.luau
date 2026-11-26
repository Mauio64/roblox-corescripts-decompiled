local dataStatus = require("@luauforge/deferred/ekt").DataStatus

local module = require("@luauforge/deferred/ekS")
local module2 = require("@luauforge/deferred/ekx")

local function useShowSchoolEntryPoint()
	local v5 = module()
	local v6 = module2(v5 == true)

	if v5 ~= true then
		return v5
	end

	if v6.status == dataStatus.NotReady then
		return nil
	end

	return v6.status == dataStatus.Ready and v6.school ~= nil
end

return useShowSchoolEntryPoint
