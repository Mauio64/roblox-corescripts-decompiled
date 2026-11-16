local getEventCtaButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getEventCtaButtonState")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")
local usePlayButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GamePlayButton").usePlayButtonState
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useRoactService

local images = UIBlox.App.ImageSet.Images
local buttonType = UIBlox.App.Button.Enum.ButtonType

local function useActionBarProps(data, p2, data2, p3)
	local v5 = useLocalization({
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		joinEvent = "Feature.VirtualEvents.JoinEvent",
		goHome = "Feature.VirtualEvents.GoHome"
	})

	local v8 = getEventCtaButtonState((usePlayButtonState(useRoactService(roactNetworking), (tostring(data.universeId)))))
	local isJoinEventDisabled = v8.isJoinEventDisabled
	local isRsvpDisabled = v8.isRsvpDisabled

	local v9 = React.useMemo(function()
		if data.eventStatus == "cancelled" or data.eventStatus == "moderated" then
			return {
				props = {
					buttonType = buttonType.Secondary,
					text = v5.goHome,
					onActivated = data2.onClose,
					buttonRef = p3
				}
			}
		end

		if p2 == "Upcoming" or p2 == "UpcomingImminent" then
			if data.userRsvpStatus == "going" then
				return {
					props = {
						buttonType = buttonType.Secondary,
						text = v5.unfollowEvent,
						icon = images["icons/actions/favoriteOn"],
						onActivated = data2.onRsvpChanged,
						buttonRef = p3,
						isDisabled = isRsvpDisabled
					}
				}
			end

			return {
				props = {
					buttonType = buttonType.PrimarySystem,
					text = v5.notifyMe,
					icon = images["icons/actions/favoriteOff"],
					onActivated = data2.onRsvpChanged,
					buttonRef = p3,
					isDisabled = isRsvpDisabled
				}
			}
		elseif p2 == "Ongoing" or p2 == "ElapsedImminent" then
			return {
				props = {
					buttonType = buttonType.PrimaryContextual,
					text = v5.joinEvent,
					onActivated = data2.onJoinEvent,
					buttonRef = p3,
					isDisabled = isJoinEventDisabled
				}
			}
		else
			return nil
		end
	end, { data, p2, data2, p3, isRsvpDisabled, isJoinEventDisabled })

	local v10 = React.useMemo(function()
		if data.eventStatus == "cancelled" or data.eventStatus == "moderated" or p2 == "Elapsed" then
			return nil
		end

		return {
			props = {
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = images["icons/actions/share"],
				userInteractionEnabled = true,
				onActivated = data2.onShare
			}
		}
	end, { data, p2, data2 })

	return (React.useMemo(function()
		return {
			button = v9,
			icons = { v10 }
		}
	end, { v9, v10 }))
end

return useActionBarProps
