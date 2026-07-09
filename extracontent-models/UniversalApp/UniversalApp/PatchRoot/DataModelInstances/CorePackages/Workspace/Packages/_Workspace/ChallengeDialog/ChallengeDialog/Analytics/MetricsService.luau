local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ChallengeDialogParent = ChallengeDialog.Parent
local v4 = require(ChallengeDialogParent.Analytics).Analytics.new(RbxAnalyticsService)
local v5 = game:DefineFastString("LoginInfoOverflowedCounter", "LoginInfoOverflowed")

return {
	loginInfoOverflowed = function() -- line: 14
		-- upvalues: v4 (copy), v5 (copy)
		v4.Diag:reportCounter(v5, 1)
	end
}
