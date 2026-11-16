local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local Rodux = require(VirtualEventsState.Parent.Rodux)
local Cryo = require(VirtualEventsState.Parent.Cryo)
require(VirtualEventsState.Parent.NetworkingVirtualEvents)

return function(data, p)
	local reducer = Rodux.createReducer({ nextPageCursor = nil, prevPageCursor = nil }, {
		[data.GetVirtualEventRsvps.Succeeded.name] = function(_, p2)
			return {
				nextPageCursor = p2.responseBody.nextPageCursor,
				prevPageCursor = p2.responseBody.prevPageCursor
			}
		end
	})

	local reducer2 = Rodux.createReducer({}, {
		[data.GetVirtualEventRsvpCounts.Succeeded.name] = function(p2, p3)
			local id = p3.ids[1]

			return Cryo.Dictionary.join(p2, { [id] = p3.responseBody.counters })
		end,
		[data.GetVirtualEventRsvpCounts.Failed.name] = function(p2, _)
			return p2
		end,
		[data.UpdateMyRsvpStatus.Succeeded.name] = function(p2, p3)
			local id = p3.ids[1]
			local v = p2[id]

			if not v then
				return p2
			end

			local rsvpStatus = p3.postBody.rsvpStatus

			local v2 = rsvpStatus == "going" and 1 or rsvpStatus == "notGoing" and -1 or 0

			return Cryo.Dictionary.join(p2, {
				[id] = Cryo.Dictionary.join(v, {
					going = math.clamp(v.going + v2, 0, 1e999)
				})
			})
		end,
		[data.UpdateMyRsvpStatus.Failed.name] = function(p2, _)
			return p2
		end
	})

	local reducer3 = Rodux.createReducer({}, {
		[data.GetVirtualEventRsvps.Succeeded.name] = function(p2, p3)
			local id = p3.ids[1]

			local v = {}

			for _, v2 in p3.responseBody.data do
				v[tostring(v2.userId)] = v2
			end

			return Cryo.Dictionary.join(p2, {
				[id] = Cryo.Dictionary.join(p2[id] or {}, v)
			})
		end,
		[data.GetVirtualEventRsvps.Failed.name] = function(p2, _)
			return p2
		end,
		[data.UpdateMyRsvpStatus.Succeeded.name] = function(p2, p3)
			local id = p3.ids[1]
			local userId = not p.LocalPlayer and -1 or p.LocalPlayer.UserId

			local v = {
				[tostring(userId)] = { userId = userId, rsvpStatus = p3.postBody.rsvpStatus }
			}

			return Cryo.Dictionary.join(p2, {
				[id] = Cryo.Dictionary.join(p2[id] or {}, v)
			})
		end,
		[data.UpdateMyRsvpStatus.Failed.name] = function(p2, _)
			return p2
		end
	})

	return (Rodux.combineReducers({
		page = reducer,
		counters = reducer2,
		byVirtualEventId = reducer3
	}))
end
