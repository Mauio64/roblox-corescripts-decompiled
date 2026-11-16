local fVariable = tonumber(settings():GetFVariable("PercentReportingNetworkProfileAfterStartup"))

local NetworkProfiler = {}
NetworkProfiler.__index = NetworkProfiler

NetworkProfiler.aggregate = {
	queued = 0,
	nameLookup = 0,
	connect = 0,
	sslHandshake = 0,
	makeRequest = 0,
	receiveResponse = 0
}

function NetworkProfiler.track(p, data)
	p.aggregate.queued = p.aggregate.queued + data.queued

	if data.nameLookup >= 0 then
		p.aggregate.nameLookup = p.aggregate.nameLookup + data.nameLookup
	end

	if data.connect >= 0 then
		p.aggregate.connect = p.aggregate.connect + data.connect
	end

	if data.sslHandshake >= 0 then
		p.aggregate.sslHandshake = p.aggregate.sslHandshake + data.sslHandshake
	end

	if data.makeRequest >= 0 then
		p.aggregate.makeRequest = p.aggregate.makeRequest + data.makeRequest
	end

	if data.receiveResponse >= 0 then
		p.aggregate.receiveResponse = p.aggregate.receiveResponse + data.receiveResponse
	end
end

function NetworkProfiler.report(p, callback)
	callback("NetworkProfileDuringStartup", "Queued", p.aggregate.queued, fVariable)
	callback("NetworkProfileDuringStartup", "NameLookup", p.aggregate.nameLookup, fVariable)
	callback("NetworkProfileDuringStartup", "Connect", p.aggregate.connect, fVariable)
	callback("NetworkProfileDuringStartup", "SSLHandshake", p.aggregate.sslHandshake, fVariable)
	callback("NetworkProfileDuringStartup", "MakeRequest", p.aggregate.makeRequest, fVariable)
	callback("NetworkProfileDuringStartup", "ReceiveResponse", p.aggregate.receiveResponse, fVariable)
end

return NetworkProfiler
