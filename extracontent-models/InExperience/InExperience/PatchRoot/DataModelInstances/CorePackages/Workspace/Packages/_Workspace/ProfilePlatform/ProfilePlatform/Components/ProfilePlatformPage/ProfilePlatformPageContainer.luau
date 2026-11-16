local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SharedFlags = require(parent.SharedFlags)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SocialStopwatch = require(parent.SocialStopwatch)
local Cryo = require(parent.Cryo)
local checkQrSession = require(ProfilePlatform.Networking.checkQrSession)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local ProfileRefreshSignal = ProfilePlatformCommon.Signals.ProfileRefreshSignal
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
local FFlagJoinUserCTAsIxpEnabled = SharedFlags.FFlagJoinUserCTAsIxpEnabled
local FStringJoinUserCTAsIxpLayer = SharedFlags.FStringJoinUserCTAsIxpLayer
local ixpServiceWrapper

if FFlagJoinUserCTAsIxpEnabled then
	local IXPServiceWrapper = require(parent.IXPServiceWrapper)
	ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
else
	ixpServiceWrapper = nil
end

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
local SessionService

if defineFastFlag3 then
	SessionService = game:GetService("SessionService")
else
	SessionService = nil
end

local sessionType

if defineFastFlag3 then
	local RobloxAppSessionization = require(parent.RobloxAppSessionization)
	sessionType = RobloxAppSessionization.SessionType
else
	sessionType = nil
end

local EditProfileBackground = require(parent.EditProfileBackground)
local AvatarModelPrefetch = EditProfileBackground.AvatarModelPrefetch

local ProfilePlatformPage = require(script.Parent.ProfilePlatformPage)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

