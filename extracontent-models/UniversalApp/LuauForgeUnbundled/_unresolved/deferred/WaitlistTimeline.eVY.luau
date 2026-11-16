local module = require("@luauforge/deferred/egU")

local view = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation").View

require("@luauforge/deferred/eVX")
local module2 = require("@luauforge/deferred/eVZ")

local function WaitlistTimeline(props)
	local stages = props.stages

	local children = {}

	for k, stage in stages do
		children["Stage" .. k] = module.createElement(module2, {
			LayoutOrder = k,
			stage = stage,
			remainingCount = props.remainingCount,
			isFirst = k == 1,
			isLast = k == #stages
		})
	end

	return module.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col size-full-0 auto-y padding-medium radius-medium bg-surface-100"
		},
		children
	)
end

return WaitlistTimeline
