local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local fFlagProfileRenderAvatarMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagProfileRenderAvatarMoments
local FFlagMomentsAvatarSceneStage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsAvatarSceneStage")

local MomentItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentItem")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function AvatarMomentView(props)
	local v5 = React.createElement(MomentsCommon.Media.MomentMediaView, {
		momentId = props.moment.momentId,
		suppressTapToToggle = true,
		getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
	})

	if FFlagMomentsAvatarSceneStage and props.viewportFrameRef ~= nil then
		v5 = React.createElement(Foundation.View, {
			backgroundStyle = { Transparency = 1 },
			tag = "size-full"
		}, {
			SceneViewport = React.createElement(
				"ViewportFrame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 0,
					ref = props.viewportFrameRef
				},
				{
					WorldModel = React.createElement("WorldModel", {
						ref = props.worldModelRef
					})
				}
			),
			Media = v5
		})
	end

	local createElement = React.createElement
	local view = Foundation.View

	local v7 = if fFlagProfileRenderAvatarMoments or FFlagMomentsAvatarSceneStage then props.pageRef else nil
	return createElement(view, {
		backgroundStyle = { Transparency = 1 },
		tag = "size-full",
		ref = v7
	}, {
		Moment = React.createElement(MomentItem, {
			data = props.data,
			moment = props.moment,
			mediaSurface = v5,
			isStaticMedia = true,
			isWorkspaceRendered = true
		})
	})
end

return AvatarMomentView
