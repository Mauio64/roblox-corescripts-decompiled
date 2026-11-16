local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Players = game:GetService("Players")

require(VirtualEvents.Parent.GraphQLServer)
local Foundation = require(VirtualEvents.Parent.Foundation)
local React = require(VirtualEvents.Parent.React)
local EventSocialProof = require(VirtualEvents.Components.EventSocialProof)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local formatNumberWithShortUnits = require(VirtualEvents.Common.formatNumberWithShortUnits)
require(VirtualEvents.Parent.VirtualEventsState)

local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function AttendanceChip(p)
	local v = useTokens()
	local v2 = useLocalization({
		interested = "Feature.VirtualEvents.AttendanceBeforeEvent",
		attendingNow = "Feature.VirtualEvents.AttendanceDuringEvent"
	})

	local experienceDetails = p.virtualEvent.experienceDetails
	local rsvpCounters = p.virtualEvent.rsvpCounters
	local v3 = p.eventStatus == "Ongoing"

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
		v3 and experienceDetails and experienceDetails.playing == 0
		or not v3 and rsvpCounters and rsvpCounters.going == 0
	then
		return nil
	end

	local v4 = not (rsvpCounters and rsvpCounters.going) and 0 or rsvpCounters.going
	local v5 = not (experienceDetails and experienceDetails.playing) and 0 or experienceDetails.playing

	local createElement = React.createElement
	local v6 = {
		backgroundStyle = v.Inverse.Surface.Surface_300,
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
	local desiredFirstUserId

	if Players.LocalPlayer then
		desiredFirstUserId = tostring(Players.LocalPlayer.UserId)
	end

	children.EventSocialProof = createElement2(EventSocialProof, {
		userIds = userIds,
		desiredFirstUserId = desiredFirstUserId
	})

	local createElement3 = React.createElement

	if v3 then
		v4 = v5
	end

	local v7 = formatNumberWithShortUnits(v4)
	local v8 = if v3 then v2.attendingNow else v2.interested
	children.AttendanceCount = createElement3(Text, {
		Text = ("%s %s"):format(v7, v8),
		textStyle = v.Inverse.Content.Emphasis,
		fontStyle = v.Typography.TitleSmall,
		tag = "auto-x size-0-full shrink text-caption-large text-truncate-end"
	})
	return createElement(View, v6, children)
end

return AttendanceChip
