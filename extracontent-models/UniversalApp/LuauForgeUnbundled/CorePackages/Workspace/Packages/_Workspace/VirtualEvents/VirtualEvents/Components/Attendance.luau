local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/AttendanceCount")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/FacePile")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local function Attendance(p2)
	local experienceDetails = p2.virtualEvent.experienceDetails
	local rsvpCounters = p2.virtualEvent.rsvpCounters

	local v5 = React.useMemo(function()
		local userIds = {}

		if p2.virtualEvent.rsvps then
			for k, rsvp in p2.virtualEvent.rsvps do
				if rsvp.rsvpStatus == "going" then
					table.insert(userIds, (tostring(rsvp.userId)))
				end
			end
		end

		return userIds
	end, { p2.virtualEvent })

	if
		p2.eventStatus == "Ongoing" and experienceDetails and experienceDetails.playing == 0
		or p2.eventStatus ~= "Ongoing" and rsvpCounters and rsvpCounters.going == 0
	then
		return nil
	end

	local createElement = React.createElement
	local v8 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		AttendanceCount = React.createElement(module2, {
			layoutOrder = 1,
			eventStatus = p2.eventStatus,
			interested = not (rsvpCounters and rsvpCounters.going) and 0 or rsvpCounters.going,
			attending = not (experienceDetails and experienceDetails.playing) and 0 or experienceDetails.playing
		}),
		FacePile = 0
	}

	local createElement2 = React.createElement

	local v11 = if Players.LocalPlayer then tostring(Players.LocalPlayer.UserId) else nil
	v8.FacePile = createElement2(module3, {
		layoutOrder = 2,
		userIds = v5,
		desiredFirstUserId = v11
	})
	return createElement("Folder", nil, v8)
end

return Attendance
