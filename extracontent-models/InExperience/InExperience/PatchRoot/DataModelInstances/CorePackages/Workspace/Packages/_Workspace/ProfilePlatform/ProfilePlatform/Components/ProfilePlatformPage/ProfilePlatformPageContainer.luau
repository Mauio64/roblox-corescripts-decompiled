local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local Navigation = require(ProfilePlatformParent.Navigation)
local React = require(ProfilePlatformParent.React)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local RobloxAppEnums = require(ProfilePlatformParent.RobloxAppEnums)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local SocialLuaAnalytics = require(ProfilePlatformParent.SocialLuaAnalytics)
local SocialStopwatch = require(ProfilePlatformParent.SocialStopwatch)
local Cryo = require(ProfilePlatformParent.Cryo)
local checkQrSession = require(ProfilePlatform.Networking.checkQrSession)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local useSignalState = require(ProfilePlatformParent.SignalsReact).useSignalState
local ProfileRefreshSignal = require(ProfilePlatformParent.ProfilePlatformCommon).Signals.ProfileRefreshSignal
local parseComponentsFromJson = require(ProfilePlatform.Components.ProfilePlatformPage.parseComponentsFromJson)
local useAvailableComponents = require(ProfilePlatform.Hooks.useAvailableComponents)
local useProfileJson = require(ProfilePlatform.Hooks.useProfileJson)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local ProfilePlatformEventReceiver = require(script.Parent.ProfilePlatformEventReceiver)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Enums = require(ProfilePlatform.Common.Enums)
local getFriendStatusFromProfileResponse = require(script.Parent.getFriendStatusFromProfileResponse)
local getIsTrustedConnectionsStatusFromProfileResponse = require(script.Parent.getIsTrustedConnectionsStatusFromProfileResponse)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local useActionsComponentRequest = require(ProfilePlatform.Hooks.useActionsComponentRequest)
local LoadingStages = SocialLuaAnalytics.Analytics.Enums.LoadingStages
local LoadingStagesExtension = require(ProfilePlatform.Analytics.LoadingStagesExtension)
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)
local FFlagProfilePlatformEnableLazyLoadingComponents = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableLazyLoadingComponents)
local FFlagProfilePlatformRefreshActionsRespectPolicies = require(ProfilePlatform.Flags.FFlagProfilePlatformRefreshActionsRespectPolicies)
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)
local FFlagProfilePlatformTrustedConnectionsMVP = SharedFlags.FFlagProfilePlatformTrustedConnectionsMVP
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local v39 = game:DefineFastString("SocialProfilePeekViewLayer", "Social.ProfilePeekView")
local v40 = game:DefineFastString("SocialProfilePeekViewSecondaryLayer", "Social.ProfilePeekView.Secondary")
local v41 = game:DefineFastString("SocialSelfProfileViewLayer", "Social.SelfProfileView")
local IXPService = game:GetService("IXPService")
local v43 = game:DefineFastFlag("EnableSocialProfilePeekViewExposureEvents", false)
local v44 = game:DefineFastFlag("ProfilePlatformEnableRefreshSignal", false)
local v45 = game:DefineFastFlag("ProfilePlatformEnableSessionization", false)
local v46 = if not v45 then nil else game:GetService("SessionService")
local v47 = if not v45 then nil else require(ProfilePlatformParent.RobloxAppSessionization).SessionType
local AvatarModelPrefetch = require(ProfilePlatformParent.EditProfileBackground).AvatarModelPrefetch
local ProfilePlatformPage = require(script.Parent.ProfilePlatformPage)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

