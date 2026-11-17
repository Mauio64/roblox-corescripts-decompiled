local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.MomentsTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsPostFeedback = SharedFlags2.FFlagMomentsPostFeedback

local View = Foundation.View

local ActionRail = require(script.Parent.ActionRail)
local MomentContext = require(script.Parent.Parent.MomentContext)
local VideoInfo = require(script.Parent.VideoInfo)

local function TopContent(props)
	local v

	if FFlagMomentsPostFeedback then
		v = MomentContext.useMoment().store.getData(false)
	end

	local v2

	if v == nil or v.kind ~= "experience" then
		v2 = false
	else
		v2 = v.isPending == true
	end

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-bottom gap-large size-full-0 auto-y"
	}

	local createElement2 = React.createElement
	local moment

	if FFlagMomentsServeEDPVideos then
		moment = props.moment
	end

	local v4 = {
		VideoInfo = createElement2(VideoInfo, { LayoutOrder = 1, moment = moment }),
		ActionRail = 0
	}
	local actionRail

	if not v2 then
		actionRail = React.createElement(ActionRail, {
			LayoutOrder = 2,
			moment = props.moment,
			onOpenComments = props.onOpenComments
		})
	end

	v4.ActionRail = actionRail
	return createElement(View, v3, v4)
end

return React.memo(TopContent)
