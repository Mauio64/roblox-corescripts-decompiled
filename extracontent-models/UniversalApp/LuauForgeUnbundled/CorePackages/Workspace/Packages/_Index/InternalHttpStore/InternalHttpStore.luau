local HttpStoreTypes = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

return {
	createHttpStore = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/createHttpStore"),
	GetHttpStore = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/GetHttpStore"),
	HttpResponseStatus = HttpStoreTypes.HttpResponseStatus,
	createMockHttpStore = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/createMockHttpStore")
}
