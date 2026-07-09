local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParent.AppFeaturePolicies)
require(scriptParentParent.AvatarPolicies)
require(scriptParentParent.SocialPolicies)

return {}
