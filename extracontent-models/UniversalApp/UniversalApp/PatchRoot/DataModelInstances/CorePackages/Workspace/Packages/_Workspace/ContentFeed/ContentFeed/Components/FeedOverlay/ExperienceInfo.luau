local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ExperienceService = require(ParentParentParent.ExperienceService).ExperienceService
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local RobloxAppEnums = require(ParentParentParent.RobloxAppEnums)
local UIBlox = require(ParentParentParent.UIBlox)
local AppPage = RobloxAppEnums.AppPage
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local FeedContext = require(ParentParent.App.FeedContext)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local getExperienceThumbnailImage = require(ParentParent.Utils.getExperienceThumbnailImage)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Networking = require(ParentParent.App.Networking)
local PlayButtonStates = require(ParentParentParent.GamePlayButton).PlayButtonStates
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local useAnalytics = require(ParentParent.Hooks.useAnalytics)
local useLocalization = Localization.Hooks.useLocalization
local usePlayButtonState = require(ParentParentParent.GamePlayButton).usePlayButtonState
local useNavigation = require(ParentParentParent.Navigation).useNavigation
local useSafeZoneOffsets = require(ParentParent.Hooks.useSafeZoneOffsets)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 53
	-- upvalues: useTokens (copy), React (copy), FeedContext (copy), useNavigation (copy), useSafeZoneOffsets (copy), useSelector (copy), getDeepValue (copy), useAnalytics (copy), usePlayButtonState (copy), Networking (copy), PlayButtonStates (copy), EventNames (copy), AppPage (copy), ExperienceService (copy), Constants (copy), useLocalization (copy), View (copy), LoadableImage (copy), getExperienceThumbnailImage (copy), FoundationText (copy), Skeleton (copy), Icon (copy)
	local v32 = useTokens()
	local v33 = React.useContext(FeedContext)
	local v34 = useNavigation()
	local v35 = useSafeZoneOffsets()
	local v36 = useSelector(function(p1) -- line: 61
		-- upvalues: getDeepValue (copy), t1 (copy)
		return getDeepValue(p1, "Games.byGameId." .. t1.universeId .. ".name")
	end)
	local v37 = useSelector(function(p2) -- line: 65
		-- upvalues: getDeepValue (copy), t1 (copy)
		return getDeepValue(p2, "Games.byGameId." .. t1.universeId .. ".rootPlaceId")
	end)
	local v38 = useSelector(function(p3) -- line: 69
		-- upvalues: getDeepValue (copy), t1 (copy)
		local v48 = getDeepValue(p3, "GameVotes." .. t1.universeId .. ".upVotes")
		local v49 = getDeepValue(p3, "GameVotes." .. t1.universeId .. ".downVotes")

		if not v48 or not v49 then
			return nil
		end

		return (math.round(100 * v48 / (v48 + v49)))
	end)
	local v39 = useAnalytics()
	local v40 = usePlayButtonState(Networking.ContentFeedNetworkImpl, (tostring(t1.universeId)))
	local s1 = "icons/common/play"

	if v40.playButtonState == PlayButtonStates.PaidAccess then
		s1 = "icons/common/robux"
	elseif v40.playButtonState ~= PlayButtonStates.Playable then
		s1 = "icons/actions/block"
	end

	local v42 = React.useCallback(function() -- line: 91
		-- upvalues: v33 (copy), v39 (copy), EventNames (copy), t1 (copy), v40 (copy), PlayButtonStates (copy), v34 (copy), AppPage (copy), ExperienceService (copy), v37 (copy), Constants (copy)
		if v33.isZooming then
			return
		end

		v39.fireEvent(EventNames.ContentFeedPlayButtonPressed, {
			postId = t1.postId
		})

		if v40.playButtonState == PlayButtonStates.PaidAccess then
			v34.goBack()
			v34.navigate(AppPage.GameDetail, {
				detail = tostring(t1.universeId),
				extraProps = {
					mountAsFullView = true
				}
			})
		end

		if v40.playButtonState == PlayButtonStates.Playable then
			ExperienceService:LaunchExperience({
				placeId = if not v37 then t1.placeId else v37
			}, Constants.LaunchExperienceSource)
		end
	end, {
		v33.isZooming,
		v34,
		v40.playButtonState,
		t1.placeId,
		t1.postId,
		t1.universeId,
		v37
	})
	local v43 = useLocalization({
		notRated = "Feature.ContentFeed.Label.NotRated",
		ratingPercentage = {
			"Feature.ContentFeed.Label.Rating",
			rating = tostring(v38)
		}
	})
	local v44 = v38 ~= v38

	return React.createElement(View, {
		tag = "bg-surface-100 auto-y size-full-0 row align-x-left align-y-center gap-small",
		LayoutOrder = t1.layoutOrder
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 20 + v35.bottom),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20),
			PaddingTop = UDim.new(0, 20)
		}),
		ExperienceThumbnail = React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			useShimmerAnimationWhileLoading = true,
			cornerRadius = UDim.new(0, v32.Radius.Medium),
			Image = getExperienceThumbnailImage(t1.universeId, 150),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(40, 40)
		}),
		ExperienceMetadata = React.createElement(View, {
			LayoutOrder = 2,
			tag = "auto-y bg-action-subtle grow col align-x-left align-y-center gap-xsmall"
		}, {
			ExperienceName = if not v36 then nil else React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "text-title-large content-action-emphasis text-truncate-end text-align-x-left text-align-y-top size-full-0 auto-y",
				Text = v36
			}),
			ExperienceNameShimmerPanel = if v36 then nil else React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(160, 15)
			}),
			ExperienceRating = if not v38 then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy content-default size-full-0 text-align-x-left text-align-y-top text-body-medium text-truncate-end",
				Text = if not v44 then v43.ratingPercentage else v43.notRated
			}),
			ExperienceRatingShimmerPanel = if v38 then nil else React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(160, 15)
			})
		}),
		JoinCTA = React.createElement(View, {
			LayoutOrder = 3,
			tag = "bg-action-emphasis size-2000-1000 radius-medium",
			isDisabled = v40.playButtonState ~= PlayButtonStates.Loading and (v40.playButtonState ~= PlayButtonStates.PaidAccess and v40.playButtonState ~= PlayButtonStates.Playable),
			onActivated = v42
		}, {
			PlayIcon = React.createElement(Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = s1,
				Position = UDim2.fromScale(0.5, 0.5),
				style = v32.Color.ActionEmphasis.Foreground
			})
		})
	})
end
