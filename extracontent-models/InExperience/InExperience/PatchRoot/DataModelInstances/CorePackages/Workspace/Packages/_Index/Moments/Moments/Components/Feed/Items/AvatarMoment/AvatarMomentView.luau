local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagMomentsAvatarSceneStage = require(Moments.Flags.FFlagMomentsAvatarSceneStage)

local MomentItem = require(Moments.Components.Feed.Items.Moment.MomentItem)
require(Moments.Components.Feed.Items.Moment.MomentContext)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
require(parent.MomentsTypes)

local function AvatarMomentView(props)
	local v = React.createElement(MomentsCommon.Media.MomentMediaView, {
		momentId = props.moment.momentId,
		suppressTapToToggle = true,
		getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
	})

	if FFlagMomentsAvatarSceneStage and props.viewportFrameRef ~= nil then
		v = React.createElement(Foundation.View, {
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
					WorldModel = React.createElement("WorldModel", { ref = props.worldModelRef })
				}
			),
			Media = v
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local ref

	if FFlagProfileRenderAvatarMoments or FFlagMomentsAvatarSceneStage then
		ref = props.pageRef
	end

	return createElement(view, {
		backgroundStyle = { Transparency = 1 },
		tag = "size-full",
		ref = ref
	}, {
		Moment = React.createElement(MomentItem, {
			data = props.data,
			moment = props.moment,
			mediaSurface = v,
			isStaticMedia = true,
			isWorkspaceRendered = true
		})
	})
end

return AvatarMomentView
