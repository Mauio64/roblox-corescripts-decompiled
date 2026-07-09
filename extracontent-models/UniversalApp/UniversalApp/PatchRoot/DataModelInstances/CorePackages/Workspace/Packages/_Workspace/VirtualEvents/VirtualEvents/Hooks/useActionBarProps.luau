local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local getEventCtaButtonState = require(VirtualEvents.Common.getEventCtaButtonState)

require(VirtualEvents.Parent.GraphQLServer)

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization

require(VirtualEvents.Parent.VirtualEventsState)

local usePlayButtonState = require(VirtualEvents.Parent.GamePlayButton).usePlayButtonState
local RoactNetworking = require(VirtualEvents.Parent.RoactServiceTags).RoactNetworking
local useRoactService = require(VirtualEvents.Parent.RobloxAppHooks).useRoactService
local FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable = require(VirtualEvents.Parent.SharedFlags).FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable
local Images = UIBlox.App.ImageSet.Images
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function useActionBarProps(p1, p2, t1: {[any]: any}, p3) -- line: 68
	-- upvalues: useLocalization (copy), FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable (copy), useRoactService (copy), RoactNetworking (copy), usePlayButtonState (copy), getEventCtaButtonState (copy), React (copy), ButtonType (copy), Images (copy)
	local v17 = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		joinEvent = "Feature.VirtualEvents.JoinEvent",
		goHome = "Feature.VirtualEvents.GoHome"
	})
	local isRsvpDisabled = nil
	local isJoinEventDisabled = nil

	if FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then
		local v20 = useRoactService(RoactNetworking)
		local v21 = usePlayButtonState(v20, (tostring(p1.universeId)))
		local v22 = getEventCtaButtonState(v21)

		isJoinEventDisabled = v22.isJoinEventDisabled
		isRsvpDisabled = v22.isRsvpDisabled
	end

	local v23 = React.useMemo(function() -- line: 92
		-- upvalues: p1 (copy), p2 (copy), ButtonType (copy), v17 (copy), Images (copy), t1 (copy), p3 (copy), FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable (copy), isRsvpDisabled (ref), isJoinEventDisabled (ref)
		if p1.eventStatus ~= "cancelled" and p1.eventStatus ~= "moderated" then
			if p2 == "Upcoming" or p2 == "UpcomingImminent" then
				if p1.userRsvpStatus == "going" then
					return {
						props = {
							buttonType = ButtonType.Secondary,
							text = v17.unfollowEvent,
							icon = Images["icons/actions/favoriteOn"],
							onActivated = t1.onRsvpChanged,
							buttonRef = p3,
							isDisabled = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then nil else isRsvpDisabled
						}
					}
				end

				return {
					props = {
						buttonType = ButtonType.PrimarySystem,
						text = v17.notifyMe,
						icon = Images["icons/actions/favoriteOff"],
						onActivated = t1.onRsvpChanged,
						buttonRef = p3,
						isDisabled = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then nil else isRsvpDisabled
					}
				}
			end

			if p2 == "Ongoing" or p2 == "ElapsedImminent" then
				return {
					props = {
						buttonType = ButtonType.PrimaryContextual,
						text = v17.joinEvent,
						onActivated = t1.onJoinEvent,
						buttonRef = p3,
						isDisabled = if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then nil else isJoinEventDisabled
					}
				}
			end

			return nil
		end

		return {
			props = {
				buttonType = ButtonType.Secondary,
				text = v17.goHome,
				onActivated = t1.onClose,
				buttonRef = p3
			}
		}
	end, {
		p1,
		p2,
		t1,
		p3,
		if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then nil else isRsvpDisabled,
		if not FFlagLuaAppEventDetailsPageDisableCtaOnUnplayable then nil else isJoinEventDisabled
	})
	local v24 = React.useMemo(function() -- line: 158
		-- upvalues: p1 (copy), p2 (copy), Images (copy), t1 (copy)
		if p1.eventStatus ~= "cancelled" and (p1.eventStatus ~= "moderated" and p2 ~= "Elapsed") then
			return {
				props = {
					userInteractionEnabled = true,
					anchorPoint = Vector2.new(0.5, 0.5),
					position = UDim2.fromScale(0.5, 0.5),
					icon = Images["icons/actions/share"],
					onActivated = t1.onShare
				}
			}
		end

		return nil
	end, {
		p1,
		p2,
		t1
	})

	return (React.useMemo(function() -- line: 178
		-- upvalues: v23 (copy), v24 (copy)
		return {
			button = v23,
			icons = { v24 }
		}
	end, {
		v23,
		v24
	}))
end

return useActionBarProps
