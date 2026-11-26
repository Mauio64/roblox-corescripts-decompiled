local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/UrlBuilder").UrlBase
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Fetch")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Promise")

local fetch = Fetch.fetch
local response = Fetch.Response

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "amp-v2-wizard-service/v1/entrypoint"
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "amp-v2-wizard-service/v1/continue"
})

local function postForFragment(p2, p3)
	return Promise.new(function(callback, callback2)
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
