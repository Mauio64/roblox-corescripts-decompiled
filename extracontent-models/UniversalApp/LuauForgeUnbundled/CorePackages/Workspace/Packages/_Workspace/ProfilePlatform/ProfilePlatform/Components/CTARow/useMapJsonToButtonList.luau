require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local iconName = Foundation.Enums.IconName
local buttonVariant = Foundation.Enums.ButtonVariant

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local module4 = require("@luauforge/bundled/fkm")
local networkStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking").Enum.NetworkStatus

local useProfileActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileActions")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local fFlagEnableProfilePlatformDisabledActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableProfilePlatformDisabledActions
local FFlagEnableCommunityVerificationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableCommunityVerificationModal")

local FFlagPortEnableCommunityVerificationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagPortEnableCommunityVerificationModal")

local FFlagEnableProfilePlatformDisabledReasonText = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableProfilePlatformDisabledReasonText")
local FFlagProfilePlatformAddCurrentlyPlaying = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformAddCurrentlyPlaying")

local FFlagProfilePlatformPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration")
local fFlagJoinabilityCTARefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagJoinabilityCTARefactor

local v5 = if FFlagProfilePlatformPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration").Presence.PresenceStore.get() else nil

local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")

local function profileMenuItemFromResolvedAction(p2, data, p3)
	local v6 = data.onActivated[p3]

	if v6 then
		return {
			id = p2,
			displayValue = { icon = data.icon, text = data.text },
			onActivated = v6,
			isDisabled = data.isDisabled
		}
	end

	warn("profileMenuItemFromResolvedAction: action not available for profile type", p2, p3)
	return nil
end

local function contextualMenuItemsFromJsonActions(options, p2, profileType)
	local result = {}

	for i, v6 in ipairs(options or {}) do
		local v7 = type(v6) ~= "table" and { v6 } or v6
		local v8 = { items = {} }

		for j, v9 in ipairs(v7) do
			local v10 = p2[v9]

			if not v10 then
				continue
			end

			local v11 = profileMenuItemFromResolvedAction(v9, v10, profileType)

			if v11 then
				table.insert(v8.items, v11)
			end
		end

		if #v8.items > 0 then
			table.insert(result, v8)
		end
	end

	return result
end

local function hasJoinExperience(buttons): boolean
	for k, item in buttons do
		if
			item.type == Enums.ProfileActions.JoinExperience
			or fFlagJoinabilityCTARefactor and item.type == Enums.ProfileActions.PlayExperience
		then
			return true
		end
	end

	return false
end

local function useMapJsonToButtonList(p2)
	local v6 = useDispatch()
	local v7 = useProfileJsonComponent(Enums.Components.Actions) or {}

	local v8 = useProfileActions(Enums.ButtonSurface.Actions)
	local profileType = useProfileWrapperContext().profileType
	local v9 = useProfileAnalyticsContext()
	local v10

	if not FFlagProfilePlatformPresenceStoreMigration then
		v10 = useSelector(function(p3): boolean
			return module4.GetPresencesFromUserIds.getStatus(p3, p2) == networkStatus.NotStarted
		end)
	end

	if FFlagProfilePlatformAddCurrentlyPlaying then
		React.useEffect(function()
			if v7.buttons and hasJoinExperience(v7.buttons) then
				if FFlagProfilePlatformPresenceStoreMigration then
					v5.RefreshPresenceByUserId(p2)
				else
					v6(module4.GetPresencesFromUserIds.API({ p2 }))
				end
			end
		end, { v7.buttons, v6, p2 })
	else
		local function fn()
			if FFlagProfilePlatformPresenceStoreMigration then
				v5.RefreshPresenceByUserId(p2)
			else
				v6(module4.GetPresencesFromUserIds.API({ p2 }))
			end
		end

		useEffectOnce(
			fn,
			v7.buttons ~= nil and hasJoinExperience(v7.buttons) and (FFlagProfilePlatformPresenceStoreMigration and true or v10)
		)
	end

	return (React.useMemo(function()
		local result = {}

		for i, v11 in ipairs(v7.buttons or {}) do
			local v12 = v8[v11.type]

			if v12 then
				local clone = table.clone(v12)
				local v13 = contextualMenuItemsFromJsonActions(v11.subActions, v8, profileType)

				if fFlagEnableProfilePlatformDisabledActions and v11.disabledReason then
					if
						FFlagEnableCommunityVerificationModal
						and v11.type == Enums.ProfileActions.JoinCommunity
						and (v11.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelLow or v11.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelMedium or v11.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelHigh)
					then
						local v14 = if FFlagEnableCommunityVerificationModal and FFlagPortEnableCommunityVerificationModal then iconName.LockClosed else nil
						clone.icon = v14

						clone.onActivated = {
							[profileType] = function()
								local v15 = {
									name = Enums.Screens.CommunityVerificationModal,
									extraProps = { disabledReason = v11.disabledReason }
								}

								if fFlagSignalsNavP3Dispatch then
									return navigationCommands.down(navigationCommands.fromLegacyPage(v15))
								end

								return v6(navigateDown(v15))
							end
						}
					else
						clone.isDisabled = true

						local v14 = if FFlagEnableProfilePlatformDisabledReasonText then v11.disabledReason else nil
						clone.disabledReason = v14
					end
				end

				local v14

				if #result == 0 and not clone.isDisabled then
					v14 = clone.variant or buttonVariant.Emphasis
				else
					v14 = buttonVariant.Standard
				end

				local v15 = profileMenuItemFromResolvedAction(v11.type, clone, profileType)

				if v15 then
					table.insert(result, {
						contextualMenuItems = v13,
						menuItem = v15,
						buttonStyle = v14,
						isLoading = clone.isLoading,
						disabledReason = clone.disabledReason
					})
				end
			else
				warn("useMapJsonToButtonList: unrecognized action type", v11.type)
			end
		end

		local v11 = contextualMenuItemsFromJsonActions(v7.contextual, v8, profileType)

		if #v11 > 0 then
			table.insert(result, {
				menuItem = {
					id = Enums.ProfileActions.ContextualOverflow,
					displayValue = { icon = iconName.ThreeDotsHorizontal },
					onActivated = function()
						v9.fireAnalyticsEvent(EventNames.ContextualMenuButton)
					end
				},
				contextualMenuItems = v11,
				buttonStyle = buttonVariant.Standard
			})
		end

		return result
	end, { v7.buttons, v7.contextual, v8, v6, profileType, v9 }))
end

return useMapJsonToButtonList
