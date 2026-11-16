local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local getEventCtaButtonState = require(VirtualEvents.Common.getEventCtaButtonState)
require(VirtualEvents.Parent.GraphQLServer)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(VirtualEvents.Parent.VirtualEventsState)
local GamePlayButton = require(VirtualEvents.Parent.GamePlayButton)
local usePlayButtonState = GamePlayButton.usePlayButtonState
local RoactServiceTags = require(VirtualEvents.Parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(VirtualEvents.Parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local Images = UIBlox.App.ImageSet.Images
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function useActionBarProps(data, p, data2, buttonRef)
	local v = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		joinEvent = "Feature.VirtualEvents.JoinEvent",
		goHome = "Feature.VirtualEvents.GoHome"
	})

	local eventCtaButtonState = getEventCtaButtonState((usePlayButtonState(
		useRoactService(RoactNetworking),
		(tostring(data.universeId))
	)))
	local isJoinEventDisabled = eventCtaButtonState.isJoinEventDisabled
	local isRsvpDisabled = eventCtaButtonState.isRsvpDisabled

	local button = React.useMemo(function()
		if data.eventStatus == "cancelled" or data.eventStatus == "moderated" then
			return {
				props = {
					buttonType = ButtonType.Secondary,
					text = v.goHome,
					onActivated = data2.onClose,
					buttonRef = buttonRef
				}
			}
		end

		if p == "Upcoming" or p == "UpcomingImminent" then
			if data.userRsvpStatus == "going" then
				return {
					props = {
						buttonType = ButtonType.Secondary,
						text = v.unfollowEvent,
						icon = Images["icons/actions/favoriteOn"],
						onActivated = data2.onRsvpChanged,
						buttonRef = buttonRef,
						isDisabled = isRsvpDisabled
					}
				}
			end

			return {
				props = {
					buttonType = ButtonType.PrimarySystem,
					text = v.notifyMe,
					icon = Images["icons/actions/favoriteOff"],
					onActivated = data2.onRsvpChanged,
					buttonRef = buttonRef,
					isDisabled = isRsvpDisabled
				}
			}
		elseif p == "Ongoing" or p == "ElapsedImminent" then
			return {
				props = {
					buttonType = ButtonType.PrimaryContextual,
					text = v.joinEvent,
					onActivated = data2.onJoinEvent,
					buttonRef = buttonRef,
					isDisabled = isJoinEventDisabled
				}
			}
		else
			return nil
		end
	end, { data, p, data2, buttonRef, isRsvpDisabled, isJoinEventDisabled })

	local v2 = React.useMemo(function()
		if data.eventStatus == "cancelled" or data.eventStatus == "moderated" or p == "Elapsed" then
			return nil
		end

		return {
			props = {
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = Images["icons/actions/share"],
				userInteractionEnabled = true,
				onActivated = data2.onShare
			}
		}
	end, { data, p, data2 })

	return (React.useMemo(function()
		return {
			button = button,
			icons = { v2 }
		}
	end, { button, v2 }))
end

return useActionBarProps
