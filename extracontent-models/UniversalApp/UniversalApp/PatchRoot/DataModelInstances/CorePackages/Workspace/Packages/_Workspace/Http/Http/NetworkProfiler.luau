local num = tonumber(settings():GetFVariable("PercentReportingNetworkProfileAfterStartup"))
local t1 = {}

t1.__index = t1
t1.aggregate = {
	queued = 0,
	nameLookup = 0,
	connect = 0,
	sslHandshake = 0,
	makeRequest = 0,
	receiveResponse = 0
}

function t1.track(p1, p2) -- line: 24
	p1.aggregate.queued = p1.aggregate.queued + p2.queued

	if p2.nameLookup >= 0 then
		p1.aggregate.nameLookup = p1.aggregate.nameLookup + p2.nameLookup
	end

	if p2.connect >= 0 then
		p1.aggregate.connect = p1.aggregate.connect + p2.connect
	end

	if p2.sslHandshake >= 0 then
		p1.aggregate.sslHandshake = p1.aggregate.sslHandshake + p2.sslHandshake
	end

	if p2.makeRequest >= 0 then
		p1.aggregate.makeRequest = p1.aggregate.makeRequest + p2.makeRequest
	end

	if p2.receiveResponse >= 0 then
		p1.aggregate.receiveResponse = p1.aggregate.receiveResponse + p2.receiveResponse
	end
end
function t1.report(p3, p4) -- line: 43
	-- upvalues: num (copy)
	p4("NetworkProfileDuringStartup", "Queued", p3.aggregate.queued, num)
	p4("NetworkProfileDuringStartup", "NameLookup", p3.aggregate.nameLookup, num)
	p4("NetworkProfileDuringStartup", "Connect", p3.aggregate.connect, num)
	p4("NetworkProfileDuringStartup", "SSLHandshake", p3.aggregate.sslHandshake, num)
	p4("NetworkProfileDuringStartup", "MakeRequest", p3.aggregate.makeRequest, num)
	p4("NetworkProfileDuringStartup", "ReceiveResponse", p3.aggregate.receiveResponse, num)
end

return t1
