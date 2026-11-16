local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")

require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local toastNotificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationHelper")
local getNearestWholeNumber = toastNotificationHelper.getNearestWholeNumber
local calculateTimeRemaining = toastNotificationHelper.calculateTimeRemaining

local luauPolyfill = dependencies.LuauPolyfill
local react = dependencies.React

local clearInterval = luauPolyfill.clearInterval
local setInterval = luauPolyfill.setInterval

local function useTimeRemainingMap(items, p2)
	local state, setState = react.useState(0)
	local result = {}
	local flag = true

	for k, item in pairs(items) do
		local nearestWholeNumber = getNearestWholeNumber(calculateTimeRemaining(
			item,
			p2.notificationReceivedTimestampMs,
			p2.displayTimestampMs
		) / 1000)

		if nearestWholeNumber > 0 then
			flag = false
		end

		result[k] = math.max(0, nearestWholeNumber)
	end

	react.useEffect(function()
		local v5

		if flag then
			v5 = nil
		else
			v5 = setInterval(function()
				setState(os.clock())
			end, 100)
		end

		return function()
			if v5 then
				clearInterval(v5)
			end
		end
	end, { flag, setState })

	return result
end

return useTimeRemainingMap
