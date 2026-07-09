local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local utils = ParentParent.utils

require(ParentParent.type)

local toastNotificationHelper = require(utils.toastNotificationHelper)
local getNearestWholeNumber = toastNotificationHelper.getNearestWholeNumber
local calculateTimeRemaining = toastNotificationHelper.calculateTimeRemaining
local LuauPolyfill = dependencies.LuauPolyfill
local React = dependencies.React
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local function useTimeRemainingMap(t1: {[any]: any}, p1) -- line: 26
	-- upvalues: React (copy), getNearestWholeNumber (copy), calculateTimeRemaining (copy), setInterval (copy), clearInterval (copy)
	local _, v15 = React.useState(0)
	local t2 = {}
	local u17 = true

	for k, v in pairs(t1) do
		local v20 = getNearestWholeNumber(calculateTimeRemaining(v, p1.notificationReceivedTimestampMs, p1.displayTimestampMs) / 1000)

		if v20 > 0 then
			u17 = false
		end

		t2[k] = math.max(0, v20)
	end

	React.useEffect(function() -- line: 43
		-- upvalues: u17 (ref), setInterval (copy), v15 (copy), clearInterval (copy)
		local u21 = nil

		if not u17 then
			u21 = setInterval(function() -- line: 46
				-- upvalues: v15 (copy)
				v15(os.clock())
			end, 100)
		end

		return function() -- line: 51
			-- upvalues: u21 (ref), clearInterval (copy)
			if u21 then
				clearInterval(u21)
			end
		end
	end, {
		u17,
		v15
	})

	return t2
end

return useTimeRemainingMap
