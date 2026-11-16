require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/InternalHttpStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/Types")

return {
	Instance = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/HttpStore"),
	createMockInstance = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/createMockInstance"),
	isHttpStoreFetchCancelled = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/isHttpStoreFetchCancelled")
}
