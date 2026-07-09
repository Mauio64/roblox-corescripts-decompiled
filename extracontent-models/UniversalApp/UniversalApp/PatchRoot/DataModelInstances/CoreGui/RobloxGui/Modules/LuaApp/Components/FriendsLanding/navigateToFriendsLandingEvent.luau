local CorePackages = game:GetService("CorePackages")
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local Analytics = require(CorePackages.Workspace.Packages.Analytics).Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local t = require(CorePackages.Packages.t)
local t1 = {
	homePage = game:DefineFastString("HomePageNavigationFriendsLandingCounter", "HomePageNavigationFriendsLanding"),
	morePage = game:DefineFastString("MorePageNavigationFriendsLandingCounter", "MorePageNavigationFriendsLanding")
}
local v7 = t.strictInterface({
	localUserId = t.string,
	context = t.string,
	analytics = t.optional(t.table)
})

return function(p1) -- line: 20
	-- upvalues: v7 (copy), Analytics (copy), RbxAnalyticsService (copy), t1 (copy), Logger (copy)
	assert(v7(p1))

	local v9 = p1.analytics or Analytics.new(RbxAnalyticsService)

	if t1[p1.context] then
		v9.EventStream:setRBXEventStream(p1.context, "buttonClick", {
			btn = "friendsLanding",
			uid = p1.localUserId
		})
		v9.Diag:reportCounter(t1[p1.context], 1)

		return
	end

	Logger:error("Error from navigate: Invalid destination '{}'", p1.context)
end
