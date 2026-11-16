local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Cryo")
require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/types")
local virtualEventModel = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/network").NetworkingVirtualEvents.VirtualEventModel
local logger = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/logger")

return function(data)
	return (Rodux.createReducer({}, {
		[data.GetActiveVirtualEvents.Succeeded.name] = function(p2, p3)
			local result = {}

			for k, v6 in p3.responseBody.data do
				local v7 = virtualEventModel.fromResponse(v6)

				if not v7 then
					continue
				end

				if v7.eventTime.startTime and v7.eventTime.endTime then
					result[v6.id] = v7
				else
					logger:debug("Discarding VirtualEvent with ID {} (malformed start or end time)", v6.id)
				end
			end

			return result
		end,
		[data.GetActiveVirtualEvents.Failed.name] = function(p2, p3)
			return {}
		end,
		[data.GetVirtualEvent.Succeeded.name] = function(p2, p3)
			local v6 = {}
			local v7 = virtualEventModel.fromResponse(p3.responseBody)

			if v7 then
				v6[v7.id] = v7
			end

			return Cryo.Dictionary.join(p2, v6)
		end,
		[data.GetVirtualEvent.Failed.name] = function(p2, p3)
			return p2
		end,
		[data.UpdateMyRsvpStatus.Succeeded.name] = function(p2, p3)
			local id = p3.ids[1]
			local v6 = p2[id]

			if v6 then
				return Cryo.Dictionary.join(p2, {
					[id] = Cryo.Dictionary.join(v6, {
						userRsvpStatus = p3.postBody.rsvpStatus
					})
				})
			end

			return p2
		end
	}))
end
