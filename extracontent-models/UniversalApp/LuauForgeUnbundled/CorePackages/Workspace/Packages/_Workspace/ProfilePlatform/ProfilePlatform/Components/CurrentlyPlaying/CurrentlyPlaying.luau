local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local horizontalPageMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Container.HorizontalPageMargin
local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local skeleton = Foundation.Skeleton
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local radius = Foundation.Enums.Radius
local thumbnailSize = Foundation.Enums.ThumbnailSize
local thumbnailType = Foundation.Enums.ThumbnailType
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local module6 = require("@luauforge/bundled/feH")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local module8 = require("@luauforge/bundled/fkN")

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameDetail").OpenGameDetails
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").RoactAnalyticsCommonGameEvents
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local ContentProvider = game:GetService("ContentProvider")

local FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail")
local FFlagProfileCurrentlyPlayingEDPFromCard = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileCurrentlyPlayingEDPFromCard")

local fFlagProfilePlatformImproveGameDetailsAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformImproveGameDetailsAnalytics
local fFlagJoinabilityCTAContextCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagJoinabilityCTAContextCopy

local function CurrentlyPlaying(p2)
	local v5 = useTokens()
	local v6 = useProfileJsonComponent(Enums.Components.CurrentlyPlaying)
	local v7 = useDispatch()

	local v8 = if FFlagProfileCurrentlyPlayingEDPFromCard or FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then useNavigation() else nil

	local v9 = if FFlagProfileCurrentlyPlayingEDPFromCard or FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then useProfileWrapperContext() else nil

	local profileId = v9 and v9.profileId
	local v10

	if fFlagProfilePlatformImproveGameDetailsAnalytics then
		v10 = useRoactService(roactAnalyticsCommonGameEvents)
	else
		v10 = nil
	end

	local v11

	if fFlagJoinabilityCTAContextCopy then
		v11 = useLocalization({
			playTogether = TextKeys.PlayTogether,
			playTogetherSoon = TextKeys.PlayTogetherSoon
		})
	end

	local universeId = v6.universeId

	React.useEffect(function()
		if not universeId then
			return
		end

		v7(module8.GetExperiencesDetails.API({ (tostring(universeId)) })):catch(function(p3)
			warn("CurrentlyPlaying: failed to fetch experience details for universeId", universeId, p3)
		end)
	end, { universeId, v7 })

	local v12 = useSelector(function(p3)
		return module6(p3, `ProfilePlatform.Games.byGameId.{tostring(universeId)}`)
	end)

	local rootPlaceId = v12 and v12.rootPlaceId
	local name = v12 and v12.name or ""
	local v13

	if FFlagProfileCurrentlyPlayingEDPFromCard or FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		v13 = React.useCallback(function(p3)
			if rootPlaceId == nil then
				return
			end

			if fFlagProfilePlatformImproveGameDetailsAnalytics then
				v10.reportOpenGameDetailFromProfileContext(
					rootPlaceId,
					tostring(universeId),
					appPage.ProfilePlatform,
					profileId,
					p3
				)
			end

			v7(openGameDetails(tostring(universeId), v8, {
				mountAsFullView = true,
				showBackButton = true
			}))
		end, { universeId, rootPlaceId, profileId, v10, v7, v8 })
	else
		v13 = nil
	end

	local v14

	if FFlagProfileCurrentlyPlayingEDPFromCard then
		v14 = React.useCallback(function()
			v13("ProfilePlatformCurrentlyPlayingCard")
		end, { v13 })
	end

	local v15

	if FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		v15 = React.useCallback(function()
			v13("ProfilePlatformCurrentlyPlayingThumbnail")
		end, { v13 })
	end

	local v16

	if FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		v16 = React.useCallback(function()
			v13("ProfilePlatformCurrentlyPlayingGameName")
		end, { v13 })
	end

	local v17

	if universeId then
		v17 = getRbxThumb(thumbnailType.GameIcon, universeId, thumbnailSize.Small)
	else
		v17 = nil
	end

	local useState = React.useState
	local v18 = if v17 then ContentProvider:GetAssetFetchStatus(v17) else Enum.AssetFetchStatus.None
	local state, setState = useState(v18)

	React.useEffect(function()
		if not v17 then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(v17):Connect(setState)
		return function()
			connection:Disconnect()
		end
	end, { v17 })

	local v19 = module6(
		v6,
		"ageRecommendation.ageRecommendationSummary.ageRecommendation.displayNameWithHeaderShort"
	)

	local v20 = name == "" or state == Enum.AssetFetchStatus.Loading
	local v21

	if fFlagJoinabilityCTAContextCopy and not v20 then
		if v6.joinability == "Joinable" then
			v21 = v11.playTogether
		elseif v6.joinability == "NotJoinable" then
			v21 = v11.playTogetherSoon
		end
	end

	if not universeId then
		return nil
	end

	local createElement = React.createElement
	local v23 = {
		size = UDim2.new(1, 0, 0, 0),
		backgroundTransparency = 1,
		layoutOrder = p2.layoutOrder,
		useAutomaticSizing = true
	}

	local createElement2 = React.createElement

	if not FFlagProfileCurrentlyPlayingEDPFromCard or v20 then
		v14 = nil
	end

	local v26 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-shift-100",
		onActivated = v14,
		stateLayer = FFlagProfileCurrentlyPlayingEDPFromCard and not v20 and { affordance = stateLayerAffordance.None } or nil
	}
	local v28

	if v20 then
		v28 = React.createElement(skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_1000),
			Radius = radius.Small
		})
	else
		local createElement3 = React.createElement
		local v30 = {
			tag = "radius-small aspect-1-1 size-1000-1000 auto-xy align-y-center",
			LayoutOrder = 1,
			Image = v17,
			onActivated = nil,
			stateLayer = 0
		}

		if not FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
			v15 = nil
		end

		v30.onActivated = v15

		v30.stateLayer = FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail and { affordance = stateLayerAffordance.None } or nil
		v28 = createElement3(image, v30)
	end

	local createElement3 = React.createElement
	local v32

	if v20 then
		v32 = React.createElement(skeleton, {
			Size = UDim2.new(0.7, 0, 0, v5.Typography.TitleMedium.FontSize),
			Radius = radius.Small,
			LayoutOrder = 1
		})
	elseif FFlagProfileCurrentlyPlayingEDPFromNameAndThumbnail then
		v32 = React.createElement(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1,
			onActivated = v16,
			stateLayer = { affordance = stateLayerAffordance.None }
		}, {
			Label = React.createElement(text, {
				tag = "emphasis size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end",
				Text = name
			})
		})
	else
		v32 = React.createElement(text, {
			tag = "emphasis size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end",
			Text = name,
			LayoutOrder = 1
		})
	end

	local v33 = if v20 then React.createElement(skeleton, {
		Size = UDim2.new(0.5, 0, 0, v5.Typography.BodyMedium.FontSize),
		Radius = radius.Small,
		LayoutOrder = 2
	}) else React.createElement(text, {
		tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
		Text = v19,
		LayoutOrder = 2
	})

	local v34 = if v21 ~= nil then React.createElement(text, {
		tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
		Text = v21,
		LayoutOrder = 3
	}) else nil
	return createElement(horizontalPageMargin, v23, {
		Content = createElement2(view, v26, {
			GameThumbnail = v28,
			TextStack = createElement3(
				view,
				{
					tag = "col align-y-center fill gap-xsmall auto-y content-default",
					LayoutOrder = 2
				},
				{
					GameTitle = v32,
					AgeRecommendationText = v33,
					JoinabilityStatusText = v34
				}
			)
		})
	})
end

return CurrentlyPlaying
