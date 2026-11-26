require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")
local decoders = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/decoders")
local encoders = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/encoders")
local statusCodeActions = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/statusCodeActions")

return {
	fetch = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/fetch"),
	asPromise = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/asPromise"),
	createMockNetwork = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/createMockNetwork"),
	addStatusCodeAction = statusCodeActions.add,
	removeStatusCodeAction = statusCodeActions.remove,
	createRequest = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/createRequest"),
	createRequestInternalNetwork = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/createRequestInternalNetwork"),
	createRequestAsyncNetwork = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/createRequestAsyncNetwork"),
	withRetry = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/withRetry"),
	encodeRaw = encoders.encodeRaw,
	decodeJson = decoders.decodeJson,
	decodeLegacyJson = decoders.decodeLegacyJson
}
