local parent = script.Parent.Parent

local dependencies = require(parent.dependencies)
local utils = parent.utils
require(parent.type)
local toastNotificationHelper = require(utils.toastNotificationHelper)
local getNearestWholeNumber = toastNotificationHelper.getNearestWholeNumber
local calculateTimeRemaining = toastNotificationHelper.calculateTimeRemaining

local luauPolyfill = dependencies.LuauPolyfill
local react = dependencies.React

local clearInterval = luauPolyfill.clearInterval
local setInterval = luauPolyfill.setInterval

local function useTimeRemainingMap(items, p)
	local _, setState = react.useState(0)
	local result = {}
	local flag = true

	for k, item in pairs(items) do
		local nearestWholeNumber = getNearestWholeNumber(calculateTimeRemaining(
			item,
			p.notificationReceivedTimestampMs,
			p.displayTimestampMs
		) / 1000)

		if nearestWholeNumber > 0 then
			flag = false
		end

		result[k] = math.max(0, nearestWholeNumber)
	end

	react.useEffect(function()
		local v

		if flag then
			v = nil
		else
			v = setInterval(function()
				setState(os.clock())
			end, 100)
		end

		return function()
			if v then
				clearInterval(v)
			end
		end
	end, { flag, setState })

	return result
end

return useTimeRemainingMap
