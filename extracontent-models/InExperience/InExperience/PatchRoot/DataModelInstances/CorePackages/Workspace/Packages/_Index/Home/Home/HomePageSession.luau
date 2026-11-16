local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("Home").Parent

local Signals = require(parent.Signals)

local function newSessionId() -- 2 equivalent calls inferred from this helper
	return HttpService:GenerateGUID(false):lower()
end

local v = ""
local signal, v2 = Signals.createSignal(nil)
local HomePageSession = {}

function HomePageSession:Get()
	if v == "" then
		v = newSessionId() -- inferred equivalent call
	end

	return v
end

function HomePageSession.Refresh(_)
	v = newSessionId() -- inferred equivalent call
	return v
end

function HomePageSession.Adopt(_, value: string): boolean
	if value == "" then
		return false
	end

	v = value:lower()
	return true
end

function HomePageSession:Commit(requestId: string?): boolean
	local sessionId = self:Get()
	local v3 = signal(false)

	if v3 ~= nil and v3.sessionId == sessionId then
		return false
	end

	v2({ sessionId = sessionId, requestId = requestId })
	return true
end

function HomePageSession.GetCommitted(_)
	return signal(false)
end

function HomePageSession.GetCommittedSignal(_)
	return signal
end

return HomePageSession
