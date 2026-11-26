local module = require("@luauforge/deferred/enn")
local module2 = require("@luauforge/deferred/enp")

local module3 = require("@luauforge/bundled/enl")

local text = module2.Text
local view = module2.View

local activitySection = module3.ActivitySection

local v5 = {
	[activitySection.Today] = "Today",
	[activitySection.EarlierThisWeek] = "Earlier this week",
	[activitySection.EarlierThisMonth] = "Earlier this month",
	[activitySection.EarlierThisYear] = "Earlier this year"
}

local function ActivitySectionHeader(p2)
	return module.createElement(
		view,
		{
			LayoutOrder = p2.layoutOrder,
			tag = "row align-y-center size-full-0 auto-y padding-x-medium padding-bottom-small padding-top-large"
		},
		{
			Title = module.createElement(text, {
				tag = "auto-xy text-heading-small content-emphasis",
				Text = v5[p2.section]
			})
		}
	)
end

return ActivitySectionHeader
