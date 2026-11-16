local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local Radius = Foundation.Enums.Radius
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ContentProvider = game:GetService("ContentProvider")

local FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail = require(ProfilePlatform.Flags.FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail)
local FFlagProfileCurrentlyPlayingEDPFromCard = require(ProfilePlatform.Flags.FFlagProfileCurrentlyPlayingEDPFromCard)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformImproveGameDetailsAnalytics = SharedFlags.FFlagProfilePlatformImproveGameDetailsAnalytics
local SharedFlags2 = require(parent.SharedFlags)
local FFlagJoinabilityCTAContextCopy = SharedFlags2.FFlagJoinabilityCTAContextCopy

local function CurrentlyPlaying(p)
	local v = useTokens()
	local v2 = useProfileJsonComponent(Enums.Components.CurrentlyPlaying)
	local v3 = useDispatch()
	local v4

	if FFlagProfileCurrentlyPlayingEDPFromCard or FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		v4 = useNavigation()
	else
		v4 = nil
	end

	local v5

	if FFlagProfileCurrentlyPlayingEDPFromCard or FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		v5 = useProfileWrapperContext()
	end

	local profileId = v5 and v5.profileId
	local v6

	if FFlagProfilePlatformImproveGameDetailsAnalytics then
		v6 = useRoactService(RoactAnalyticsCommonGameEvents)
	else
		v6 = nil
	end

	local v7

	if FFlagJoinabilityCTAContextCopy then
		v7 = useLocalization({
			playTogether = TextKeys.PlayTogether,
			playTogetherSoon = TextKeys.PlayTogetherSoon
		})
	end

	local universeId = v2.universeId

	React.useEffect(function()
		if not universeId then
			return
		end

		v3(NetworkingGames.GetExperiencesDetails.API({ (tostring(universeId)) })):catch(function(p2)
			warn("CurrentlyPlaying: failed to fetch experience details for universeId", universeId, p2)
		end)
	end, { universeId, v3 })

	local v8 = useSelector(function(p2)
		return getDeepValue(p2, `ProfilePlatform.Games.byGameId.{tostring(universeId)}`)
	end)

	local rootPlaceId = v8 and v8.rootPlaceId
	local name = v8 and v8.name or ""
	local v9

	if FFlagProfileCurrentlyPlayingEDPFromCard or FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		v9 = React.useCallback(function(p2: string)
			if rootPlaceId == nil then
				return
			end

			if FFlagProfilePlatformImproveGameDetailsAnalytics then
				v6.reportOpenGameDetailFromProfileContext(
					rootPlaceId,
					tostring(universeId),
					AppPage.ProfilePlatform,
					profileId,
					p2
				)
			end

			v3(OpenGameDetails(tostring(universeId), v4, {
				mountAsFullView = true,
				showBackButton = true
			}))
		end, { universeId, rootPlaceId, profileId, v6, v3, v4 })
	else
		v9 = nil
	end

	local onActivated

	if FFlagProfileCurrentlyPlayingEDPFromCard then
		onActivated = React.useCallback(function()
			v9("ProfilePlatformCurrentlyPlayingCard")
		end, { v9 })
	end

	local onActivated2

	if FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		onActivated2 = React.useCallback(function()
			v9("ProfilePlatformCurrentlyPlayingThumbnail")
		end, { v9 })
	end

	local onActivated3

	if FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		onActivated3 = React.useCallback(function()
			v9("ProfilePlatformCurrentlyPlayingGameName")
		end, { v9 })
	end

	local image

	if universeId then
		image = getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Small)
	else
		image = nil
	end

	local useState = React.useState
	local v10

	if image then
		v10 = ContentProvider:GetAssetFetchStatus(image)
	else
		v10 = Enum.AssetFetchStatus.None
	end

	local state, setState = useState(v10)

	React.useEffect(function()
		if not image then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(image):Connect(setState)
		return function()
			connection:Disconnect()
		end
	end, { image })

	local deepValue = getDeepValue(
		v2,
		"ageRecommendation.ageRecommendationSummary.ageRecommendation.displayNameWithHeaderShort"
	)

	local v11 = name == "" or state == Enum.AssetFetchStatus.Loading
	local text

	if FFlagJoinabilityCTAContextCopy and not v11 then
		if v2.joinability == "Joinable" then
			text = v7.playTogether
		elseif v2.joinability == "NotJoinable" then
			text = v7.playTogetherSoon
		end
	end

	if not universeId then
		return nil
	end

	local createElement = React.createElement
	local v12 = {
		size = UDim2.new(1, 0, 0, 0),
		backgroundTransparency = 1,
		layoutOrder = p.layoutOrder,
		useAutomaticSizing = true
	}

	local createElement2 = React.createElement

	if not FFlagProfileCurrentlyPlayingEDPFromCard or v11 then
		onActivated = nil
	end

	local v13 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-shift-100",
		onActivated = onActivated,
		stateLayer = FFlagProfileCurrentlyPlayingEDPFromCard and not v11 and {
			affordance = StateLayerAffordance.None
		} or nil
	}
	local gameThumbnail

	if v11 then
		gameThumbnail = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_1000),
			Radius = Radius.Small
		})
	else
		local createElement3 = React.createElement
		local v14 = {
			tag = "radius-small aspect-1-1 size-1000-1000 auto-xy align-y-center",
			LayoutOrder = 1,
			Image = image,
			onActivated = nil,
			stateLayer = 0
		}

		if not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
			onActivated2 = nil
		end

		v14.onActivated = onActivated2

		v14.stateLayer = FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail
			and { affordance = StateLayerAffordance.None }
			or nil
		gameThumbnail = createElement3(Image, v14)
	end

	local createElement3 = React.createElement
	local gameTitle

	if v11 then
		gameTitle = React.createElement(Skeleton, {
			Size = UDim2.new(0.7, 0, 0, v.Typography.TitleMedium.FontSize),
			Radius = Radius.Small,
			LayoutOrder = 1
		})
	elseif FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		gameTitle = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1,
			onActivated = onActivated3,
			stateLayer = { affordance = StateLayerAffordance.None }
		}, {
			Label = React.createElement(Text, {
				tag = "emphasis size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end",
				Text = name
			})
		})
	else
		gameTitle = React.createElement(Text, {
			tag = "emphasis size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end",
			Text = name,
			LayoutOrder = 1
		})
	end

	local ageRecommendationText

	if v11 then
		ageRecommendationText = React.createElement(Skeleton, {
			Size = UDim2.new(0.5, 0, 0, v.Typography.BodyMedium.FontSize),
			Radius = Radius.Small,
			LayoutOrder = 2
		})
	else
		ageRecommendationText = React.createElement(Text, {
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
			Text = deepValue,
			LayoutOrder = 2
		})
	end

	local joinabilityStatusText

	if text ~= nil then
		joinabilityStatusText = React.createElement(Text, {
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
			Text = text,
			LayoutOrder = 3
		})
	end

	return createElement(HorizontalPageMargin, v12, {
		Content = createElement2(View, v13, {
			GameThumbnail = gameThumbnail,
			TextStack = createElement3(
				View,
				{
					tag = "col align-y-center fill gap-xsmall auto-y content-default",
					LayoutOrder = 2
				},
				{
					GameTitle = gameTitle,
					AgeRecommendationText = ageRecommendationText,
					JoinabilityStatusText = joinabilityStatusText
				}
			)
		})
	})
end

return CurrentlyPlaying
