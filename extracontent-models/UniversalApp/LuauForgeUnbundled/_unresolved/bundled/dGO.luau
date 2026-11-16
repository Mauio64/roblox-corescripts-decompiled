local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local analytics = require("@luauforge/bundled/dGM").Analytics.new(RbxAnalyticsService)

local defineFastString = game:DefineFastString("LoginInfoOverflowedCounter", "LoginInfoOverflowed")

return {
	loginInfoOverflowed = function()
		analytics.Diag:reportCounter(defineFastString, 1)
	end
}
