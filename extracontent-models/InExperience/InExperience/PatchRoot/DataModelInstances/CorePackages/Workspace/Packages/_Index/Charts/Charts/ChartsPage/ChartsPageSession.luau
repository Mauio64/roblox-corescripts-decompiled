local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent.Parent

local Signals = require(parent.Signals)

local signal, v = Signals.createSignal("")
local ChartsPageSession = {}

function ChartsPageSession.Get(_)
	local v2 = signal(false)

	if v2 == "" then
		v2 = HttpService:GenerateGUID(false)
		v(v2)
	end

	return v2
end

function ChartsPageSession.Refresh(_)
	local guid = HttpService:GenerateGUID(false)
	v(guid)
	return guid
end

function ChartsPageSession.GetSignal(_)
	return signal
end

return ChartsPageSession
