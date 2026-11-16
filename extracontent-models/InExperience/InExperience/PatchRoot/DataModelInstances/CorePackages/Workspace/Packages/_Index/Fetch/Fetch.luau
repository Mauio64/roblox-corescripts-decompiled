local parent = script.Parent
require(parent.LuauPolyfill)

local Headers = require(script.Headers)
local headers = Headers.Headers

local Request = require(script.Request)
local request = Request.Request

local Response = require(script.Response)
local response = Response.Response

local Body = require(script.Body)
local body = Body.Body

local fetch = require(script.fetch)
local fetch2 = fetch(game:GetService("HttpService"))

local AbortSignal = require(script.AbortSignal)
return {
	Headers = headers,
	Request = request,
	Response = response,
	Body = body,
	fetch = fetch2,
	buildFetch = fetch,
	AbortSignal = AbortSignal.AbortSignal
}
