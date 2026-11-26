local fVariable = tonumber(settings():GetFVariable("PercentReportingNetworkProfileAfterStartup"))

local v5 = {}
v5.__index = v5

v5.aggregate = {
	queued = 0,
	nameLookup = 0,
	connect = 0,
	sslHandshake = 0,
	makeRequest = 0,
	receiveResponse = 0
}

function v5:track(data)
	self.aggregate.queued = self.aggregate.queued + data.queued

	if data.nameLookup >= 0 then
		self.aggregate.nameLookup = self.aggregate.nameLookup + data.nameLookup
	end

	if data.connect >= 0 then
		self.aggregate.connect = self.aggregate.connect + data.connect
	end

	if data.sslHandshake >= 0 then
		self.aggregate.sslHandshake = self.aggregate.sslHandshake + data.sslHandshake
	end

	if data.makeRequest >= 0 then
		self.aggregate.makeRequest = self.aggregate.makeRequest + data.makeRequest
	end

	if data.receiveResponse >= 0 then
		self.aggregate.receiveResponse = self.aggregate.receiveResponse + data.receiveResponse
	end
end

function v5.report(p2, callback)
	callback("NetworkProfileDuringStartup", "Queued", p2.aggregate.queued, fVariable)
	callback("NetworkProfileDuringStartup", "NameLookup", p2.aggregate.nameLookup, fVariable)
	callback("NetworkProfileDuringStartup", "Connect", p2.aggregate.connect, fVariable)
	callback("NetworkProfileDuringStartup", "SSLHandshake", p2.aggregate.sslHandshake, fVariable)
	callback("NetworkProfileDuringStartup", "MakeRequest", p2.aggregate.makeRequest, fVariable)
	callback("NetworkProfileDuringStartup", "ReceiveResponse", p2.aggregate.receiveResponse, fVariable)
end

return v5