return function()
	local state, setState = React.useState(true)

	local v = useProfileWrapperContext()
	local v2 = useProfileAnalyticsContext()

	local profileId = v.profileId
	local profileType = v.profileType
	local v3

	if FFlagAXEnableProfileTab then
		v3 = useIsMeTab()
	else
		v3 = nil
	end

	local v4 = useLocalUserId()
	local v5 = tostring(profileId) == tostring(v4)

	local v6 = useDispatch()
	local v7

	if FFlagProfilePlatformTrustedConnectionsMVP then
		v7 = Navigation.useNavigation()
	else
		v7 = nil
	end

	local v8 = useProfileJson()

	local components2 = useAvailableComponents()
	local v9

	if FFlagProfilePlatformRefreshActionsRespectPolicies then
		v9 = useActionsComponentRequest()
	else
		v9 = nil
	end

	local ref = React.useRef(0)

	local function fn(reloadCount: number?)
		local v10 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

		local fireAnalyticsEvent = v2.fireAnalyticsEvent
		local profileLoadingStage = EventNames.ProfileLoadingStage
		local statValue

		if v10 then
			statValue = v10.timeElapsed
		end

		fireAnalyticsEvent(profileLoadingStage, {
			statValue = statValue,
			status = LoadingStages.Fetching,
			isProfilePlatform = true
		})

		v6(getProfilePlatform.API({
			profileId = profileId,
			profileType = profileType,
			components = components2,
			includeComponentOrdering = true,
			onlyEssentialComponents = FFlagProfilePlatformEnableLazyLoadingComponents and true or nil
		})):andThen(function(p)
			if FFlagProfilePlatformEnableLazyLoadingComponents then
				setState(false)
			end

			if FFlagProfilePlatformEnableVR and reloadCount > 1 then
				v2.fireAnalyticsEvent(EventNames.ProfilePlatformPageReloaded, {
					reloadCount = reloadCount
				})

				return
			end

			local deepValue = getDeepValue(p, `responseBody.components.{Enums.Components.Actions}.buttons`)
			local kind

			if deepValue and deepValue[1] then
				kind = deepValue[1].type
			end

			if
				FFlagProfilePlatformTrustedConnectionsMVP
				and getFriendStatusFromProfileResponse(p) == Enums.FriendStatus.Friends
				and not getIsTrustedConnectionsStatusFromProfileResponse(p)
				and v.sourceInfo.source == Enums.Sources.QrCode
			then
				v6(checkQrSession.API(profileId)):andThen(function(p2)
					if p2.responseBody == true then
						v7.push(RobloxAppEnums.AppPage.TrustedContactsModal, {
							props = {
								userId = profileId,
								sentFromQrCode = true,
								onRequestSent = function()
									return v6(refreshProfilePlatformActionInfo(profileId, v9))
								end
							}
						})
					end
				end)
			end

			v2.fireAnalyticsEvent(EventNames.ProfilePageLoadedWithData, {
				friendStatus = getFriendStatusFromProfileResponse(p),
				absolutePosition = v.sourceInfo.homepageCarouselAbsolutePosition,
				isHomePageCarousel = v.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
				source = v.sourceInfo.source,
				isRecommendation = v.sourceInfo.isRecommendation,
				v.sourceInfo.recommendationContextType,
				recommendationRank = v.sourceInfo.recommendationRank,
				recommendationSessionId = v.sourceInfo.recommendationSessionId,
				shareLinkId = v.sourceInfo.shareLinkId,
				primaryAction = kind
			})
		end):catch(function(_)
			local fireAnalyticsEvent2 = v2.fireAnalyticsEvent
			local profileLoadingStage2 = EventNames.ProfileLoadingStage
			local statValue2

			if v10 then
				statValue2 = v10.timeElapsed
			end

			fireAnalyticsEvent2(profileLoadingStage2, {
				statValue = statValue2,
				status = LoadingStages.Failed,
				isProfilePlatform = true
			})
		end)

		if FFlagProfilePlatformEnableLazyLoadingComponents then
			v6(getProfilePlatform.API({
				profileId = profileId,
				profileType = profileType,
				components = components2,
				includeComponentOrdering = true,
				onlyEssentialComponents = false
			})):andThen(function(_)
				local fireAnalyticsEvent2 = v2.fireAnalyticsEvent
				local profileLoadingStage2 = EventNames.ProfileLoadingStage
				local statValue2

				if v10 then
					statValue2 = v10.timeElapsed
				end

				fireAnalyticsEvent2(profileLoadingStage2, {
					statValue = statValue2,
					status = LoadingStagesExtension.LazyLoaded,
					isProfilePlatform = true
				})
			end):catch(function(_)
				local fireAnalyticsEvent2 = v2.fireAnalyticsEvent
				local profileLoadingStage2 = EventNames.ProfileLoadingStage
				local statValue2

				if v10 then
					statValue2 = v10.timeElapsed
				end

				fireAnalyticsEvent2(profileLoadingStage2, {
					statValue = statValue2,
					status = LoadingStages.Failed,
					isProfilePlatform = true
				})
			end)
		end
	end
	useEffectOnMount(function()
		if profileType ~= Enums.ProfileTypes.User then
			return
		end

		local v10 = tonumber(profileId)

		if v10 then
			AvatarModelPrefetch.prefetch(v10)
		end
	end)

	if defineFastFlag2 then
		local current = useSignalState(ProfileRefreshSignal.getProfileRefreshSignal)
		local ref2 = React.useRef(0)

		React.useEffect(function()
			if v5 and current > ref2.current then
				ref2.current = current
				fn()
			end
		end, { current, v5, profileId, fn })
	end

	if FFlagProfilePlatformEnableVR then
		React.useEffect(function()
			local current = ref.current + 1
			ref.current = current
			fn(current)
		end, { components2 })
	else
		useEffectOnMount(function()
			fn()
		end)
	end

	React.useEffect(function()
		return function()
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.ProfileOpened)

			v2.fireAnalyticsEvent(EventNames.ProfileClosed)
		end
	end, {})

	if defineFastFlag then
		useEffectOnMount(function()
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString2)

			if v5 then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString3)
			end
		end)
	end

	if FFlagJoinUserCTAsIxpEnabled then
		useEffectOnMount(function()
			if profileType == Enums.ProfileTypes.User and not v5 then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringJoinUserCTAsIxpLayer)
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
				v.profileSessionId
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

	local source

	if FFlagProfilePlatformEnableMoments then
		source = v.sourceInfo.source
	else
		source = nil
	end

	local useMemo = React.useMemo
	local function fn2()
		local union = Cryo.Dictionary.union

		local components = v8.components
		local componentOrdering = v8.componentOrdering
		local v10

		if FFlagAXEnableProfileTab then
			v10 = v3
		end

		return union(parseComponentsFromJson(components, componentOrdering, profileType, source, v10), {
			ProfilePlatformEventReceiver = React.createElement(ProfilePlatformEventReceiver)
		})
	end

	local components = v8.components
	local componentOrdering = v8.componentOrdering
	local v10

	if FFlagAXEnableProfileTab then
		v10 = v3
	end

	local v11 = useMemo(fn2, { components, componentOrdering, source, v10, profileType })

	return React.createElement(ProfilePlatformPage, {
		children = FFlagProfilePlatformEnableLazyLoadingComponents and state and {} or v11
	})
end
