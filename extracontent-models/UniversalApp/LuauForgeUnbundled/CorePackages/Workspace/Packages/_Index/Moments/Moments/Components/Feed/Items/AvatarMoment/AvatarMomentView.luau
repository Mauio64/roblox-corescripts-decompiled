local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local MomentItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentItem")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function AvatarMomentView(p2)
	local element = React.createElement(MomentsCommon.Media.MomentMediaView, {
		momentId = p2.moment.momentId,
		suppressTapToToggle = true,
		getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
	})

	return React.createElement(Foundation.View, {
		backgroundStyle = { Transparency = 1 },
		tag = "size-full"
	}, {
		Moment = React.createElement(MomentItem, {
			data = p2.data,
			moment = p2.moment,
			mediaSurface = element,
			isStaticMedia = true,
			isWorkspaceRendered = true
		})
	})
end

return AvatarMomentView
