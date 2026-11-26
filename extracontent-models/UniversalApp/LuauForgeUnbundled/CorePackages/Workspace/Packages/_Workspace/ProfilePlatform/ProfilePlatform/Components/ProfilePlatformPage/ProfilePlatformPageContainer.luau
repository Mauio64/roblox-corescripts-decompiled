local module = require("@luauforge/bundled/feH")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics")
local SocialStopwatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialStopwatch")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local checkQrSession = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/checkQrSession")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState
local profileRefreshSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Signals.ProfileRefreshSignal
local parseComponentsFromJson = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformPage/parseComponentsFromJson")
local useAvailableComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAvailableComponents")
local useProfileJson = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJson")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useIsMeTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useIsMeTab")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformPage/ProfilePlatformEventReceiver")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local getFriendStatusFromProfileResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformPage/getFriendStatusFromProfileResponse")

local getIsTrustedConnectionsStatusFromProfileResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformPage/getIsTrustedConnectionsStatusFromProfileResponse")
local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local useActionsComponentRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useActionsComponentRequest")
local loadingStages = SocialLuaAnalytics.Analytics.Enums.LoadingStages
local LoadingStagesExtension = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/LoadingStagesExtension")
local FFlagProfilePlatformEnableVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableVR")

local FFlagProfilePlatformEnableLazyLoadingComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableLazyLoadingComponents")

local FFlagProfilePlatformRefreshActionsRespectPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformRefreshActionsRespectPolicies")
local FFlagProfilePlatformEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableMoments")
local fFlagProfilePlatformTrustedConnectionsMVP = SharedFlags.FFlagProfilePlatformTrustedConnectionsMVP
local fFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local fFlagJoinUserCTAsIxpEnabled = SharedFlags.FFlagJoinUserCTAsIxpEnabled
local fStringJoinUserCTAsIxpLayer = SharedFlags.FStringJoinUserCTAsIxpLayer

local ixpServiceWrapper = if fFlagJoinUserCTAsIxpEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/IxpServiceWrapper").IXPServiceWrapper else nil

local defineFastString = game:DefineFastString("SocialProfilePeekViewLayer", "Social.ProfilePeekView")

local defineFastString2 = game:DefineFastString(
	"SocialProfilePeekViewSecondaryLayer",
	"Social.ProfilePeekView.Secondary"
)
local defineFastString3 = game:DefineFastString("SocialSelfProfileViewLayer", "Social.SelfProfileView")
local IXPService = game:GetService("IXPService")

local defineFastFlag = game:DefineFastFlag("EnableSocialProfilePeekViewExposureEvents", false)
local defineFastFlag2 = game:DefineFastFlag("ProfilePlatformEnableRefreshSignal", false)

local defineFastFlag3 = game:DefineFastFlag("ProfilePlatformEnableSessionization", false)

local SessionService = if defineFastFlag3 then game:GetService("SessionService") else nil

local sessionType = if defineFastFlag3 then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppSessionization").SessionType else nil

local avatarModelPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfileBackground").AvatarModelPrefetch

local ProfilePlatformPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformPage/ProfilePlatformPage")
local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")

