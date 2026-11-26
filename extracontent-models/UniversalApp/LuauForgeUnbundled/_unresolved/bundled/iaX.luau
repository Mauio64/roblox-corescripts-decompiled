local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/bundled/iaY")

local module3 = require("@luauforge/bundled/dFu")

local module4 = require("@luauforge/bundled/iaZ")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local extended = module.Component:extend("RouterAnalyticsReporter")

function extended.render(p2)
	local v5 = p2.props.currentPage

	if v5 then
		if v5 == module3.None then
			v5 = false
		else
			v5 = module.createElement(module2, { currentPageGoal = v5 })
		end
	end

	return v5
end

function extended.didUpdate(p2, p3)
	local currentPage = p2.props.currentPage
	local analytics = p2.props.analytics

	if currentPage ~= p3.currentPage and analytics then
		analytics.reportPageChanged(currentPage)
	end
end

return roactServices.connect({ analytics = module4 })(extended)
