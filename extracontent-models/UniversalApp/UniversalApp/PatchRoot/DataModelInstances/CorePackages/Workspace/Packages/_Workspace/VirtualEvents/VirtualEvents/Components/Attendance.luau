local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Players = game:GetService("Players")

require(VirtualEvents.Parent.GraphQLServer)

local React = require(VirtualEvents.Parent.React)
local AttendanceCount = require(VirtualEvents.Components.AttendanceCount)
local FacePile = require(VirtualEvents.Components.FacePile)

require(VirtualEvents.Parent.VirtualEventsState)

local function Attendance(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), AttendanceCount (copy), FacePile (copy), Players (copy)
	local experienceDetails = t1.virtualEvent.experienceDetails
	local rsvpCounters = t1.virtualEvent.rsvpCounters
	local v10 = React.useMemo(function() -- line: 20
		-- upvalues: t1 (copy)
		local t2 = {}

		if t1.virtualEvent.rsvps then
			for _, v13 in t1.virtualEvent.rsvps do
				if v13.rsvpStatus == "going" then
					table.insert(t2, (tostring(v13.userId)))
				end
			end
		end

		return t2
	end, { t1.virtualEvent })

	if t1.eventStatus == "Ongoing" and (experienceDetails and experienceDetails.playing == 0) or t1.eventStatus ~= "Ongoing" and rsvpCounters and rsvpCounters.going == 0 then
		return nil
	end

	return React.createElement("Folder", nil, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		AttendanceCount = React.createElement(AttendanceCount, {
			layoutOrder = 1,
			eventStatus = t1.eventStatus,
			interested = (not rsvpCounters or not rsvpCounters.going) and 0 or rsvpCounters.going,
			attending = (not experienceDetails or not experienceDetails.playing) and 0 or experienceDetails.playing
		}),
		FacePile = React.createElement(FacePile, {
			layoutOrder = 2,
			userIds = v10,
			desiredFirstUserId = if not Players.LocalPlayer then nil else tostring(Players.LocalPlayer.UserId)
		})
	})
end

return Attendance
