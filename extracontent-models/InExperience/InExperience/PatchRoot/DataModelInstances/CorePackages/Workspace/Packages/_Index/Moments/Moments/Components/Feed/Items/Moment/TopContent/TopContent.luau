local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.MomentsTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos

local View = Foundation.View

local ActionRail = require(script.Parent.ActionRail)
local VideoInfo = require(script.Parent.VideoInfo)

local function TopContent(props)
	local createElement = React.createElement
	local v = {
		LayoutOrder = props.LayoutOrder,
		tag = "row align-x-left align-y-bottom gap-large size-full-0 auto-y"
	}

	local createElement2 = React.createElement
	local moment

	if FFlagMomentsServeEDPVideos then
		moment = props.moment
	end

	return createElement(View, v, {
		VideoInfo = createElement2(VideoInfo, { LayoutOrder = 1, moment = moment }),
		ActionRail = React.createElement(ActionRail, {
			LayoutOrder = 2,
			moment = props.moment,
			onOpenComments = props.onOpenComments
		})
	})
end

return React.memo(TopContent)
