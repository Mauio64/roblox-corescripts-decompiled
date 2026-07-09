local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local React = require(VirtualEvents.Parent.React)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization

require(VirtualEvents.Parent.VirtualEventsState)

local function useCTAProps(p1, p2, b1: boolean, t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), React (copy)
	local v9 = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		join = "Feature.VirtualEvents.Join",
		goHome = "Feature.VirtualEvents.GoHome"
	})
	local v10 = React.useMemo(function() -- line: 46
		-- upvalues: p1 (copy), p2 (copy), v9 (copy), t1 (copy), b1 (copy)
		if p1.eventStatus ~= "cancelled" and p1.eventStatus ~= "moderated" then
			if p2 == "Upcoming" or p2 == "UpcomingImminent" then
				if p1.userRsvpStatus == "going" then
					return {
						icon = nil,
						variant = "Standard",
						text = v9.unfollowEvent,
						onActivated = t1.onRsvpChanged
					}
				end

				return {
					icon = nil,
					text = v9.notifyMe,
					variant = not b1 and "Standard" or "Emphasis",
					onActivated = t1.onRsvpChanged
				}
			end

			if p2 == "Ongoing" or p2 == "ElapsedImminent" then
				return {
					icon = nil,
					variant = "Emphasis",
					text = v9.join,
					onActivated = t1.onJoinEvent
				}
			end

			return nil
		end

		return {
			icon = nil,
			variant = "Standard",
			text = v9.goHome,
			onActivated = t1.onClose
		}
	end, {
		p1,
		p2,
		t1
	})
	local v11 = React.useMemo(function() -- line: 84
		-- upvalues: p1 (copy), p2 (copy), t1 (copy)
		if p1.eventStatus ~= "cancelled" and (p1.eventStatus ~= "moderated" and p2 ~= "Elapsed") then
			return {
				text = nil,
				icon = "icons/actions/shareArrowOff",
				variant = "Standard",
				onActivated = t1.onShare
			}
		end

		return nil
	end, {
		p1,
		p2,
		t1
	})

	return (React.useMemo(function() -- line: 101
		-- upvalues: v10 (copy), v11 (copy)
		return {
			button = v10,
			icon = v11
		}
	end, {
		v10,
		v11
	}))
end

return useCTAProps
