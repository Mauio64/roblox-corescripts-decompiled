local CorePackages = game:GetService("CorePackages")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local analytics = require("@luauforge/bundled/bXw").Analytics
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local t = require(CorePackages.Packages.t)

local v5 = {
	homePage = game:DefineFastString(
		"HomePageNavigationFriendsLandingCounter",
		"HomePageNavigationFriendsLanding"
	),
	morePage = game:DefineFastString(
		"MorePageNavigationFriendsLandingCounter",
		"MorePageNavigationFriendsLanding"
	)
}

local strictInterface = t.strictInterface({
	localUserId = t.string,
	context = t.string,
	analytics = t.optional(t.table)
})

return function(data)
	assert(strictInterface(data))
	local analytics2 = data.analytics or analytics.new(RbxAnalyticsService)

	if not v5[data.context] then
		logger:error("Error from navigate: Invalid destination '{}'", data.context)

		return
	end

	analytics2.EventStream:setRBXEventStream(data.context, "buttonClick", {
		uid = data.localUserId,
		btn = "friendsLanding"
	})

	analytics2.Diag:reportCounter(v5[data.context], 1)
end
