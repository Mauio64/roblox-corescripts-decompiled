local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.MomentsTypes)

local View = Foundation.View
local ActionRail = require(script.Parent.ActionRail)
local VideoInfo = require(script.Parent.VideoInfo)

local function TopContent(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), View (copy), VideoInfo (copy), ActionRail (copy)
	return React.createElement(View, {
		tag = "row align-x-left align-y-bottom gap-large size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		VideoInfo = React.createElement(VideoInfo, {
			LayoutOrder = 1
		}),
		ActionRail = React.createElement(ActionRail, {
			LayoutOrder = 2,
			moment = t1.moment
		})
	})
end

return React.memo(TopContent)
