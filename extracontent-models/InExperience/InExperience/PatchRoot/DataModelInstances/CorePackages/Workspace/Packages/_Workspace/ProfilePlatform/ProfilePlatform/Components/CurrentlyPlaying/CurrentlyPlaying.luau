local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local HorizontalPageMargin = require(ProfilePlatformParent.UIBlox).App.Container.HorizontalPageMargin
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local EnumsRadius = Foundation.Enums.Radius
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Enums = require(ProfilePlatform.Common.Enums)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)
local IXPService = game:GetService("IXPService")
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local OpenGameDetails = require(ProfilePlatformParent.GameDetail).OpenGameDetails
local RoactAnalyticsCommonGameEvents = require(ProfilePlatformParent.RoactServiceTags).RoactAnalyticsCommonGameEvents
local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local ContentProvider = game:GetService("ContentProvider")
local FStringSocialProfileCurrentlyPlayingLayer = require(ProfilePlatform.Flags.FStringSocialProfileCurrentlyPlayingLayer)
local FFlagProfileCurrentlyPlayingIXPEnabled = require(ProfilePlatform.Flags.FFlagProfileCurrentlyPlayingIXPEnabled)
local FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail = require(ProfilePlatform.Flags.FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail)
local FFlagProfileCurrentlyPlayingEDPFromCard = require(ProfilePlatform.Flags.FFlagProfileCurrentlyPlayingEDPFromCard)
local FFlagProfilePlatformImproveGameDetailsAnalytics = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformImproveGameDetailsAnalytics

