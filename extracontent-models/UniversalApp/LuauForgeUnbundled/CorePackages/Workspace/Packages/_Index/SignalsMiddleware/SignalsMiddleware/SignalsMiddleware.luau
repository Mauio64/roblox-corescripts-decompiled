local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/SignalsMiddleware/SignalsExperimental")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SignalsMiddleware/SharedFlags")
local ActionHandlers = require("@game/CorePackages/Workspace/Packages/_Index/SignalsMiddleware/SignalsMiddleware/ActionHandlers")

local fFlagSignalsRegistryOwnedFanout = SharedFlags.FFlagSignalsRegistryOwnedFanout

local function createSignalsMiddleware(p2)
	return function(callback, p3)
		return function(p4)
			if fFlagSignalsRegistryOwnedFanout then
				local v5 = nil
				SignalsExperimental.batch(function()
					ActionHandlers.handleAction(p2, p4)

					v5 = callback(p4)
				end)
				return v5
			else
				local v5 = p2[p4.type]

				if v5 and #v5 > 0 then
					SignalsExperimental.batch(function()
						local v6 = true

						for k, v7 in v5 do
							v6 = v7(p4) and v6
						end

						if v6 then
							return nil
						end

						return callback(p4)
					end)

					return nil
				end

				return callback(p4)
			end
		end
	end
end

return createSignalsMiddleware
