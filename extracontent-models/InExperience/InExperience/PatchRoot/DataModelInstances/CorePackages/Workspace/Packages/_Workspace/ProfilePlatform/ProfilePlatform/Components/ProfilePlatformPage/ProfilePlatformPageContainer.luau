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
local FFlagPPVBackgroundPrefetchAvatar = SharedFlags.FFlagPPVBackgroundPrefetchAvatar
local v49 = if not FFlagPPVBackgroundPrefetchAvatar then nil else require(ProfilePlatformParent.EditProfileBackground).AvatarModelPrefetch
local ProfilePlatformPage = require(script.Parent.ProfilePlatformPage)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

return function() -- line: 71
	-- upvalues: React (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), FFlagAXEnableProfileTab (copy), useIsMeTab (copy), useLocalUserId (copy), useDispatch (copy), FFlagProfilePlatformTrustedConnectionsMVP (copy), Navigation (copy), useProfileJson (copy), useAvailableComponents (copy), FFlagProfilePlatformRefreshActionsRespectPolicies (copy), useActionsComponentRequest (copy), SocialStopwatch (copy), EventNames (copy), LoadingStages (copy), getProfilePlatform (copy), FFlagProfilePlatformEnableLazyLoadingComponents (copy), FFlagProfilePlatformEnableVR (copy), getDeepValue (copy), Enums (copy), getFriendStatusFromProfileResponse (copy), getIsTrustedConnectionsStatusFromProfileResponse (copy), checkQrSession (copy), RobloxAppEnums (copy), refreshProfilePlatformActionInfo (copy), LoadingStagesExtension (copy), FFlagPPVBackgroundPrefetchAvatar (copy), useEffectOnMount (copy), v49 (copy), v44 (copy), useSignalState (copy), ProfileRefreshSignal (copy), v43 (copy), IXPService (copy), v39 (copy), v40 (copy), v41 (copy), v45 (copy), v46 (copy), v47 (copy), FFlagProfilePlatformEnableMoments (copy), Cryo (copy), parseComponentsFromJson (copy), ProfilePlatformEventReceiver (copy), ProfilePlatformPage (copy)
	local v52, v53 = React.useState(true)
	local v54 = useProfileWrapperContext()
	local v55 = useProfileAnalyticsContext()
	local profileId = v54.profileId
	local profileType = v54.profileType
	local v58 = if not FFlagAXEnableProfileTab then nil else useIsMeTab()
	local v59 = useLocalUserId()
	local v60 = tostring(profileId) == tostring(v59)
	local v61 = useDispatch()
	local v62 = if not FFlagProfilePlatformTrustedConnectionsMVP then nil else Navigation.useNavigation()
	local v63 = useProfileJson()
	local v64 = useAvailableComponents()
	local v65 = if not FFlagProfilePlatformRefreshActionsRespectPolicies then nil else useActionsComponentRequest()
	local v66 = React.useRef(0)

	local function v67(n1: number?) -- line: 96
		-- upvalues: SocialStopwatch (copy), v55 (copy), EventNames (copy), LoadingStages (copy), v61 (copy), getProfilePlatform (copy), profileId (copy), profileType (copy), v64 (copy), FFlagProfilePlatformEnableLazyLoadingComponents (copy), v53 (copy), FFlagProfilePlatformEnableVR (copy), getDeepValue (copy), Enums (copy), FFlagProfilePlatformTrustedConnectionsMVP (copy), getFriendStatusFromProfileResponse (copy), getIsTrustedConnectionsStatusFromProfileResponse (copy), v54 (copy), checkQrSession (copy), v62 (copy), RobloxAppEnums (copy), refreshProfilePlatformActionInfo (copy), v65 (copy), LoadingStagesExtension (copy)
		local v73 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

		v55.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
			isProfilePlatform = true,
			statValue = if not v73 then nil else v73.timeElapsed,
			status = LoadingStages.Fetching
		})
		v61(getProfilePlatform.API({
			includeComponentOrdering = true,
			profileId = profileId,
			profileType = profileType,
			components = v64,
			onlyEssentialComponents = not not FFlagProfilePlatformEnableLazyLoadingComponents or nil
		})):andThen(function(p1) -- line: 112
			-- upvalues: FFlagProfilePlatformEnableLazyLoadingComponents (copy), v53 (copy), FFlagProfilePlatformEnableVR (copy), n1 (copy), v55 (copy), EventNames (copy), getDeepValue (copy), Enums (copy), FFlagProfilePlatformTrustedConnectionsMVP (copy), getFriendStatusFromProfileResponse (copy), getIsTrustedConnectionsStatusFromProfileResponse (copy), v54 (copy), v61 (copy), checkQrSession (copy), profileId (copy), v62 (copy), RobloxAppEnums (copy), refreshProfilePlatformActionInfo (copy), v65 (copy)
			if FFlagProfilePlatformEnableLazyLoadingComponents then
				v53(false)
			end

			if FFlagProfilePlatformEnableVR and n1 > 1 then
				v55.fireAnalyticsEvent(EventNames.ProfilePlatformPageReloaded, {
					reloadCount = n1
				})

				return
			end

			local v78 = getDeepValue(p1, `responseBody.components.{ Enums.Components.Actions }.buttons`)
			local v79 = if not v78 or not v78[1] then nil else v78[1].type

			if FFlagProfilePlatformTrustedConnectionsMVP and getFriendStatusFromProfileResponse(p1) == Enums.FriendStatus.Friends and not getIsTrustedConnectionsStatusFromProfileResponse(p1) and v54.sourceInfo.source == Enums.Sources.QrCode then
				v61(checkQrSession.API(profileId)):andThen(function(p2) -- line: 134
					-- upvalues: v62 (copy), RobloxAppEnums (copy), profileId (copy), v61 (copy), refreshProfilePlatformActionInfo (copy), v65 (copy)
					if p2.responseBody == true then
						v62.push(RobloxAppEnums.AppPage.TrustedContactsModal, {
							props = {
								sentFromQrCode = true,
								userId = profileId,
								onRequestSent = function() -- line: 140
									-- upvalues: v61 (copy), refreshProfilePlatformActionInfo (copy), profileId (copy), v65 (copy)
									return v61(refreshProfilePlatformActionInfo(profileId, v65))
								end
							}
						})
					end
				end)
			end

			v55.fireAnalyticsEvent(EventNames.ProfilePageLoadedWithData, {
				friendStatus = getFriendStatusFromProfileResponse(p1),
				absolutePosition = v54.sourceInfo.homepageCarouselAbsolutePosition,
				isHomePageCarousel = v54.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
				source = v54.sourceInfo.source,
				isRecommendation = v54.sourceInfo.isRecommendation,
				v54.sourceInfo.recommendationContextType,
				recommendationRank = v54.sourceInfo.recommendationRank,
				recommendationSessionId = v54.sourceInfo.recommendationSessionId,
				shareLinkId = v54.sourceInfo.shareLinkId,
				primaryAction = v79
			})
		end):catch(function(_) -- line: 166
			-- upvalues: v55 (copy), EventNames (copy), v73 (copy), LoadingStages (copy)
			v55.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
				isProfilePlatform = true,
				statValue = if not v73 then nil else v73.timeElapsed,
				status = LoadingStages.Failed
			})
		end)

		if FFlagProfilePlatformEnableLazyLoadingComponents then
			v61(getProfilePlatform.API({
				includeComponentOrdering = true,
				onlyEssentialComponents = false,
				profileId = profileId,
				profileType = profileType,
				components = v64
			})):andThen(function(_) -- line: 182
				-- upvalues: v55 (copy), EventNames (copy), v73 (copy), LoadingStagesExtension (copy)
				v55.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
					isProfilePlatform = true,
					statValue = if not v73 then nil else v73.timeElapsed,
					status = LoadingStagesExtension.LazyLoaded
				})
			end):catch(function(_) -- line: 189
				-- upvalues: v55 (copy), EventNames (copy), v73 (copy), LoadingStages (copy)
				v55.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
					isProfilePlatform = true,
					statValue = if not v73 then nil else v73.timeElapsed,
					status = LoadingStages.Failed
				})
			end)
		end
	end

	if FFlagPPVBackgroundPrefetchAvatar then
		useEffectOnMount(function() -- line: 200
			-- upvalues: profileType (copy), Enums (copy), profileId (copy), v49 (copy)
			if profileType ~= Enums.ProfileTypes.User then
				return
			end

			local num = tonumber(profileId)

			if num then
				v49.prefetch(num)
			end
		end)
	end

	if v44 then
		local v68 = useSignalState(ProfileRefreshSignal.getProfileRefreshSignal)
		local v69 = React.useRef(0)

		React.useEffect(function() -- line: 215
			-- upvalues: v60 (copy), v68 (copy), v69 (copy), v67 (copy)
			if v60 and v68 > v69.current then
				v69.current = v68
				v67()
			end
		end, {
			v68,
			v60,
			profileId,
			v67
		})
	end

	if FFlagProfilePlatformEnableVR then
		React.useEffect(function() -- line: 224
			-- upvalues: v66 (copy), v67 (copy)
			local v75 = v66.current + 1

			v66.current = v75
			v67(v75)
		end, { v64 })
	else
		useEffectOnMount(function() -- line: 230
			-- upvalues: v67 (copy)
			v67()
		end)
	end

	React.useEffect(function() -- line: 235
		-- upvalues: SocialStopwatch (copy), v55 (copy), EventNames (copy)
		return function() -- line: 236
			-- upvalues: SocialStopwatch (copy), v55 (copy), EventNames (copy)
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ProfileOpened)
			v55.fireAnalyticsEvent(EventNames.ProfileClosed)
		end
	end, {})

	if v43 then
		useEffectOnMount(function() -- line: 244
			-- upvalues: IXPService (copy), v39 (copy), v40 (copy), v60 (copy), v41 (copy)
			IXPService:LogFlagLinkedUserLayerExposure(v39)
			IXPService:LogFlagLinkedUserLayerExposure(v40)

			if v60 then
				IXPService:LogFlagLinkedUserLayerExposure(v41)
			end
		end)
	end

	if v45 then
		React.useEffect(function() -- line: 254
			-- upvalues: v46 (copy), v47 (copy), v54 (copy)
			local Metadata = nil

			if v46:SessionExists(v47.StructuralIdentifier.ProfilePlatformPage) then
				Metadata = v46:GetMetadata(v47.StructuralIdentifier.ProfilePlatformPage, v47.Metadata.ProfilePlatformPage.ProfileSessionId)
			else
				v46:SetSession(v47.StructuralIdentifier.Level2a, v47.StructuralIdentifier.ProfilePlatformPage, v47.StructuralIdentifier.ProfilePlatformPage)
			end

			v46:SetMetadata(v47.StructuralIdentifier.ProfilePlatformPage, v47.Metadata.ProfilePlatformPage.ProfileSessionId, v54.profileSessionId)

			return function() -- line: 274
				-- upvalues: Metadata (ref), v46 (copy), v47 (copy)
				if Metadata ~= nil then
					v46:SetMetadata(v47.StructuralIdentifier.ProfilePlatformPage, v47.Metadata.ProfilePlatformPage.ProfileSessionId, Metadata)

					return
				end

				v46:RemoveSession(v47.StructuralIdentifier.ProfilePlatformPage)
			end
		end, {})
	end

	local v70 = if not FFlagProfilePlatformEnableMoments then nil else v54.sourceInfo.source
	local v71 = React.useMemo(function() -- line: 290
		-- upvalues: Cryo (copy), parseComponentsFromJson (copy), v63 (copy), profileType (copy), v70 (copy), FFlagAXEnableProfileTab (copy), v58 (copy), React (copy), ProfilePlatformEventReceiver (copy)
		return Cryo.Dictionary.union(parseComponentsFromJson(v63.components, v63.componentOrdering, profileType, v70, if not FFlagAXEnableProfileTab then nil else v58), {
			ProfilePlatformEventReceiver = React.createElement(ProfilePlatformEventReceiver)
		})
	end, {
		v63.components,
		v63.componentOrdering,
		v70,
		if not FFlagAXEnableProfileTab then nil else v58,
		profileType
	})

	return React.createElement(ProfilePlatformPage, {
		children = if not FFlagProfilePlatformEnableLazyLoadingComponents or not v52 then v71 else {}
	})
end
