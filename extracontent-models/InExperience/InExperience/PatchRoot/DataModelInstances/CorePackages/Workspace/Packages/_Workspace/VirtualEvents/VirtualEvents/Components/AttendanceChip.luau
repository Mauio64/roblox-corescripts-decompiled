local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Players = game:GetService("Players")

require(VirtualEvents.Parent.GraphQLServer)

local Foundation = require(VirtualEvents.Parent.Foundation)
local React = require(VirtualEvents.Parent.React)
local EventSocialProof = require(VirtualEvents.Components.EventSocialProof)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local formatNumberWithShortUnits = require(VirtualEvents.Common.formatNumberWithShortUnits)

require(VirtualEvents.Parent.VirtualEventsState)

local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function AttendanceChip(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), View (copy), EventSocialProof (copy), Players (copy), FoundationText (copy), formatNumberWithShortUnits (copy)
	local v13 = useTokens()
	local v14 = useLocalization({
		interested = "Feature.VirtualEvents.AttendanceBeforeEvent",
		attendingNow = "Feature.VirtualEvents.AttendanceDuringEvent"
	})
	local experienceDetails = t1.virtualEvent.experienceDetails
	local rsvpCounters = t1.virtualEvent.rsvpCounters
	local v17 = t1.eventStatus == "Ongoing"
	local v18 = React.useMemo(function() -- line: 32
		-- upvalues: t1 (copy)
		local t2 = {}

		if t1.virtualEvent.rsvps then
			for _, v23 in t1.virtualEvent.rsvps do
				if v23.rsvpStatus == "going" then
					table.insert(t2, (tostring(v23.userId)))
				end
			end
		end

		return t2
	end, { t1.virtualEvent })

	if v17 and (experienceDetails and experienceDetails.playing == 0) or not v17 and rsvpCounters and rsvpCounters.going == 0 then
		return nil
	end

	local v19 = (not rsvpCounters or not rsvpCounters.going) and 0 or rsvpCounters.going
	local v20 = (not experienceDetails or not experienceDetails.playing) and 0 or experienceDetails.playing

	return React.createElement(View, {
		backgroundStyle = v13.Inverse.Surface.Surface_300,
		tag = {
			["row gap-xsmall size-0-700 auto-x align-y-center align-x-center clip radius-circle"] = true
		}
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 12)
		}),
		EventSocialProof = React.createElement(EventSocialProof, {
			userIds = v18,
			desiredFirstUserId = if not Players.LocalPlayer then nil else tostring(Players.LocalPlayer.UserId)
		}),
		AttendanceCount = React.createElement(FoundationText, {
			tag = "auto-x size-0-full shrink text-caption-large text-truncate-end",
			Text = ("%s %s"):format(formatNumberWithShortUnits(if not v17 then v19 else v20), if not v17 then v14.interested else v14.attendingNow),
			textStyle = v13.Inverse.Content.Emphasis,
			fontStyle = v13.Typography.TitleSmall
		})
	})
end

return AttendanceChip