return function() -- line: 67
	-- upvalues: React (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), FFlagAXEnableProfileTab (copy), useIsMeTab (copy), useLocalUserId (copy), useDispatch (copy), FFlagProfilePlatformTrustedConnectionsMVP (copy), Navigation (copy), useProfileJson (copy), useAvailableComponents (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), useActionsComponentRequest (copy), SocialStopwatch (copy), EventNames (copy), LoadingStages (copy), getProfilePlatform (copy), FFlagProfilePlatformEnableLazyLoadingComponents (copy), FFlagProfilePlatformEnableVR (copy), getDeepValue (copy), Enums (copy), getFriendStatusFromProfileResponse (copy), getIsTrustedConnectionsStatusFromProfileResponse (copy), checkQrSession (copy), RobloxAppEnums (copy), refreshProfilePlatformActionInfo (copy), LoadingStagesExtension (copy), useEffectOnMount (copy), AvatarModelPrefetch (copy), v44 (copy), useSignalState (copy), ProfileRefreshSignal (copy), v43 (copy), IXPService (copy), v39 (copy), v40 (copy), v41 (copy), v45 (copy), v46 (copy), v47 (copy), FFlagProfilePlatformEnableMoments (copy), Cryo (copy), parseComponentsFromJson (copy), ProfilePlatformEventReceiver (copy), ProfilePlatformPage (copy)
	local v51, v52 = React.useState(true)
	local v53 = useProfileWrapperContext()
	local v54 = useProfileAnalyticsContext()
	local profileId = v53.profileId
	local profileType = v53.profileType
	local v57 = if not FFlagAXEnableProfileTab then nil else useIsMeTab()
	local v58 = useLocalUserId()
	local v59 = tostring(profileId) == tostring(v58)
	local v60 = useDispatch()
	local v61 = if not FFlagProfilePlatformTrustedConnectionsMVP then nil else Navigation.useNavigation()
	local v62 = useProfileJson()
	local v63 = useAvailableComponents()
	local v64 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else useActionsComponentRequest()
	local v65 = React.useRef(0)

	local function v66(n1: number?) -- line: 92
		-- upvalues: SocialStopwatch (copy), v54 (copy), EventNames (copy), LoadingStages (copy), v60 (copy), getProfilePlatform (copy), profileId (copy), profileType (copy), v63 (copy), FFlagProfilePlatformEnableLazyLoadingComponents (copy), v52 (copy), FFlagProfilePlatformEnableVR (copy), getDeepValue (copy), Enums (copy), FFlagProfilePlatformTrustedConnectionsMVP (copy), getFriendStatusFromProfileResponse (copy), getIsTrustedConnectionsStatusFromProfileResponse (copy), v53 (copy), checkQrSession (copy), v61 (copy), RobloxAppEnums (copy), refreshProfilePlatformActionInfo (copy), v64 (copy), LoadingStagesExtension (copy)
		local v72 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

		v54.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
			isProfilePlatform = true,
			statValue = if not v72 then nil else v72.timeElapsed,
			status = LoadingStages.Fetching
		})
		v60(getProfilePlatform.API({
			includeComponentOrdering = true,
			profileId = profileId,
			profileType = profileType,
			components = v63,
			onlyEssentialComponents = not not FFlagProfilePlatformEnableLazyLoadingComponents or nil
		})):andThen(function(p1) -- line: 108
			-- upvalues: FFlagProfilePlatformEnableLazyLoadingComponents (copy), v52 (copy), FFlagProfilePlatformEnableVR (copy), n1 (copy), v54 (copy), EventNames (copy), getDeepValue (copy), Enums (copy), FFlagProfilePlatformTrustedConnectionsMVP (copy), getFriendStatusFromProfileResponse (copy), getIsTrustedConnectionsStatusFromProfileResponse (copy), v53 (copy), v60 (copy), checkQrSession (copy), profileId (copy), v61 (copy), RobloxAppEnums (copy), refreshProfilePlatformActionInfo (copy), v64 (copy)
			if FFlagProfilePlatformEnableLazyLoadingComponents then
				v52(false)
			end

			if FFlagProfilePlatformEnableVR and n1 > 1 then
				v54.fireAnalyticsEvent(EventNames.ProfilePlatformPageReloaded, {
					reloadCount = n1
				})

				return
			end

			local v77 = getDeepValue(p1, `responseBody.components.{ Enums.Components.Actions }.buttons`)
			local v78 = if not v77 or not v77[1] then nil else v77[1].type

			if FFlagProfilePlatformTrustedConnectionsMVP and getFriendStatusFromProfileResponse(p1) == Enums.FriendStatus.Friends and not getIsTrustedConnectionsStatusFromProfileResponse(p1) and v53.sourceInfo.source == Enums.Sources.QrCode then
				v60(checkQrSession.API(profileId)):andThen(function(p2) -- line: 130
					-- upvalues: v61 (copy), RobloxAppEnums (copy), profileId (copy), v60 (copy), refreshProfilePlatformActionInfo (copy), v64 (copy)
					if p2.responseBody == true then
						v61.push(RobloxAppEnums.AppPage.TrustedContactsModal, {
							props = {
								sentFromQrCode = true,
								userId = profileId,
								onRequestSent = function() -- line: 136
									-- upvalues: v60 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v64 (copy)
									return v60(refreshProfilePlatformActionInfo(profileId, v64))
								end
							}
						})
					end
				end)
			end

			v54.fireAnalyticsEvent(EventNames.ProfilePageLoadedWithData, {
				friendStatus = getFriendStatusFromProfileResponse(p1),
				absolutePosition = v53.sourceInfo.homepageCarouselAbsolutePosition,
				isHomePageCarousel = v53.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
				source = v53.sourceInfo.source,
				isRecommendation = v53.sourceInfo.isRecommendation,
				v53.sourceInfo.recommendationContextType,
				recommendationRank = v53.sourceInfo.recommendationRank,
				recommendationSessionId = v53.sourceInfo.recommendationSessionId,
				shareLinkId = v53.sourceInfo.shareLinkId,
				primaryAction = v78
			})
		end):catch(function(_) -- line: 162
			-- upvalues: v54 (copy), EventNames (copy), v72 (copy), LoadingStages (copy)
			v54.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
				isProfilePlatform = true,
				statValue = if not v72 then nil else v72.timeElapsed,
				status = LoadingStages.Failed
			})
		end)

		if FFlagProfilePlatformEnableLazyLoadingComponents then
			v60(getProfilePlatform.API({
				includeComponentOrdering = true,
				onlyEssentialComponents = false,
				profileId = profileId,
				profileType = profileType,
				components = v63
			})):andThen(function(_) -- line: 178
				-- upvalues: v54 (copy), EventNames (copy), v72 (copy), LoadingStagesExtension (copy)
				v54.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
					isProfilePlatform = true,
					statValue = if not v72 then nil else v72.timeElapsed,
					status = LoadingStagesExtension.LazyLoaded
				})
			end):catch(function(_) -- line: 185
				-- upvalues: v54 (copy), EventNames (copy), v72 (copy), LoadingStages (copy)
				v54.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
					isProfilePlatform = true,
					statValue = if not v72 then nil else v72.timeElapsed,
					status = LoadingStages.Failed
				})
			end)
		end
	end

	useEffectOnMount(function() -- line: 194
		-- upvalues: profileType (copy), Enums (copy), profileId (copy), AvatarModelPrefetch (copy)
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local num = tonumber(profileId)

		if num then
			AvatarModelPrefetch.prefetch(num)
		end
	end)

	if v44 then
		local v67 = useSignalState(ProfileRefreshSignal.getProfileRefreshSignal)
		local v68 = React.useRef(0)

		React.useEffect(function() -- line: 208
			-- upvalues: v59 (copy), v67 (copy), v68 (copy), v66 (copy)
			if v59 and v67 > v68.current then
				v68.current = v67
				v66()
			end
		end, {
			v67,
			v59,
			profileId,
			v66
		})
	end

	if FFlagProfilePlatformEnableVR then
		React.useEffect(function() -- line: 217
			-- upvalues: v65 (copy), v66 (copy)
			local v74 = v65.current + 1

			v65.current = v74
			v66(v74)
		end, { v63 })
	else
		useEffectOnMount(function() -- line: 223
			-- upvalues: v66 (copy)
			v66()
		end)
	end

	React.useEffect(function() -- line: 228
		-- upvalues: SocialStopwatch (copy), v54 (copy), EventNames (copy)
		return function() -- line: 229
			-- upvalues: SocialStopwatch (copy), v54 (copy), EventNames (copy)
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ProfileOpened)
			v54.fireAnalyticsEvent(EventNames.ProfileClosed)
		end
	end, {})

	if v43 then
		useEffectOnMount(function() -- line: 237
			-- upvalues: IXPService (copy), v39 (copy), v40 (copy), v59 (copy), v41 (copy)
			IXPService:LogFlagLinkedUserLayerExposure(v39)
			IXPService:LogFlagLinkedUserLayerExposure(v40)

			if v59 then
				IXPService:LogFlagLinkedUserLayerExposure(v41)
			end
		end)
	end

	if v45 then
		React.useEffect(function() -- line: 247
			-- upvalues: v46 (copy), v47 (copy), v53 (copy)
			local Metadata = nil

			if v46:SessionExists(v47.StructuralIdentifier.ProfilePlatformPage) then
				Metadata = v46:GetMetadata(v47.StructuralIdentifier.ProfilePlatformPage, v47.Metadata.ProfilePlatformPage.ProfileSessionId)
			else
				v46:SetSession(v47.StructuralIdentifier.Level2a, v47.StructuralIdentifier.ProfilePlatformPage, v47.StructuralIdentifier.ProfilePlatformPage)
			end

			v46:SetMetadata(v47.StructuralIdentifier.ProfilePlatformPage, v47.Metadata.ProfilePlatformPage.ProfileSessionId, v53.profileSessionId)

			return function() -- line: 267
				-- upvalues: Metadata (ref), v46 (copy), v47 (copy)
				if Metadata ~= nil then
					v46:SetMetadata(v47.StructuralIdentifier.ProfilePlatformPage, v47.Metadata.ProfilePlatformPage.ProfileSessionId, Metadata)

					return
				end

				v46:RemoveSession(v47.StructuralIdentifier.ProfilePlatformPage)
			end
		end, {})
	end

	local v69 = if not FFlagProfilePlatformEnableMoments then nil else v53.sourceInfo.source
	local v70 = React.useMemo(function() -- line: 283
		-- upvalues: Cryo (copy), parseComponentsFromJson (copy), v62 (copy), profileType (copy), v69 (copy), FFlagAXEnableProfileTab (copy), v57 (copy), React (copy), ProfilePlatformEventReceiver (copy)
		return Cryo.Dictionary.union(parseComponentsFromJson(v62.components, v62.componentOrdering, profileType, v69, if not FFlagAXEnableProfileTab then nil else v57), {
			ProfilePlatformEventReceiver = React.createElement(ProfilePlatformEventReceiver)
		})
	end, {
		v62.components,
		v62.componentOrdering,
		v69,
		if not FFlagAXEnableProfileTab then nil else v57,
		profileType
	})

	return React.createElement(ProfilePlatformPage, {
		children = if not FFlagProfilePlatformEnableLazyLoadingComponents or not v51 then v70 else {}
	})
end
