local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local PageHeartbeatTimer = require(Modules.LuaApp.Components.Analytics.PageHeartbeatTimer)
local AppPage = require(Modules.LuaApp.AppPage)
local RoactAnalyticsAppRouter = require(Modules.LuaApp.Services.RoactAnalyticsAppRouter)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local v8 = Roact.Component:extend("RouterAnalyticsReporter")

function v8.render(p1) -- line: 14
	-- upvalues: AppPage (copy), Roact (copy), PageHeartbeatTimer (copy)
	local currentPage = p1.props.currentPage

	return currentPage and (currentPage ~= AppPage.None and Roact.createElement(PageHeartbeatTimer, {
		currentPageGoal = currentPage
	}))
end
function v8.didUpdate(p2, p3) -- line: 24
	local currentPage = p2.props.currentPage
	local analytics = p2.props.analytics

	if currentPage ~= p3.currentPage and analytics then
		analytics.reportPageChanged(currentPage)
	end
end

return RoactServices.connect({
	analytics = RoactAnalyticsAppRouter
})(v8)
