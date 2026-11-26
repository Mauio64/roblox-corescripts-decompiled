local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/NetworkingVirtualEvents")

return function(data, p2)
	local reducer = Rodux.createReducer({ nextPageCursor = nil, prevPageCursor = nil }, {
		[data.GetVirtualEventRsvps.Succeeded.name] = function(p3, p4)
			return {
				nextPageCursor = p4.responseBody.nextPageCursor,
				prevPageCursor = p4.responseBody.prevPageCursor
			}
		end
	})

	local reducer2 = Rodux.createReducer({}, {
		[data.GetVirtualEventRsvpCounts.Succeeded.name] = function(p3, p4)
			local id = p4.ids[1]

			return Cryo.Dictionary.join(p3, { [id] = p4.responseBody.counters })
		end,
		[data.GetVirtualEventRsvpCounts.Failed.name] = function(p3, p4)
			return p3
		end,
		[data.UpdateMyRsvpStatus.Succeeded.name] = function(p3, p4)
			local id = p4.ids[1]
			local v7 = p3[id]

			if not v7 then
				return p3
			end

			local rsvpStatus = p4.postBody.rsvpStatus

			local v8 = rsvpStatus == "going" and 1 or rsvpStatus == "notGoing" and -1 or 0

			return Cryo.Dictionary.join(p3, {
				[id] = Cryo.Dictionary.join(v7, {
					going = math.clamp(v7.going + v8, 0, 1e999)
				})
			})
		end,
		[data.UpdateMyRsvpStatus.Failed.name] = function(p3, p4)
			return p3
		end
	})

	local reducer3 = Rodux.createReducer({}, {
		[data.GetVirtualEventRsvps.Succeeded.name] = function(p3, p4)
			local id = p4.ids[1]

			local v8 = {}

			for k, v9 in p4.responseBody.data do
				v8[tostring(v9.userId)] = v9
			end

			return Cryo.Dictionary.join(p3, {
				[id] = Cryo.Dictionary.join(p3[id] or {}, v8)
			})
		end,
		[data.GetVirtualEventRsvps.Failed.name] = function(p3, p4)
			return p3
		end,
		[data.UpdateMyRsvpStatus.Succeeded.name] = function(p3, p4)
			local id = p4.ids[1]
			local v8 = not p2.LocalPlayer and -1 or p2.LocalPlayer.UserId

			local v9 = {
				[tostring(v8)] = { userId = v8, rsvpStatus = p4.postBody.rsvpStatus }
			}

			return Cryo.Dictionary.join(p3, {
				[id] = Cryo.Dictionary.join(p3[id] or {}, v9)
			})
		end,
		[data.UpdateMyRsvpStatus.Failed.name] = function(p3, p4)
			return p3
		end
	})

	return (Rodux.combineReducers({
		page = reducer,
		counters = reducer2,
		byVirtualEventId = reducer3
	}))
end
