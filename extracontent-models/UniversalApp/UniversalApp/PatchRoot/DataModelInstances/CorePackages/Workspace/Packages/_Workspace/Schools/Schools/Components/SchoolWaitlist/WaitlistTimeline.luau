local Parent = script:FindFirstAncestor("Schools").Parent
local React = require(Parent.React)
local View = require(Parent.Foundation).View

require(script.Parent.waitlistVariants)

local WaitlistTimelineStage = require(script.Parent.WaitlistTimelineStage)

local function WaitlistTimeline(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), WaitlistTimelineStage (copy), View (copy)
	local stages = t1.stages
	local t2 = {}

	for v9, v10 in stages do
		t2["Stage" .. v9] = React.createElement(WaitlistTimelineStage, {
			LayoutOrder = v9,
			stage = v10,
			remainingCount = t1.remainingCount,
			isFirst = v9 == 1,
			isLast = v9 == #stages
		})
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y padding-medium radius-medium bg-surface-100",
		LayoutOrder = t1.LayoutOrder
	}, t2)
end

return WaitlistTimeline
