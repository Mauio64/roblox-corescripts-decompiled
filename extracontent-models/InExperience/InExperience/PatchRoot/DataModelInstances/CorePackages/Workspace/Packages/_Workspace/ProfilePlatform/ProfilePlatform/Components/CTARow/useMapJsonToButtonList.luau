local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

require(ProfilePlatform.Components.CTARow.Types)

local Foundation = require(parent.Foundation)
local IconName = Foundation.Enums.IconName
local ButtonVariant = Foundation.Enums.ButtonVariant

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local networkStatus = myRoduxNetworking.Enum.NetworkStatus

local useProfileActions = require(ProfilePlatform.Hooks.useProfileActions)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local Enums = require(ProfilePlatform.Common.Enums)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableProfilePlatformDisabledActions = SharedFlags2.FFlagEnableProfilePlatformDisabledActions
local FFlagEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagEnableCommunityVerificationModal)

local FFlagPortEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagPortEnableCommunityVerificationModal)

local FFlagEnableProfilePlatformDisabledReasonText = require(ProfilePlatform.Flags.FFlagEnableProfilePlatformDisabledReasonText)
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)

local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagJoinabilityCTARefactor = SharedFlags3.FFlagJoinabilityCTARefactor
local v

if FFlagProfilePlatformPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

local function profileMenuItemFromResolvedAction(id, data, p)
	local onActivated = data.onActivated[p]

	if onActivated then
		return {
			id = id,
			displayValue = { icon = data.icon, text = data.text },
			onActivated = onActivated,
			isDisabled = data.isDisabled
		}
	end

	warn("profileMenuItemFromResolvedAction: action not available for profile type", id, p)
	return nil
end

local function contextualMenuItemsFromJsonActions(options, p, profileType)
	local result = {}

	for _, v2 in ipairs(options or {}) do
		local v3 = type(v2) ~= "table" and { v2 } or v2
		local v4 = { items = {} }

		for _, v5 in ipairs(v3) do
			local v6 = p[v5]

			if not v6 then
				continue
			end

			local v7 = profileMenuItemFromResolvedAction(v5, v6, profileType)

			if v7 then
				table.insert(v4.items, v7)
			end
		end

		if #v4.items > 0 then
			table.insert(result, v4)
		end
	end

	return result
end

local function hasJoinExperience(buttons): boolean
	for _, item in buttons do
		if
			item.type == Enums.ProfileActions.JoinExperience
			or FFlagJoinabilityCTARefactor and item.type == Enums.ProfileActions.PlayExperience
		then
			return true
		end
	end

	return false
end

local function useMapJsonToButtonList(p: string)
	local v2 = useDispatch()
	local v3 = useProfileJsonComponent(Enums.Components.Actions) or {}

	local v4 = useProfileActions(Enums.ButtonSurface.Actions)
	local profileType = useProfileWrapperContext().profileType
	local v5 = useProfileAnalyticsContext()
	local v6

	if not FFlagProfilePlatformPresenceStoreMigration then
		v6 = useSelector(function(p2): boolean
			return NetworkingPresence.GetPresencesFromUserIds.getStatus(p2, p) == networkStatus.NotStarted
		end)
	end

	if FFlagProfilePlatformAddCurrentlyPlaying then
		React.useEffect(function()
			if v3.buttons and hasJoinExperience(v3.buttons) then
				if FFlagProfilePlatformPresenceStoreMigration then
					v.RefreshPresenceByUserId(p)
				else
					v2(NetworkingPresence.GetPresencesFromUserIds.API({ p }))
				end
			end
		end, { v3.buttons, v2, p })
	else
		local function fn()
			if FFlagProfilePlatformPresenceStoreMigration then
				v.RefreshPresenceByUserId(p)
				return
			end

			v2(NetworkingPresence.GetPresencesFromUserIds.API({ p }))
		end

		useEffectOnce(
			fn,
			v3.buttons ~= nil and hasJoinExperience(v3.buttons) and (FFlagProfilePlatformPresenceStoreMigration and true or v6)
		)
	end

	return (React.useMemo(function()
		local result = {}

		for _, v7 in ipairs(v3.buttons or {}) do
			local v8 = v4[v7.type]

			if v8 then
				local clone = table.clone(v8)
				local contextualMenuItems = contextualMenuItemsFromJsonActions(v7.subActions, v4, profileType)

				if FFlagEnableProfilePlatformDisabledActions and v7.disabledReason then
					if
						FFlagEnableCommunityVerificationModal
						and v7.type == Enums.ProfileActions.JoinCommunity
						and (v7.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelLow or v7.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelMedium or v7.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelHigh)
					then
						local icon

						if FFlagEnableCommunityVerificationModal and FFlagPortEnableCommunityVerificationModal then
							icon = IconName.LockClosed
						end

						clone.icon = icon

						clone.onActivated = {
							[profileType] = function()
								local v9 = {
									name = Enums.Screens.CommunityVerificationModal,
									extraProps = { disabledReason = v7.disabledReason }
								}

								if FFlagSignalsNavP3Dispatch then
									return navigationCommands.down(navigationCommands.fromLegacyPage(v9))
								end

								return v2(NavigateDown(v9))
							end
						}
					else
						clone.isDisabled = true
						local disabledReason

						if FFlagEnableProfilePlatformDisabledReasonText then
							disabledReason = v7.disabledReason
						end

						clone.disabledReason = disabledReason
					end
				end

				local buttonStyle

				if #result == 0 and not clone.isDisabled then
					buttonStyle = clone.variant or ButtonVariant.Emphasis
				else
					buttonStyle = ButtonVariant.Standard
				end

				local menuItem = profileMenuItemFromResolvedAction(v7.type, clone, profileType)

				if menuItem then
					table.insert(result, {
						contextualMenuItems = contextualMenuItems,
						menuItem = menuItem,
						buttonStyle = buttonStyle,
						isLoading = clone.isLoading,
						disabledReason = clone.disabledReason
					})
				end
			else
				warn("useMapJsonToButtonList: unrecognized action type", v7.type)
			end
		end

		local contextualMenuItems = contextualMenuItemsFromJsonActions(v3.contextual, v4, profileType)

		if #contextualMenuItems > 0 then
			table.insert(result, {
				menuItem = {
					id = Enums.ProfileActions.ContextualOverflow,
					displayValue = { icon = IconName.ThreeDotsHorizontal },
					onActivated = function()
						v5.fireAnalyticsEvent(EventNames.ContextualMenuButton)
					end
				},
				contextualMenuItems = contextualMenuItems,
				buttonStyle = ButtonVariant.Standard
			})
		end

		return result
	end, { v3.buttons, v3.contextual, v4, v2, profileType, v5 }))
end

return useMapJsonToButtonList
