local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Fetch = require(parent.Fetch)
local Promise = require(parent.Promise)

local fetch = Fetch.fetch
local Response = Fetch.Response

require(AmpV2Wizard.Types)

local v = urlBuilder.new({ base = UrlBase.APIS, path = "amp-v2-wizard-service/v1/entrypoint" })

local v2 = urlBuilder.new({ base = UrlBase.APIS, path = "amp-v2-wizard-service/v1/continue" })

local function postForFragment(p: string, p2)
	return Promise.new(function(callback, callback2)
		local expect = fetch(p, {
			method = "POST",
			body = HttpService:JSONEncode(p2),
			headers = { ["Content-Type"] = "application/json" }
		}):catch(function()
			return Response.error()
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

local function serializeEntrypoint(data) -- 1 equivalent call inferred from this helper
	return {
		target = data.target,
		flow = data.flow,
		surface = data.surface,
		client = data.client,
		extraProps = data.extraProps
	}
end

local function serializeContinue(data) -- 1 equivalent call inferred from this helper
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

local FlowApiProvider = {}

function FlowApiProvider.entrypoint(data)
	return postForFragment(v(), serializeEntrypoint(data)) -- inferred equivalent call
end

function FlowApiProvider.continue(data)
	return postForFragment(v2(), serializeContinue(data)) -- inferred equivalent call
end

return FlowApiProvider
