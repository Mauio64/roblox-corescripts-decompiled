local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local Rodux = require(VirtualEventsState.Parent.Rodux)
local Cryo = require(VirtualEventsState.Parent.Cryo)

require(VirtualEventsState.types)

local VirtualEventModel = require(VirtualEventsState.network).NetworkingVirtualEvents.VirtualEventModel
local logger = require(VirtualEventsState.logger)

return function(p1) -- line: 14
	-- upvalues: Rodux (copy), VirtualEventModel (copy), logger (copy), Cryo (copy)
	return (Rodux.createReducer({}, {
		[p1.GetActiveVirtualEvents.Succeeded.name] = function(_: {[any]: any}, p2) -- line: 16
			-- upvalues: VirtualEventModel (copy), logger (copy)
			local t2 = {}

			for _, v11 in p2.responseBody.data do
				local v12 = VirtualEventModel.fromResponse(v11)

				if v12 then
					if v12.eventTime.startTime and v12.eventTime.endTime then
						t2[v11.id] = v12
					else
						logger:debug("Discarding VirtualEvent with ID {} (malformed start or end time)", v11.id)
					end
				end
			end

			return t2
		end,
		[p1.GetActiveVirtualEvents.Failed.name] = function(_: {[any]: any}, _) -- line: 34
			return {}
		end,
		[p1.GetVirtualEvent.Succeeded.name] = function(t4: {[any]: any}, p4) -- line: 38
			-- upvalues: VirtualEventModel (copy), Cryo (copy)
			local t5 = {}
			local v18 = VirtualEventModel.fromResponse(p4.responseBody)

			if v18 then
				t5[v18.id] = v18
			end

			return Cryo.Dictionary.join(t4, t5)
		end,
		[p1.GetVirtualEvent.Failed.name] = function(t6: {[any]: any}, _) -- line: 49
			return t6
		end,
		[p1.UpdateMyRsvpStatus.Succeeded.name] = function(t7: {[any]: any}, p6) -- line: 53
			-- upvalues: Cryo (copy)
			local v23 = p6.ids[1]
			local v24 = t7[v23]

			if v24 then
				return Cryo.Dictionary.join(t7, {
					[v23] = Cryo.Dictionary.join(v24, {
						userRsvpStatus = p6.postBody.rsvpStatus
					})
				})
			end

			return t7
		end
	}))
end
