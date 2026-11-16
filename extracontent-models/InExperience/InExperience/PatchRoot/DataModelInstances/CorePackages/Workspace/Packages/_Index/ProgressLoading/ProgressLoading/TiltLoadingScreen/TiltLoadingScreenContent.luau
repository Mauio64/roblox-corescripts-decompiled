local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local React = require(parent.React)

local TiltLoadingScreenView = require(script.Parent.TiltLoadingScreenView)
local useTiltLoadingScreenViewModel = require(script.Parent.Hooks.useTiltLoadingScreenViewModel)
local useLoadingScreenAnimation = require(script.Parent.Hooks.useLoadingScreenAnimation)
local useScreenSize = require(script.Parent.Hooks.useScreenSize)
local useViewportSettled = require(script.Parent.Hooks.useViewportSettled)

local SharedFlags = require(parent.SharedFlags)
local FFlagLoadingScreenMilestones = SharedFlags.FFlagLoadingScreenMilestones
require(ProgressLoading.LoadingScreenMilestones.Types)
local Constants = require(ProgressLoading.LoadingScreenMilestones.Constants)
local ContentId = Constants.ContentId

require(script.Parent.Types)

local function TiltLoadingScreenContent(props)
	local v = useScreenSize()
	local v2 = useTiltLoadingScreenViewModel(props.placeId, v, props.destinationUniverseId)
	local showContent = useViewportSettled(v)
	local state, setState

	if FFlagLoadingScreenMilestones then
		state, setState = React.useState(nil)
	end

	local v3 = FFlagLoadingScreenMilestones and showContent and not props.isDismissing
	local v4

	if v2.gameData == nil then
		v4 = false
	else
		v4 = v2.gameData.name ~= ""
	end

	local v5

	if v2.gameData == nil then
		v5 = false
	else
		v5 = v2.gameData.creator ~= ""
	end

	local v6

	if state == nil then
		v6 = false
	else
		v6 = state == v2.thumbnailUrl
	end

	local onContentRevealComplete

	if FFlagLoadingScreenMilestones then
		onContentRevealComplete = React.useCallback(function(p)
			local milestones = props.milestones
			local v7 = p == ContentId.Title and v4 or p == ContentId.Creator and v5

			if not v7 then
				v7 = p == ContentId.Thumbnail and v6
			end

			if v7 and v3 and milestones then
				milestones.contentVisible(p)
			end
		end, { v3, v4, v5, v6, props.milestones })
	else
		onContentRevealComplete = nil
	end

	local animation = useLoadingScreenAnimation({
		reducedMotion = props.reducedMotion,
		contentReady = v2.gameData ~= nil and showContent,
		isDismissing = props.isDismissing,
		onEnterComplete = props.onEnterComplete,
		onContentRevealComplete = onContentRevealComplete
	})

	if FFlagLoadingScreenMilestones then
		React.useEffect(function()
			if animation.title.reveal:getValue() == 1 and onContentRevealComplete then
				onContentRevealComplete(ContentId.Title)
			end

			if animation.creator.reveal:getValue() == 1 and onContentRevealComplete then
				onContentRevealComplete(ContentId.Creator)
			end

			if animation.keyart.coverTransparency:getValue() == 1 and onContentRevealComplete then
				onContentRevealComplete(ContentId.Thumbnail)
			end
		end, { animation, onContentRevealComplete })
	end

	local createElement = React.createElement
	local v7 = {
		isMobile = v2.isMobile,
		isDirectionalInput = props.isDirectionalInput,
		gamepadCancelIcon = props.gamepadCancelIcon,
		chromeReveal = props.chromeReveal,
		animation = animation,
		gameData = v2.gameData,
		thumbnailUrl = v2.thumbnailUrl,
		onThumbnailLoaded = 0,
		isAutoTranslated = 0,
		statusPanel = 0,
		onCancel = 0,
		safeAreaInsets = 0,
		showContent = 0
	}

	if not FFlagLoadingScreenMilestones then
		setState = nil
	end

	v7.onThumbnailLoaded = setState
	v7.isAutoTranslated = v2.isAutoTranslated
	v7.statusPanel = v2.statusPanel
	v7.onCancel = props.onCancel
	v7.safeAreaInsets = props.safeAreaInsets
	v7.showContent = showContent
	return createElement(TiltLoadingScreenView, v7)
end

return React.memo(TiltLoadingScreenContent)
