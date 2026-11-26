local experienceService = require("@luauforge/deferred/eat").ExperienceService
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module2 = require("@luauforge/deferred/dZm")

local module3 = require("@luauforge/deferred/eaj")
local module4 = require("@luauforge/deferred/eau")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/LuaSocialLibrariesDeps")
local module6 = require("@luauforge/deferred/dZn")
local module7 = require("@luauforge/deferred/ear")

local appPage = module6.AppPage
local module8 = require("@luauforge/deferred/dZs")
local module9 = require("@luauforge/deferred/eam")
local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local module11 = require("@luauforge/deferred/eav")
local loadableImage = module7.App.Loading.LoadableImage
local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")
local playButtonStates = require("@luauforge/deferred/eaw").PlayButtonStates

local icon = module3.Icon
local skeleton = module3.Skeleton
local text = module3.Text
local view = module3.View

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/useAnalytics")
local useLocalization = module4.Hooks.useLocalization
local usePlayButtonState = require("@luauforge/deferred/eaw").usePlayButtonState
local useNavigation = require("@luauforge/deferred/eay").useNavigation
local module14 = require("@luauforge/deferred/eaz")
local useSelector = module2.Hooks.RoactRodux.useSelector
local useTokens = module3.Hooks.useTokens

return function(props)
	local v5 = useTokens()

	local v6 = React.useContext(CapturesContext)

	local v7 = useNavigation()
	local v8 = module14()

	local v9 = useSelector(function(p2)
		return getDeepValue(p2, "Games.byGameId." .. props.universeId .. ".name")
	end)

	local v10 = useSelector(function(p2)
		return getDeepValue(p2, "Games.byGameId." .. props.universeId .. ".rootPlaceId")
	end)

	local v11 = useSelector(function(p2)
		local deepValue = getDeepValue(p2, "GameVotes." .. props.universeId .. ".upVotes")
		local deepValue2 = getDeepValue(p2, "GameVotes." .. props.universeId .. ".downVotes")

		if deepValue and deepValue2 then
			return (math.round(100 * deepValue / (deepValue + deepValue2)))
		end

		return nil
	end)

	local v12 = useAnalytics()
	local v13 = usePlayButtonState(Networking.ContentFeedNetworkImpl, (tostring(props.universeId)))

	local v14 = v13.playButtonState == playButtonStates.PaidAccess and "icons/common/robux"
		or v13.playButtonState ~= playButtonStates.Playable and "icons/actions/block"
		or "icons/common/play"

	local v15 = React.useCallback(function()
		if v6.isZooming then
			return
		end

		v12.fireEvent(module9.ContentFeedPlayButtonPressed, { postId = props.postId })

		if v13.playButtonState == playButtonStates.PaidAccess then
			v7.goBack()
			v7.navigate(appPage.GameDetail, {
				detail = tostring(props.universeId),
				extraProps = { mountAsFullView = true }
			})
		end

		if v13.playButtonState == playButtonStates.Playable then
			local v18 = if v10 then v10 else props.placeId
			experienceService:LaunchExperience({ placeId = v18 }, module8.LaunchExperienceSource)
		end
	end, {
		v6.isZooming,
		v7,
		v13.playButtonState,
		props.placeId,
		props.postId,
		props.universeId,
		v10
	})

	local v16 = useLocalization({
		notRated = "Feature.ContentFeed.Label.NotRated",
		ratingPercentage = {
			"Feature.ContentFeed.Label.Rating",
			rating = tostring(v11)
		}
	})
	local v17 = v11 ~= v11
	local createElement = React.createElement
	local v19 = {
		LayoutOrder = props.layoutOrder,
		tag = "bg-surface-100 auto-y size-full-0 row align-x-left align-y-center gap-small"
	}

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 20 + v8.bottom),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20),
			PaddingTop = UDim.new(0, 20)
		}),
		ExperienceThumbnail = React.createElement(loadableImage, {
			BackgroundTransparency = 1,
			cornerRadius = UDim.new(0, v5.Radius.Medium),
			Image = module11(props.universeId, 150),
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(40, 40),
			useShimmerAnimationWhileLoading = true
		}),
		ExperienceMetadata = 0,
		JoinCTA = 0
	}

	local createElement2 = React.createElement

	local v23 = if v9 then React.createElement(text, {
		LayoutOrder = 1,
		tag = "text-title-large content-action-emphasis text-truncate-end text-align-x-left text-align-y-top size-full-0 auto-y",
		Text = v9
	}) else nil

	local v24 = if not v9 then React.createElement(skeleton, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(160, 15)
	}) else nil
	local v25

	if v11 then
		local createElement3 = React.createElement

		local v28 = if v17 then v16.notRated else v16.ratingPercentage
		v25 = createElement3(text, {
			LayoutOrder = 2,
			tag = "auto-xy content-default size-full-0 text-align-x-left text-align-y-top text-body-medium text-truncate-end",
			Text = v28
		})
	end

	local v26 = if not v11 then React.createElement(skeleton, {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(160, 15)
	}) else nil
	children.ExperienceMetadata = createElement2(
		view,
		{
			LayoutOrder = 2,
			tag = "auto-y bg-action-subtle grow col align-x-left align-y-center gap-xsmall"
		},
		{
			ExperienceName = v23,
			ExperienceNameShimmerPanel = v24,
			ExperienceRating = v25,
			ExperienceRatingShimmerPanel = v26
		}
	)

	children.JoinCTA = React.createElement(view, {
		isDisabled = v13.playButtonState ~= playButtonStates.Loading and v13.playButtonState ~= playButtonStates.PaidAccess and v13.playButtonState ~= playButtonStates.Playable,
		LayoutOrder = 3,
		onActivated = v15,
		tag = "bg-action-emphasis size-2000-1000 radius-medium"
	}, {
		PlayIcon = React.createElement(icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			name = v14,
			Position = UDim2.fromScale(0.5, 0.5),
			style = v5.Color.ActionEmphasis.Foreground
		})
	})
	return createElement(view, v19, children)
end
