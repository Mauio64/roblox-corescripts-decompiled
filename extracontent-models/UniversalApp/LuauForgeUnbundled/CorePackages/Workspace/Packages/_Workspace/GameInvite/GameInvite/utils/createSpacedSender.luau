local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Promise")

return function(data)
	local v5 = 0

	return {
		send = function(p2)
			return Promise.new(function(p3, p4)
				local now = data.now()
				local v6 = math.max(now, v5)
				v5 = v6 + data.minIntervalSeconds

				local function dispatch()
					Promise.try(p2):andThen(p3, p4)
				end

				local v7 = v6 - now

				if v7 <= 0 then
					Promise.try(p2):andThen(p3, p4)
				else
					data.delay(v7, dispatch)
				end
			end)
		end,
		options = data
	}
end
