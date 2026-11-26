local UniversalAppGetPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/UniversalAppGetPolicy")
local AppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/AppFeaturePolicies")

return function()
	return AppFeaturePolicies(UniversalAppGetPolicy.read() or {})
end
