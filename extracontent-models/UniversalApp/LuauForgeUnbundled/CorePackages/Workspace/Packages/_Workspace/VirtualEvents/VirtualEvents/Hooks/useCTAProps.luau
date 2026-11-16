require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local function useCTAProps(p2, p3, p4, data)
	local v5 = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		join = "Feature.VirtualEvents.Join",
		goHome = "Feature.VirtualEvents.GoHome"
	})

	local v6 = React.useMemo(function()
		if p2.eventStatus == "cancelled" or p2.eventStatus == "moderated" then
			return {
				text = v5.goHome,
				icon = nil,
				variant = "Standard",
				onActivated = data.onClose
			}
		end

		if p3 == "Upcoming" or p3 == "UpcomingImminent" then
			if p2.userRsvpStatus == "going" then
				return {
					text = v5.unfollowEvent,
					icon = nil,
					variant = "Standard",
					onActivated = data.onRsvpChanged
				}
			end

			return {
				text = v5.notifyMe,
				icon = nil,
				variant = p4 and "Emphasis" or "Standard",
				onActivated = data.onRsvpChanged
			}
		elseif p3 == "Ongoing" or p3 == "ElapsedImminent" then
			return {
				text = v5.join,
				icon = nil,
				variant = "Emphasis",
				onActivated = data.onJoinEvent
			}
		else
			return nil
		end
	end, { p2, p3, data })

	local v7 = React.useMemo(function()
		if p2.eventStatus == "cancelled" or p2.eventStatus == "moderated" or p3 == "Elapsed" then
			return nil
		end

		return {
			text = nil,
			icon = "icons/actions/shareArrowOff",
			variant = "Standard",
			onActivated = data.onShare
		}
	end, { p2, p3, data })

	return (React.useMemo(function()
		return { button = v6, icon = v7 }
	end, { v6, v7 }))
end

return useCTAProps
