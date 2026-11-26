local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventSocialProof")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local formatNumberWithShortUnits = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/formatNumberWithShortUnits")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function AttendanceChip(p2)
	local v5 = useTokens()
	local v6 = useLocalization({
		interested = "Feature.VirtualEvents.AttendanceBeforeEvent",
		attendingNow = "Feature.VirtualEvents.AttendanceDuringEvent"
	})

	local experienceDetails = p2.virtualEvent.experienceDetails
	local rsvpCounters = p2.virtualEvent.rsvpCounters
	local v7 = p2.eventStatus == "Ongoing"

	local v8 = React.useMemo(function()
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
		v7 and experienceDetails and experienceDetails.playing == 0
		or not v7 and rsvpCounters and rsvpCounters.going == 0
	then
		return nil
	end

	local v9 = not (rsvpCounters and rsvpCounters.going) and 0 or rsvpCounters.going
	local v10 = not (experienceDetails and experienceDetails.playing) and 0 or experienceDetails.playing

	local createElement = React.createElement
	local v12 = {
		backgroundStyle = v5.Inverse.Surface.Surface_300,
		tag = {
			["row gap-xsmall size-0-700 auto-x align-y-center align-x-center clip radius-circle"] = true
		}
	}

	local children = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 12)
		}),
		EventSocialProof = 0,
		AttendanceCount = 0
	}

	local createElement2 = React.createElement

	local v15 = if Players.LocalPlayer then tostring(Players.LocalPlayer.UserId) else nil
	children.EventSocialProof = createElement2(module3, {
		userIds = v8,
		desiredFirstUserId = v15
	})

	local createElement3 = React.createElement

	if v7 then
		v9 = v10
	end

	local v20 = formatNumberWithShortUnits(v9)
	local v21 = if v7 then v6.attendingNow else v6.interested
	children.AttendanceCount = createElement3(text, {
		Text = ("%s %s"):format(v20, v21),
		textStyle = v5.Inverse.Content.Emphasis,
		fontStyle = v5.Typography.TitleSmall,
		tag = "auto-x size-0-full shrink text-caption-large text-truncate-end"
	})
	return createElement(view, v12, children)
end

return AttendanceChip
