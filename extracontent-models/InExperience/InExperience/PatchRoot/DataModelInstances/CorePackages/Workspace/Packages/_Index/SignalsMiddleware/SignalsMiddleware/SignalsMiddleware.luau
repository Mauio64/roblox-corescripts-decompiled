local parent = script.Parent.Parent
local SignalsExperimental = require(parent.SignalsExperimental)
local SharedFlags = require(parent.SharedFlags)
local ActionHandlers = require(script.Parent.ActionHandlers)

local FFlagSignalsRegistryOwnedFanout = SharedFlags.FFlagSignalsRegistryOwnedFanout

local function createSignalsMiddleware(p)
	return function(callback, _)
		return function(p2)
			if FFlagSignalsRegistryOwnedFanout then
				local v = nil
				SignalsExperimental.batch(function()
					ActionHandlers.handleAction(p, p2)

					v = callback(p2)
				end)
				return v
			else
				local v = p[p2.type]

				if v and #v > 0 then
					SignalsExperimental.batch(function()
						local v2 = true

						for _, v3 in v do
							v2 = v3(p2) and v2
						end

						if v2 then
							return nil
						end

						return callback(p2)
					end)

					return nil
				end

				return callback(p2)
			end
		end
	end
end

return createSignalsMiddleware
