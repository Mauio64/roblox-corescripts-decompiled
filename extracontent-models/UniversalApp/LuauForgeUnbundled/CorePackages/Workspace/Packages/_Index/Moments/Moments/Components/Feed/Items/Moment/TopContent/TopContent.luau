local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local fFlagMomentsServeEDPVideos = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsServeEDPVideos

local view = Foundation.View

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/VideoInfo")

local function TopContent(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-bottom gap-large size-full-0 auto-y"
	}

	local createElement2 = React.createElement

	local v9 = if fFlagMomentsServeEDPVideos then props.moment else nil
	return createElement(view, v6, {
		VideoInfo = createElement2(module4, { LayoutOrder = 1, moment = v9 }),
		ActionRail = React.createElement(module3, {
			LayoutOrder = 2,
			moment = props.moment,
			onOpenComments = props.onOpenComments
		})
	})
end

return React.memo(TopContent)
