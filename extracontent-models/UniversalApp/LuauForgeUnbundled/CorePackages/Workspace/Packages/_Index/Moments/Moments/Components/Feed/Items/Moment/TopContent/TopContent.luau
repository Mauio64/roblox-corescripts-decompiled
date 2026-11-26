local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local fFlagMomentsServeEDPVideos = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsServeEDPVideos
local fFlagMomentsPostFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsPostFeedback

local view = Foundation.View

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/VideoInfo")

local function TopContent(props)
	local v5 = if fFlagMomentsPostFeedback then MomentContext.useMoment().store.getData(false) else nil
	local v6 = not (v5 == nil or v5.kind ~= "experience") and v5.isPending == true

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-bottom gap-large size-full-0 auto-y"
	}

	local createElement2 = React.createElement

	local v12 = if fFlagMomentsServeEDPVideos then props.moment else nil
	local v9 = {
		VideoInfo = createElement2(module5, { LayoutOrder = 1, moment = v12 }),
		ActionRail = 0
	}

	local v13 = if not v6 then React.createElement(module3, {
		LayoutOrder = 2,
		moment = props.moment,
		onOpenComments = props.onOpenComments
	}) else nil
	v9.ActionRail = v13
	return createElement(view, v8, v9)
end

return React.memo(TopContent)
