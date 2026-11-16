require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/PolicyTypes")
local module = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/Enum/CrossPlayCapabilities")

return {
	getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/getAppFeaturePolicies"),
	GetAppPolicyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/GetAppPolicyStore"),
	AppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/AppFeaturePolicies"),
	RoactAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/RoactAppPolicy"),
	UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/UniversalAppPolicy"),
	useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/useAppPolicy"),
	Enum = { CrossPlayCapabilities = module }
}
