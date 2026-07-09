local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)

return function(p1, p2) -- line: 7
	-- upvalues: ParentParent (copy), Roact (copy)
	local RoactAppPolicy = require(ParentParent.UniversalAppPolicy).RoactAppPolicy
	local AppFeaturePolicies = require(ParentParent.UniversalAppPolicy).AppFeaturePolicies
	local ChatPolicies = require(ParentParent.SocialPolicies).ChatPolicies
	local AvatarPolicies = require(ParentParent.AvatarPolicies).AvatarPolicies
	local SharePolicies = require(ParentParent.SocialPolicies).SharePolicies
	local ShareTargetGamePolicies = require(ParentParent.SocialPolicies).ShareTargetGamePolicies
	local v11 = p2 or {}

	return Roact.createElement(RoactAppPolicy.Provider, {
		policy = {
			AppFeaturePolicies,
			ChatPolicies,
			AvatarPolicies,
			SharePolicies,
			ShareTargetGamePolicies
		},
		policyData = v11
	}, {
		Element = p1
	})
end
