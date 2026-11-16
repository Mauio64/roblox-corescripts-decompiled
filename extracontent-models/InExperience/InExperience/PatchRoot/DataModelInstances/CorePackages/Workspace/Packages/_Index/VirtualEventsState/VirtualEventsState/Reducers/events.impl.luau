local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local Rodux = require(VirtualEventsState.Parent.Rodux)
local Cryo = require(VirtualEventsState.Parent.Cryo)
require(VirtualEventsState.types)
local network = require(VirtualEventsState.network)
local virtualEventModel = network.NetworkingVirtualEvents.VirtualEventModel
local logger = require(VirtualEventsState.logger)

return function(data)
	return (Rodux.createReducer({}, {
		[data.GetActiveVirtualEvents.Succeeded.name] = function(_, p)
			local result = {}

			for _, v in p.responseBody.data do
				local v2 = virtualEventModel.fromResponse(v)

				if not v2 then
					continue
				end

				if v2.eventTime.startTime and v2.eventTime.endTime then
					result[v.id] = v2
				else
					logger:debug("Discarding VirtualEvent with ID {} (malformed start or end time)", v.id)
				end
			end

			return result
		end,
		[data.GetActiveVirtualEvents.Failed.name] = function(_, _)
			return {}
		end,
		[data.GetVirtualEvent.Succeeded.name] = function(p, p2)
			local v = {}
			local v2 = virtualEventModel.fromResponse(p2.responseBody)

			if v2 then
				v[v2.id] = v2
			end

			return Cryo.Dictionary.join(p, v)
		end,
		[data.GetVirtualEvent.Failed.name] = function(p, _)
			return p
		end,
		[data.UpdateMyRsvpStatus.Succeeded.name] = function(p, p2)
			local id = p2.ids[1]
			local v = p[id]

			if v then
				return Cryo.Dictionary.join(p, {
					[id] = Cryo.Dictionary.join(v, { userRsvpStatus = p2.postBody.rsvpStatus })
				})
			end

			return p
		end
	}))
end
