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
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

local function profileMenuItemFromResolvedAction(p1, p2, p3) -- line: 47
	local v35 = p2.onActivated[p3]

	if not v35 then
		warn("profileMenuItemFromResolvedAction: action not available for profile type", p1, p3)

		return nil
	end

	return {
		id = p1,
		displayValue = {
			icon = p2.icon,
			text = p2.text
		},
		onActivated = v35,
		isDisabled = p2.isDisabled
	}
end
local function contextualMenuItemsFromJsonActions(t1: {[any]: any}?, t2: {[any]: any}, p4) -- line: 65
	-- upvalues: profileMenuItemFromResolvedAction (copy)
	local t3 = {}

	for _, v in ipairs(t1 or {}) do
		local t4 = {
			items = {}
		}
		local v43 = if type(v) ~= "table" then { v } else v

		for _, v2 in ipairs(v43) do
			local v46 = t2[v2]

			if v46 then
				local v47 = profileMenuItemFromResolvedAction(v2, v46, p4)

				if v47 then
					table.insert(t4.items, v47)
				end
			end
		end

		if #t4.items > 0 then
			table.insert(t3, t4)
		end
	end

	return t3
end
local function hasJoinExperience(p5) -- line: 93
	-- upvalues: Enums (copy)
	for _, v50 in p5 do
		if v50.type == Enums.ProfileActions.JoinExperience then
			return true
		end
	end

	return false
end
local function useMapJsonToButtonList(s1: string) -- line: 102
	-- upvalues: useDispatch (copy), useProfileJsonComponent (copy), Enums (copy), useProfileActions (copy), useProfileWrapperContext (copy), FFlagAddCTAButtonAnalytics (copy), useProfileAnalyticsContext (copy), useSelector (copy), NetworkingPresence (copy), NetworkStatus (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), React (copy), useEffectOnce (copy), contextualMenuItemsFromJsonActions (copy), FFlagEnableProfilePlatformDisabledActions (copy), FFlagEnableCommunityVerificationModal (copy), FFlagPortEnableCommunityVerificationModal (copy), IconName (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateDown (copy), FFlagEnableProfilePlatformDisabledReasonText (copy), ButtonVariant (copy), profileMenuItemFromResolvedAction (copy), EventNames (copy)
	local v52 = useDispatch()
	local v53 = useProfileJsonComponent(Enums.Components.Actions) or {}
	local v54 = useProfileActions(Enums.ButtonSurface.Actions)
	local profileType = useProfileWrapperContext().profileType
	local v56 = if not FFlagAddCTAButtonAnalytics then nil else useProfileAnalyticsContext()
	local v57 = useSelector(function(p6) -- line: 110
		-- upvalues: NetworkingPresence (copy), s1 (copy), NetworkStatus (copy)
		return NetworkingPresence.GetPresencesFromUserIds.getStatus(p6, s1) == NetworkStatus.NotStarted
	end)

	if FFlagProfilePlatformAddCurrentlyPlaying then
		React.useEffect(function() -- line: 115
			-- upvalues: v53 (copy), Enums (copy), v52 (copy), NetworkingPresence (copy), s1 (copy)
			if v53.buttons then
				local g67 = nil
				local v66 = nil

				for _, v65 in v53.buttons do
					if v65.type == Enums.ProfileActions.JoinExperience then
						v66 = true
						g67 = true
					end

					if g67 then
						break
					end
				end

				if not g67 then
					v66 = false
				end

				g67 = false

				if v66 then
					v52(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
				end
			end
		end, {
			v53.buttons,
			v52,
			s1
		})
	else
		local v58 = useEffectOnce
		local v59 = false

		if v53.buttons ~= nil then
			local g62 = nil

			for _, v61 in v53.buttons do
				if v61.type == Enums.ProfileActions.JoinExperience then
					v59 = true
					g62 = true
				end

				if g62 then
					break
				end
			end

			if not g62 then
				v59 = false
			end

			g62 = false

			if v59 then
				v59 = v57
			end
		end

		v58(function() -- line: 121
			-- upvalues: v52 (copy), NetworkingPresence (copy), s1 (copy)
			v52(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
		end, v59)
	end

	return (React.useMemo(function() -- line: 126
		-- upvalues: v53 (copy), v54 (copy), contextualMenuItemsFromJsonActions (copy), profileType (copy), FFlagEnableProfilePlatformDisabledActions (copy), FFlagEnableCommunityVerificationModal (copy), Enums (copy), FFlagPortEnableCommunityVerificationModal (copy), IconName (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), v52 (copy), NavigateDown (copy), FFlagEnableProfilePlatformDisabledReasonText (copy), ButtonVariant (copy), profileMenuItemFromResolvedAction (copy), FFlagAddCTAButtonAnalytics (copy), v56 (copy), EventNames (copy)
		local t5 = {}

		for _, v in ipairs(v53.buttons or {}) do
			local v71 = v54[v.type]

			if not v71 then
				warn("useMapJsonToButtonList: unrecognized action type", v.type)
			else
				local v72 = table.clone(v71)
				local v73 = contextualMenuItemsFromJsonActions(v.subActions, v54, profileType)

				if FFlagEnableProfilePlatformDisabledActions and v.disabledReason then
					if FFlagEnableCommunityVerificationModal and v.type == Enums.ProfileActions.JoinCommunity and (v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelLow or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelMedium or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelHigh) then
						v72.icon = if not FFlagEnableCommunityVerificationModal or not FFlagPortEnableCommunityVerificationModal then nil else IconName.LockClosed
						v72.onActivated = {
							[profileType] = function() -- line: 154
								-- upvalues: Enums (copy), v (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), v52 (copy), NavigateDown (copy)
								local t6 = {
									name = Enums.Screens.CommunityVerificationModal,
									extraProps = {
										disabledReason = v.disabledReason
									}
								}

								if FFlagSignalsNavP3Dispatch then
									return v13.down(v13.fromLegacyPage(t6))
								end

								return v52(NavigateDown(t6))
							end
						}
					else
						v72.isDisabled = true
						v72.disabledReason = if not FFlagEnableProfilePlatformDisabledReasonText then nil else v.disabledReason
					end
				end

				local v74 = if #t5 ~= 0 or v72.isDisabled then ButtonVariant.Standard else v72.variant or ButtonVariant.Emphasis
				local v75 = profileMenuItemFromResolvedAction(v.type, v72, profileType)

				if v75 then
					table.insert(t5, {
						contextualMenuItems = v73,
						menuItem = v75,
						buttonStyle = v74,
						isLoading = v72.isLoading,
						disabledReason = v72.disabledReason
					})
				end
			end
		end

		local v76 = contextualMenuItemsFromJsonActions(v53.contextual, v54, profileType)

		if #v76 > 0 then
			table.insert(t5, {
				menuItem = {
					id = Enums.ProfileActions.ContextualOverflow,
					displayValue = {
						icon = IconName.ThreeDotsHorizontal
					},
					onActivated = not FFlagAddCTAButtonAnalytics and function() -- line: 208
					end or function() -- line: 205
						-- upvalues: v56 (copy), EventNames (copy)
						v56.fireAnalyticsEvent(EventNames.ContextualMenuButton)
					end
				},
				contextualMenuItems = v76,
				buttonStyle = ButtonVariant.Standard
			})
		end

		return t5
	end, {
		v53.buttons,
		v53.contextual,
		v54,
		v52,
		profileType,
		v56
	}))
end

return useMapJsonToButtonList
