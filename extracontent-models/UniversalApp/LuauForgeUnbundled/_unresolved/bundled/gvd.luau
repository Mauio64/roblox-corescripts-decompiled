local HttpService = game:GetService("HttpService")

local urlBuilder = require("@luauforge/bundled/gve").UrlBuilder
local urlBase = require("@luauforge/bundled/gve").UrlBase
local module = require("@luauforge/bundled/gvf")
local module2 = require("@luauforge/bundled/gvg")

local fetch = module.fetch
local response = module.Response

require("@luauforge/bundled/gvc")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "amp-v2-wizard-service/v1/entrypoint"
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "amp-v2-wizard-service/v1/continue"
})

local function postForFragment(p2, p3)
	return module2.new(function(callback, callback2)
		local expect = fetch(p2, {
			method = "POST",
			body = HttpService:JSONEncode(p3),
			headers = { ["Content-Type"] = "application/json" }
		}):catch(function()
			return response.error()
		end):expect()

		if not expect.ok then
			callback2(`Wizard flow request failed with status: {expect.status}`)
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback(expect2)
		else
			callback2("Failed to decode wizard flow response as JSON")
		end
	end)
end

local function serializeEntrypoint(data)
	return {
		target = data.target,
		flow = data.flow,
		surface = data.surface,
		client = data.client,
		extraProps = data.extraProps
	}
end

local function serializeContinue(data)
	return {
		flowId = data.flowId,
		state = data.state,
		target = data.target,
		rootFlow = data.rootFlow,
		flowInputs = data.flowInputs,
		history = data.history,
		payload = data.payload
	}
end

return {
	entrypoint = function(data)
		return postForFragment(v5(), {
			target = data.target,
			flow = data.flow,
			surface = data.surface,
			client = data.client,
			extraProps = data.extraProps
		})
	end,
	continue = function(data)
		return postForFragment(v6(), {
			flowId = data.flowId,
			state = data.state,
			target = data.target,
			rootFlow = data.rootFlow,
			flowInputs = data.flowInputs,
			history = data.history,
			payload = data.payload
		})
	end
}
