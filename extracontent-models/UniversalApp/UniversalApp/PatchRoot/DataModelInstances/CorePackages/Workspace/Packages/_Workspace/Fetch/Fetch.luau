local scriptParent = script.Parent

require(scriptParent.LuauPolyfill)

local Headers = require(script.Headers).Headers
local Request = require(script.Request).Request
local Response = require(script.Response).Response
local Body = require(script.Body).Body
local fetch = require(script.fetch)
local v7 = fetch(game:GetService("HttpService"))
local AbortSignal = require(script.AbortSignal).AbortSignal

return {
	Headers = Headers,
	Request = Request,
	Response = Response,
	Body = Body,
	fetch = v7,
	buildFetch = fetch,
	AbortSignal = AbortSignal
}
