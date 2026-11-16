local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local Players = game:GetService("Players")

require(VirtualEvents.Parent.GraphQLServer)
local React = require(VirtualEvents.Parent.React)
local AttendanceCount = require(VirtualEvents.Components.AttendanceCount)
local FacePile = require(VirtualEvents.Components.FacePile)
require(VirtualEvents.Parent.VirtualEventsState)

local function Attendance(p)
	local experienceDetails = p.virtualEvent.experienceDetails
	local rsvpCounters = p.virtualEvent.rsvpCounters

	local userIds = React.useMemo(function()
		local userIds = {}

		if p.virtualEvent.rsvps then
			for _, rsvp in p.virtualEvent.rsvps do
				if rsvp.rsvpStatus == "going" then
					table.insert(userIds, (tostring(rsvp.userId)))
				end
			end
		end

		return userIds
	end, { p.virtualEvent })

	if
		p.eventStatus == "Ongoing" and experienceDetails and experienceDetails.playing == 0
		or p.eventStatus ~= "Ongoing" and rsvpCounters and rsvpCounters.going == 0
	then
		return nil
	end

	local createElement = React.createElement
	local v = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		AttendanceCount = React.createElement(AttendanceCount, {
			layoutOrder = 1,
			eventStatus = p.eventStatus,
			interested = not (rsvpCounters and rsvpCounters.going) and 0 or rsvpCounters.going,
			attending = not (experienceDetails and experienceDetails.playing) and 0 or experienceDetails.playing
		}),
		FacePile = 0
	}

	local createElement2 = React.createElement
	local desiredFirstUserId

	if Players.LocalPlayer then
		desiredFirstUserId = tostring(Players.LocalPlayer.UserId)
	end

	v.FacePile = createElement2(FacePile, {
		layoutOrder = 2,
		userIds = userIds,
		desiredFirstUserId = desiredFirstUserId
	})
	return createElement("Folder", nil, v)
end

return Attendance