return function()
	local state, setState = React.useState(true)

	local v5 = useProfileWrapperContext()
	local v6 = useProfileAnalyticsContext()

	local profileId = v5.profileId
	local profileType = v5.profileType
	local v7 = if fFlagAXEnableProfileTab then useIsMeTab() else nil

	local v8 = useLocalUserId()
	local v9 = tostring(profileId) == tostring(v8)

	local v10 = useDispatch()
	local v11 = if fFlagProfilePlatformTrustedConnectionsMVP then Navigation.useNavigation() else nil

	local v12 = useProfileJson()

	local v13 = useAvailableComponents()

	local v14 = if FFlagProfilePlatformRefreshActionsRespectPolicies then useActionsComponentRequest() else nil

	local ref = React.useRef(0)

	local function fn(p2)
		local v15 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

		local fireAnalyticsEvent = v6.fireAnalyticsEvent
		local profileLoadingStage = EventNames.ProfileLoadingStage
		local v17 = if v15 then v15.timeElapsed else nil
		fireAnalyticsEvent(profileLoadingStage, {
			statValue = v17,
			status = loadingStages.Fetching,
			isProfilePlatform = true
		})

		v10(getProfilePlatform.API({
			profileId = profileId,
			profileType = profileType,
			components = v13,
			includeComponentOrdering = true,
			onlyEssentialComponents = FFlagProfilePlatformEnableLazyLoadingComponents and true or nil
		})):andThen(function(p3)
			if FFlagProfilePlatformEnableLazyLoadingComponents then
				setState(false)
			end

			if FFlagProfilePlatformEnableVR and p2 > 1 then
				v6.fireAnalyticsEvent(EventNames.ProfilePlatformPageReloaded, {
					reloadCount = p2
				})

				return
			end

			local v18 = module(p3, `responseBody.components.{module19.Components.Actions}.buttons`)
			local kind = if v18 and v18[1] then v18[1].type else nil

			if
				fFlagProfilePlatformTrustedConnectionsMVP
				and getFriendStatusFromProfileResponse(p3) == Enums.FriendStatus.Friends
				and not getIsTrustedConnectionsStatusFromProfileResponse(p3)
				and v5.sourceInfo.source == Enums.Sources.QrCode
			then
				v10(checkQrSession.API(profileId)):andThen(function(p4)
					if p4.responseBody == true then
						v11.push(RobloxAppEnums.AppPage.TrustedContactsModal, {
							props = {
								userId = profileId,
								sentFromQrCode = true,
								onRequestSent = function()
									return v10(refreshProfilePlatformActionInfo(profileId, v14))
								end
							}
						})
					end
				end)
			end

			v6.fireAnalyticsEvent(EventNames.ProfilePageLoadedWithData, {
				friendStatus = getFriendStatusFromProfileResponse(p3),
				absolutePosition = v5.sourceInfo.homepageCarouselAbsolutePosition,
				isHomePageCarousel = v5.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
				source = v5.sourceInfo.source,
				isRecommendation = v5.sourceInfo.isRecommendation,
				v5.sourceInfo.recommendationContextType,
				recommendationRank = v5.sourceInfo.recommendationRank,
				recommendationSessionId = v5.sourceInfo.recommendationSessionId,
				shareLinkId = v5.sourceInfo.shareLinkId,
				primaryAction = kind
			})
		end):catch(function(p3)
			local fireAnalyticsEvent2 = v6.fireAnalyticsEvent
			local profileLoadingStage2 = EventNames.ProfileLoadingStage
			local v19 = if v15 then v15.timeElapsed else nil
			fireAnalyticsEvent2(profileLoadingStage2, {
				statValue = v19,
				status = loadingStages.Failed,
				isProfilePlatform = true
			})
		end)

		if FFlagProfilePlatformEnableLazyLoadingComponents then
			v10(getProfilePlatform.API({
				profileId = profileId,
				profileType = profileType,
				components = v13,
				includeComponentOrdering = true,
				onlyEssentialComponents = false
			})):andThen(function(p3)
				local fireAnalyticsEvent2 = v6.fireAnalyticsEvent
				local profileLoadingStage2 = EventNames.ProfileLoadingStage
				local v19 = if v15 then v15.timeElapsed else nil
				fireAnalyticsEvent2(profileLoadingStage2, {
					statValue = v19,
					status = LoadingStagesExtension.LazyLoaded,
					isProfilePlatform = true
				})
			end):catch(function(p3)
				local fireAnalyticsEvent2 = v6.fireAnalyticsEvent
				local profileLoadingStage2 = EventNames.ProfileLoadingStage
				local v19 = if v15 then v15.timeElapsed else nil
				fireAnalyticsEvent2(profileLoadingStage2, {
					statValue = v19,
					status = loadingStages.Failed,
					isProfilePlatform = true
				})
			end)
		end
	end
	useEffectOnMount(function()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v15 = tonumber(profileId)

		if v15 then
			avatarModelPrefetch.prefetch(v15)
		end
	end)

	if defineFastFlag2 then
		local v15 = useSignalState(profileRefreshSignal.getProfileRefreshSignal)
		local ref2 = React.useRef(0)

		React.useEffect(function()
			if v9 and v15 > ref2.current then
				ref2.current = v15
				fn()
			end
		end, { v15, v9, profileId, fn })
	end

	if FFlagProfilePlatformEnableVR then
		React.useEffect(function()
			local v15 = ref.current + 1
			ref.current = v15
			fn(v15)
		end, { v13 })
	else
		useEffectOnMount(function()
			fn()
		end)
	end

	React.useEffect(function()
		return function()
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ProfileOpened)

			v6.fireAnalyticsEvent(EventNames.ProfileClosed)
		end
	end, {})

	if defineFastFlag then
		useEffectOnMount(function()
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)

			if v9 then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString3)
			end
		end)
	end

	if fFlagJoinUserCTAsIxpEnabled then
		useEffectOnMount(function()
			if profileType == Enums.ProfileTypes.User and not v9 then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringJoinUserCTAsIxpLayer)
			end
		end)
	end

	if defineFastFlag3 then
		React.useEffect(function()
			local metadata = nil

			if SessionService:SessionExists(sessionType.StructuralIdentifier.ProfilePlatformPage) then
				metadata = SessionService:GetMetadata(
					sessionType.StructuralIdentifier.ProfilePlatformPage,
					sessionType.Metadata.ProfilePlatformPage.ProfileSessionId
				)
			else
				SessionService:SetSession(
					sessionType.StructuralIdentifier.Level2a,
					sessionType.StructuralIdentifier.ProfilePlatformPage,
					sessionType.StructuralIdentifier.ProfilePlatformPage
				)
			end

			SessionService:SetMetadata(
				sessionType.StructuralIdentifier.ProfilePlatformPage,
				sessionType.Metadata.ProfilePlatformPage.ProfileSessionId,
				v5.profileSessionId
			)

			return function()
				if metadata == nil then
					SessionService:RemoveSession(sessionType.StructuralIdentifier.ProfilePlatformPage)
				else
					SessionService:SetMetadata(
						sessionType.StructuralIdentifier.ProfilePlatformPage,
						sessionType.Metadata.ProfilePlatformPage.ProfileSessionId,
						metadata
					)
				end
			end
		end, {})
	end

	local source = if FFlagProfilePlatformEnableMoments then v5.sourceInfo.source else nil
	local function fn2()
		local union = Cryo.Dictionary.union

		local components = v12.components
		local componentOrdering = v12.componentOrdering
		local v18 = if fFlagAXEnableProfileTab then v7 else nil
		return union(parseComponentsFromJson(components, componentOrdering, profileType, source, v18), {
			ProfilePlatformEventReceiver = React.createElement(module16)
		})
	end

	local v17 = React.useMemo(fn2, {
		v12.components,
		v12.componentOrdering,
		source,
		if fFlagAXEnableProfileTab then v7 else nil,
		profileType
	})

	return React.createElement(ProfilePlatformPage, {
		children = FFlagProfilePlatformEnableLazyLoadingComponents and state and {} or v17
	})
end
