local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")

local TiltLoadingScreenView = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/TiltLoadingScreenView")
local useTiltLoadingScreenViewModel = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Hooks/useTiltLoadingScreenViewModel")
local useLoadingScreenAnimation = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Hooks/useLoadingScreenAnimation")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Hooks/useScreenSize")
local useViewportSettled = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Hooks/useViewportSettled")

local fFlagLoadingScreenMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagLoadingScreenMilestones
require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Types")
local contentId = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants").ContentId

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

local function TiltLoadingScreenContent(props)
	local v5 = useScreenSize()
	local v6 = useTiltLoadingScreenViewModel(props.placeId, v5, props.destinationUniverseId)
	local v7 = useViewportSettled(v5)
	local state, setState

	if fFlagLoadingScreenMilestones then
		state, setState = React.useState(nil)
	end

	local v8 = fFlagLoadingScreenMilestones and v7 and not props.isDismissing
	local v9 = not (v6.gameData == nil) and v6.gameData.name ~= ""
	local v10 = not (v6.gameData == nil) and v6.gameData.creator ~= ""
	local v11 = not (state == nil) and state == v6.thumbnailUrl
	local v12

	if fFlagLoadingScreenMilestones then
		v12 = React.useCallback(function(p2)
			local milestones = props.milestones
			local v13 = p2 == contentId.Title and v9 or p2 == contentId.Creator and v10

			if not v13 then
				v13 = p2 == contentId.Thumbnail and v11
			end

			if v13 and v8 and milestones then
				milestones.contentVisible(p2)
			end
		end, { v8, v9, v10, v11, props.milestones })
	else
		v12 = nil
	end

	local v16 = useLoadingScreenAnimation({
		reducedMotion = props.reducedMotion,
		contentReady = v6.gameData ~= nil and v7,
		isDismissing = props.isDismissing,
		onEnterComplete = props.onEnterComplete,
		onContentRevealComplete = v12
	})

	if fFlagLoadingScreenMilestones then
		React.useEffect(function()
			if v16.title.reveal:getValue() == 1 and v12 then
				v12(contentId.Title)
			end

			if v16.creator.reveal:getValue() == 1 and v12 then
				v12(contentId.Creator)
			end

			if v16.keyart.coverTransparency:getValue() == 1 and v12 then
				v12(contentId.Thumbnail)
			end
		end, { v16, v12 })
	end

	local createElement = React.createElement
	local v18 = {
		isMobile = v6.isMobile,
		isDirectionalInput = props.isDirectionalInput,
		gamepadCancelIcon = props.gamepadCancelIcon,
		chromeReveal = props.chromeReveal,
		animation = v16,
		gameData = v6.gameData,
		thumbnailUrl = v6.thumbnailUrl,
		onThumbnailLoaded = 0,
		isAutoTranslated = 0,
		statusPanel = 0,
		onCancel = 0,
		safeAreaInsets = 0,
		showContent = 0
	}

	if not fFlagLoadingScreenMilestones then
		setState = nil
	end

	v18.onThumbnailLoaded = setState
	v18.isAutoTranslated = v6.isAutoTranslated
	v18.statusPanel = v6.statusPanel
	v18.onCancel = props.onCancel
	v18.safeAreaInsets = props.safeAreaInsets
	v18.showContent = v7
	return createElement(TiltLoadingScreenView, v18)
end

return React.memo(TiltLoadingScreenContent)
