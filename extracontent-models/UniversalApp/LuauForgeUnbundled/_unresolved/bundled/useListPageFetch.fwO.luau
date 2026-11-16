local module = require("@luauforge/bundled/fwD")
local module2 = require("@luauforge/bundled/fwF")

require("@luauforge/bundled/fwJ")
local module3 = require("@luauforge/bundled/fwL")

local sduiLoadTimer = module2.SduiLoadTimer

local function useListPageFetch(p2, p3, p4)
	local v5 = module.useMemo(function()
		if p3 == "VIEW_ALL" then
			return nil
		end

		local loadTimer = sduiLoadTimer.createLoadTimer(p4)
		loadTimer.start("mount")
		return loadTimer
	end, { p3, p4 })

	module.useEffect(function()
		if v5 then
			module3(p2, p3, v5)
		end
	end, { p2, p3, v5 })

	return v5
end

return useListPageFetch
