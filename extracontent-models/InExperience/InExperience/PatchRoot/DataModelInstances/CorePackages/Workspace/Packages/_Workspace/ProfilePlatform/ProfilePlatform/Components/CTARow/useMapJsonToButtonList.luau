local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent

require(ProfilePlatform.Components.CTARow.Types)

local Foundation = require(ProfilePlatformParent.Foundation)
local IconName = Foundation.Enums.IconName
local ButtonVariant = Foundation.Enums.ButtonVariant
local React = require(ProfilePlatformParent.React)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v13 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)
local NetworkStatus = require(ProfilePlatform.Networking.myRoduxNetworking).Enum.NetworkStatus
local useProfileActions = require(ProfilePlatform.Hooks.useProfileActions)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagEnableProfilePlatformDisabledActions = require(ProfilePlatformParent.SharedFlags).FFlagEnableProfilePlatformDisabledActions
local FFlagEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagEnableCommunityVerificationModal)
local FFlagPortEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagPortEnableCommunityVerificationModal)
local FFlagEnableProfilePlatformDisabledReasonText = require(ProfilePlatform.Flags.FFlagEnableProfilePlatformDisabledReasonText)
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)
local FFlagAddCTAButtonAnalytics = require(ProfilePlatform.Flags.FFlagAddCTAButtonAnalytics)
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v27 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.DataHydration).Presence.PresenceStore.get()
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

local function profileMenuItemFromResolvedAction(p1, p2, p3) -- line: 53
	local v37 = p2.onActivated[p3]

	if not v37 then
		warn("profileMenuItemFromResolvedAction: action not available for profile type", p1, p3)

		return nil
	end

	return {
		id = p1,
		displayValue = {
			icon = p2.icon,
			text = p2.text
		},
		onActivated = v37,
		isDisabled = p2.isDisabled
	}
end
local function contextualMenuItemsFromJsonActions(t1: {[any]: any}?, t2: {[any]: any}, p4) -- line: 71
	-- upvalues: profileMenuItemFromResolvedAction (copy)
	local t3 = {}

	for _, v in ipairs(t1 or {}) do
		local t4 = {
			items = {}
		}
		local v45 = if type(v) ~= "table" then { v } else v

		for _, v2 in ipairs(v45) do
			local v48 = t2[v2]

			if v48 then
				local v49 = profileMenuItemFromResolvedAction(v2, v48, p4)

				if v49 then
					table.insert(t4.items, v49)
				end
			end
		end

		if #t4.items > 0 then
			table.insert(t3, t4)
		end
	end

	return t3
end
local function hasJoinExperience(p5) -- line: 99
	-- upvalues: Enums (copy)
	for _, v52 in p5 do
		if v52.type == Enums.ProfileActions.JoinExperience then
			return true
		end
	end

	return false