local function CurrentlyPlaying(t1: {[any]: any}) -- line: 57
	-- upvalues: useTokens (copy), useProfileJsonComponent (copy), Enums (copy), useDispatch (copy), FFlagProfileCurrentlyPlayingEDPFromCard (copy), FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail (copy), useNavigation (copy), useProfileWrapperContext (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), React (copy), NetworkingGames (copy), useSelector (copy), getDeepValue (copy), AppPage (copy), OpenGameDetails (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), ContentProvider (copy), FFlagProfileCurrentlyPlayingIXPEnabled (copy), IXPService (copy), FStringSocialProfileCurrentlyPlayingLayer (copy), HorizontalPageMargin (copy), View (copy), StateLayerAffordance (copy), FoundationImage (copy), Skeleton (copy), EnumsRadius (copy), FoundationText (copy)
	local v38 = useTokens()
	local v39 = useProfileJsonComponent(Enums.Components.CurrentlyPlaying)
	local v40 = useDispatch()
	local v41 = if not FFlagProfileCurrentlyPlayingEDPFromCard and not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then nil else useNavigation()
	local v42 = if not FFlagProfileCurrentlyPlayingEDPFromCard and not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then nil else useProfileWrapperContext()
	local v43 = v42 and v42.profileId
	local v44 = if not FFlagProfilePlatformImproveGameDetailsAnalytics then nil else useRoactService(RoactAnalyticsCommonGameEvents)
	local universeId = v39.universeId

	React.useEffect(function() -- line: 76
		-- upvalues: universeId (copy), v40 (copy), NetworkingGames (copy)
		if not universeId then
			return
		end

		v40(NetworkingGames.GetExperiencesDetails.API({ (tostring(universeId)) })):catch(function(p1) -- line: 80
			-- upvalues: universeId (copy)
			warn("CurrentlyPlaying: failed to fetch experience details for universeId", universeId, p1)
		end)
	end, {
		universeId,
		v40
	})

	local v46 = useSelector(function(p2) -- line: 85
		-- upvalues: getDeepValue (copy), universeId (copy)
		return getDeepValue(p2, `ProfilePlatform.Games.byGameId.{ tostring(universeId) }`)
	end)
	local v47 = v46 and v46.rootPlaceId
	local v48 = v46 and v46.name or ""
	local v49 = if not FFlagProfileCurrentlyPlayingEDPFromCard and not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then nil else React.useCallback(function(s1: string) -- line: 93
		-- upvalues: v47 (copy), FFlagProfilePlatformImproveGameDetailsAnalytics (copy), v44 (copy), universeId (copy), AppPage (copy), v43 (copy), v40 (copy), OpenGameDetails (copy), v41 (copy)
		if v47 == nil then
			return
		end

		if FFlagProfilePlatformImproveGameDetailsAnalytics then
			v44.reportOpenGameDetailFromProfileContext(v47, tostring(universeId), AppPage.ProfilePlatform, v43, s1)
		end

		v40(OpenGameDetails(tostring(universeId), v41, {
			mountAsFullView = true,
			showBackButton = true
		}))
	end, {
		universeId,
		v47,
		v43,
		v44,
		v40,
		v41
	})
	local v50 = if not FFlagProfileCurrentlyPlayingEDPFromCard then nil else React.useCallback(function() -- line: 125
		-- upvalues: v49 (copy)
		v49("ProfilePlatformCurrentlyPlayingCard")
	end, { v49 })
	local v51 = if not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then nil else React.useCallback(function() -- line: 131
		-- upvalues: v49 (copy)
		v49("ProfilePlatformCurrentlyPlayingThumbnail")
	end, { v49 })
	local v52 = if not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then nil else React.useCallback(function() -- line: 137
		-- upvalues: v49 (copy)
		v49("ProfilePlatformCurrentlyPlayingGameName")
	end, { v49 })
	local v53 = if not universeId then nil else getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Small)
	local v54, v55 = React.useState(if not v53 then Enum.AssetFetchStatus.None else ContentProvider:GetAssetFetchStatus(v53))

	React.useEffect(function() -- line: 148
		-- upvalues: v53 (copy), ContentProvider (copy), v55 (copy)
		if not v53 then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(v53):Connect(v55)

		return function() -- line: 154
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v53 })

	local v56 = getDeepValue(v39, "ageRecommendation.ageRecommendationSummary.ageRecommendation.displayNameWithHeaderShort")
	local v57 = v48 == "" or v54 == Enum.AssetFetchStatus.Loading

	React.useEffect(function() -- line: 165
		-- upvalues: FFlagProfileCurrentlyPlayingIXPEnabled (copy), universeId (copy), IXPService (copy), FStringSocialProfileCurrentlyPlayingLayer (copy)
		if FFlagProfileCurrentlyPlayingIXPEnabled and universeId then
			IXPService:LogFlagLinkedUserLayerExposure(FStringSocialProfileCurrentlyPlayingLayer)
		end
	end, { universeId })

	if not universeId then
		return nil
	end

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		size = UDim2.new(1, 0, 0, 0),
		layoutOrder = t1.layoutOrder
	}, {
		Content = React.createElement(View, {
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-shift-100",
			onActivated = if not FFlagProfileCurrentlyPlayingEDPFromCard or v57 then nil else v50,
			stateLayer = if not FFlagProfileCurrentlyPlayingEDPFromCard or v57 then nil else {
				affordance = StateLayerAffordance.None
			}
		}, {
			GameThumbnail = if v57 then React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v38.Size.Size_1000, v38.Size.Size_1000),
				Radius = EnumsRadius.Small
			}) else React.createElement(FoundationImage, {
				tag = "radius-small aspect-1-1 size-1000-1000 auto-xy align-y-center",
				LayoutOrder = 1,
				Image = v53,
				onActivated = if not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then nil else v51,
				stateLayer = if not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then nil else {
					affordance = StateLayerAffordance.None
				}
			}),
			TextStack = React.createElement(View, {
				tag = "col align-y-center fill gap-xsmall auto-y content-default",
				LayoutOrder = 2
			}, {
				GameTitle = if v57 then React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.7, 0, 0, v38.Typography.TitleMedium.FontSize),
					Radius = EnumsRadius.Small
				}) else if not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then React.createElement(FoundationText, {
					tag = "emphasis size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end",
					LayoutOrder = 1,
					Text = v48
				}) else React.createElement(View, {
					tag = "size-full-0 auto-y",
					LayoutOrder = 1,
					onActivated = v52,
					stateLayer = {
						affordance = StateLayerAffordance.None
					}
				}, {
					Label = React.createElement(FoundationText, {
						tag = "emphasis size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end",
						Text = v48
					})
				}),
				AgeRecommendationText = if v57 then React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.5, 0, 0, v38.Typography.BodyMedium.FontSize),
					Radius = EnumsRadius.Small
				}) else React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
					LayoutOrder = 2,
					Text = v56
				})
			})
		})
	})
end

return CurrentlyPlaying
