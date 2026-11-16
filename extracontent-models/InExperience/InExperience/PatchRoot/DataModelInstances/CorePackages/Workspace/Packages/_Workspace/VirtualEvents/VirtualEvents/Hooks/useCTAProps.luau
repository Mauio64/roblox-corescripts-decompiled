local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)
local React = require(VirtualEvents.Parent.React)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(VirtualEvents.Parent.VirtualEventsState)

local function useCTAProps(p, p2, flag: boolean, data)
	local v = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		join = "Feature.VirtualEvents.Join",
		goHome = "Feature.VirtualEvents.GoHome"
	})

	local button = React.useMemo(function()
		if p.eventStatus == "cancelled" or p.eventStatus == "moderated" then
			return { text = v.goHome, icon = nil, variant = "Standard", onActivated = data.onClose }
		end

		if p2 == "Upcoming" or p2 == "UpcomingImminent" then
			if p.userRsvpStatus == "going" then
				return {
					text = v.unfollowEvent,
					icon = nil,
					variant = "Standard",
					onActivated = data.onRsvpChanged
				}
			end

			return {
				text = v.notifyMe,
				icon = nil,
				variant = flag and "Emphasis" or "Standard",
				onActivated = data.onRsvpChanged
			}
		elseif p2 == "Ongoing" or p2 == "ElapsedImminent" then
			return {
				text = v.join,
				icon = nil,
				variant = "Emphasis",
				onActivated = data.onJoinEvent
			}
		else
			return nil
		end
	end, { p, p2, data })

	local icon = React.useMemo(function()
		if p.eventStatus == "cancelled" or p.eventStatus == "moderated" or p2 == "Elapsed" then
			return nil
		end

		return {
			text = nil,
			icon = "icons/actions/shareArrowOff",
			variant = "Standard",
			onActivated = data.onShare
		}
	end, { p, p2, data })

	return (React.useMemo(function()
		return { button = button, icon = icon }
	end, { button, icon }))
end

return useCTAProps
