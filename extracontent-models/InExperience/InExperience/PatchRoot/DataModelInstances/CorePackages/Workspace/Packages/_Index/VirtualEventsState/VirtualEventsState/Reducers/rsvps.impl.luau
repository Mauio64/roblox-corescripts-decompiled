local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local Rodux = require(VirtualEventsState.Parent.Rodux)
local Cryo = require(VirtualEventsState.Parent.Cryo)

require(VirtualEventsState.Parent.NetworkingVirtualEvents)

return function(p1, p2) -- line: 31
	-- upvalues: Rodux (copy), Cryo (copy)
	local v6 = Rodux.createReducer({
		nextPageCursor = nil,
		prevPageCursor = nil
	}, {
		[p1.GetVirtualEventRsvps.Succeeded.name] = function(_: {[any]: any}, p3) -- line: 36
			return {
				nextPageCursor = p3.responseBody.nextPageCursor,
				prevPageCursor = p3.responseBody.prevPageCursor
			}
		end
	})
	local v7 = Rodux.createReducer({}, {
		[p1.GetVirtualEventRsvpCounts.Succeeded.name] = function(t2: {[any]: any}, p4) -- line: 45
			-- upvalues: Cryo (copy)
			local v13 = p4.ids[1]

			return Cryo.Dictionary.join(t2, {
				[v13] = p4.responseBody.counters
			})
		end,
		[p1.GetVirtualEventRsvpCounts.Failed.name] = function(t3: {[any]: any}, _) -- line: 53
			return t3
		end,
		[p1.UpdateMyRsvpStatus.Succeeded.name] = function(t4: {[any]: any}, p6) -- line: 57
			-- upvalues: Cryo (copy)
			local v18 = p6.ids[1]
			local v19 = t4[v18]

			if v19 then
				local rsvpStatus = p6.postBody.rsvpStatus
				local n1 = 0

				if rsvpStatus == "going" then
					n1 = 1
				elseif rsvpStatus == "notGoing" then
					n1 = -1
				end

				return Cryo.Dictionary.join(t4, {
					[v18] = Cryo.Dictionary.join(v19, {
						going = math.clamp(v19.going + n1, 0, 1e999)
					})
				})
			end

			return t4
		end,
		[p1.UpdateMyRsvpStatus.Failed.name] = function(t5: {[any]: any}, _) -- line: 88
			return t5
		end
	})
	local v8 = Rodux.createReducer({}, {
		[p1.GetVirtualEventRsvps.Succeeded.name] = function(t6: {[any]: any}, p8) -- line: 94
			-- upvalues: Cryo (copy)
			local v26 = p8.ids[1]
			local t7 = {}

			for _, v29 in p8.responseBody.data do
				t7[tostring(v29.userId)] = v29
			end

			return Cryo.Dictionary.join(t6, {
				[v26] = Cryo.Dictionary.join(t6[v26] or {}, t7)
			})
		end,
		[p1.GetVirtualEventRsvps.Failed.name] = function(t8: {[any]: any}, _) -- line: 107
			return t8
		end,
		[p1.UpdateMyRsvpStatus.Succeeded.name] = function(t9: {[any]: any}, p10) -- line: 111
			-- upvalues: p2 (copy), Cryo (copy)
			local v34 = p10.ids[1]
			local v35 = not p2.LocalPlayer and -1 or p2.LocalPlayer.UserId
			local t10 = {
				[tostring(v35)] = {
					userId = v35,
					rsvpStatus = p10.postBody.rsvpStatus
				}
			}

			return Cryo.Dictionary.join(t9, {
				[v34] = Cryo.Dictionary.join(t9[v34] or {}, t10)
			})
		end,
		[p1.UpdateMyRsvpStatus.Failed.name] = function(t11: {[any]: any}, _) -- line: 127
			return t11
		end
	})

	return (Rodux.combineReducers({
		page = v6,
		counters = v7,
		byVirtualEventId = v8
	}))
end
