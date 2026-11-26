require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/LuauPolyfill")

local headers = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Headers").Headers

local request = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Request").Request

local response = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Response").Response

local body = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Body").Body

local module = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/fetch")
return {
	Headers = headers,
	Request = request,
	Response = response,
	Body = body,
	fetch = module(game:GetService("HttpService")),
	buildFetch = module,
	AbortSignal = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/AbortSignal").AbortSignal
}
