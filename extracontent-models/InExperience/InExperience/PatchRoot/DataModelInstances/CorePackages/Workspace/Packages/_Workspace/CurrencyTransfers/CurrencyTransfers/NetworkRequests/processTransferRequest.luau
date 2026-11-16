local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local UrlBuilder = require(parent.UrlBuilder)
local t = require(parent.t)
local Promise = require(parent.Promise)

local ProcessTransferModel = require(CurrencyTransfers.Models.ProcessTransferModel)
local HttpRequest = require(CurrencyTransfers.NetworkRequests.HttpRequest)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local function processTransferUrl(transferRequestId: string) -- 1 equivalent call inferred from this helper
	return urlBuilder.new({
		base = UrlBase.APIS,
		path = `transfer/v1/robux-transfer/process-transfer/{transferRequestId}`
	})()
end

local strictInterface = t.strictInterface({ transferRequestId = t.string, robuxAmount = t.number })

local function processTransferRequest(p, p2, p3)
	assert(strictInterface(p))
	local v

	if p3 == nil then
		v = HttpRequest.new(p2)
	else
		v = HttpRequest.fromNetworkImpl(p3)
	end

	return v:post(processTransferUrl(p.transferRequestId), { robuxAmount = p.robuxAmount }):andThen(function(p4) -- inferred equivalent call
		return ProcessTransferModel.format(p4)
	end):catch(function(p4)
		return Promise.reject(p4)
	end)
end

return processTransferRequest
