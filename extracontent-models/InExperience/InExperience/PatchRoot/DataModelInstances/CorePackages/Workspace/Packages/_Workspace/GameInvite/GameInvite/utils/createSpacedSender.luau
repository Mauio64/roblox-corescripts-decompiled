local parent = script:FindFirstAncestor("GameInvite").Parent

local Promise = require(parent.Promise)

return function(options)
	local v = 0

	return {
		send = function(callback)
			return Promise.new(function(p, p2)
				local now = options.now()
				local v2 = math.max(now, v)
				v = v2 + options.minIntervalSeconds

				local function dispatch() -- 1 equivalent call inferred from this helper
					Promise.try(callback):andThen(p, p2)
				end

				local v3 = v2 - now

				if v3 <= 0 then
					dispatch() -- inferred equivalent call
				else
					options.delay(v3, dispatch)
				end
			end)
		end,
		options = options
	}
end