end
local function useMapJsonToButtonList(s1: string) -- line: 108
	-- upvalues: useDispatch (copy), useProfileJsonComponent (copy), Enums (copy), useProfileActions (copy), useProfileWrapperContext (copy), FFlagAddCTAButtonAnalytics (copy), useProfileAnalyticsContext (copy), FFlagProfilePlatformPresenceStoreMigration (copy), useSelector (copy), NetworkingPresence (copy), NetworkStatus (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), React (copy), v27 (copy), useEffectOnce (copy), contextualMenuItemsFromJsonActions (copy), FFlagEnableProfilePlatformDisabledActions (copy), FFlagEnableCommunityVerificationModal (copy), FFlagPortEnableCommunityVerificationModal (copy), IconName (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateDown (copy), FFlagEnableProfilePlatformDisabledReasonText (copy), ButtonVariant (copy), profileMenuItemFromResolvedAction (copy), EventNames (copy)
	local v54 = useDispatch()
	local v55 = useProfileJsonComponent(Enums.Components.Actions) or {}
	local v56 = useProfileActions(Enums.ButtonSurface.Actions)
	local profileType = useProfileWrapperContext().profileType
	local v58 = if not FFlagAddCTAButtonAnalytics then nil else useProfileAnalyticsContext()
	local v59 = if not FFlagProfilePlatformPresenceStoreMigration then useSelector(function(p6) -- line: 118
		-- upvalues: NetworkingPresence (copy), s1 (copy), NetworkStatus (copy)
		return NetworkingPresence.GetPresencesFromUserIds.getStatus(p6, s1) == NetworkStatus.NotStarted
	end) else nil

	if FFlagProfilePlatformAddCurrentlyPlaying then
		React.useEffect(function() -- line: 123
			-- upvalues: v55 (copy), Enums (copy), FFlagProfilePlatformPresenceStoreMigration (copy), v27 (copy), s1 (copy), v54 (copy), NetworkingPresence (copy)
			if v55.buttons then
				local g69 = nil
				local v68 = nil

				for _, v67 in v55.buttons do
					if v67.type == Enums.ProfileActions.JoinExperience then
						v68 = true
						g69 = true
					end

					if g69 then
						break
					end
				end

				if not g69 then
					v68 = false
				end

				g69 = false

				if v68 then
					if FFlagProfilePlatformPresenceStoreMigration then
						v27.RefreshPresenceByUserId(s1)

						return
					end

					v54(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
				end
			end
		end, {
			v55.buttons,
			v54,
			s1
		})
	else
		local v60 = useEffectOnce
		local v61 = false

		if v55.buttons ~= nil then
			local g64 = nil

			for _, v63 in v55.buttons do
				if v63.type == Enums.ProfileActions.JoinExperience then
					v61 = true
					g64 = true
				end

				if g64 then
					break
				end
			end

			if not g64 then
				v61 = false
			end

			g64 = false

			if v61 then
				v61 = not not FFlagProfilePlatformPresenceStoreMigration or v59
			end
		end

		v60(function() -- line: 134
			-- upvalues: FFlagProfilePlatformPresenceStoreMigration (copy), v27 (copy), s1 (copy), v54 (copy), NetworkingPresence (copy)
			if FFlagProfilePlatformPresenceStoreMigration then
				v27.RefreshPresenceByUserId(s1)

				return
			end

			v54(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
		end, v61)
	end

	return (React.useMemo(function() -- line: 147
		-- upvalues: v55 (copy), v56 (copy), contextualMenuItemsFromJsonActions (copy), profileType (copy), FFlagEnableProfilePlatformDisabledActions (copy), FFlagEnableCommunityVerificationModal (copy), Enums (copy), FFlagPortEnableCommunityVerificationModal (copy), IconName (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), v54 (copy), NavigateDown (copy), FFlagEnableProfilePlatformDisabledReasonText (copy), ButtonVariant (copy), profileMenuItemFromResolvedAction (copy), FFlagAddCTAButtonAnalytics (copy), v58 (copy), EventNames (copy)
		local t5 = {}

		for _, v in ipairs(v55.buttons or {}) do
			local v73 = v56[v.type]

			if not v73 then
				warn("useMapJsonToButtonList: unrecognized action type", v.type)
			else
				local v74 = table.clone(v73)
				local v75 = contextualMenuItemsFromJsonActions(v.subActions, v56, profileType)

				if FFlagEnableProfilePlatformDisabledActions and v.disabledReason then
					if FFlagEnableCommunityVerificationModal and v.type == Enums.ProfileActions.JoinCommunity and (v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelLow or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelMedium or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelHigh) then
						v74.icon = if not FFlagEnableCommunityVerificationModal or not FFlagPortEnableCommunityVerificationModal then nil else IconName.LockClosed
						v74.onActivated = {
							[profileType] = function() -- line: 175
								-- upvalues: Enums (copy), v (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), v54 (copy), NavigateDown (copy)
								local t6 = {
									name = Enums.Screens.CommunityVerificationModal,
									extraProps = {
										disabledReason = v.disabledReason
									}
								}

								if FFlagSignalsNavP3Dispatch then
									return v13.down(v13.fromLegacyPage(t6))
								end

								return v54(NavigateDown(t6))
							end
						}
					else
						v74.isDisabled = true
						v74.disabledReason = if not FFlagEnableProfilePlatformDisabledReasonText then nil else v.disabledReason
					end
				end

				local v76 = if #t5 ~= 0 or v74.isDisabled then ButtonVariant.Standard else v74.variant or ButtonVariant.Emphasis
				local v77 = profileMenuItemFromResolvedAction(v.type, v74, profileType)

				if v77 then
					table.insert(t5, {
						contextualMenuItems = v75,
						menuItem = v77,
						buttonStyle = v76,
						isLoading = v74.isLoading,
						disabledReason = v74.disabledReason
					})
				end
			end
		end

		local v78 = contextualMenuItemsFromJsonActions(v55.contextual, v56, profileType)

		if #v78 > 0 then
			table.insert(t5, {
				menuItem = {
					id = Enums.ProfileActions.ContextualOverflow,
					displayValue = {
						icon = IconName.ThreeDotsHorizontal
					},
					onActivated = not FFlagAddCTAButtonAnalytics and function() -- line: 229
					end or function() -- line: 226
						-- upvalues: v58 (copy), EventNames (copy)
						v58.fireAnalyticsEvent(EventNames.ContextualMenuButton)
					end
				},
				contextualMenuItems = v78,
				buttonStyle = ButtonVariant.Standard
			})
		end

		return t5
	end, {
		v55.buttons,
		v55.contextual,
		v56,
		v54,
		profileType,
		v58
	}))
end

return useMapJsonToButtonList
