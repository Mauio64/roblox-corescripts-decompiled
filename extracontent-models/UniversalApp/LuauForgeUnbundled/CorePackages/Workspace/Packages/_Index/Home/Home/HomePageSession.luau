local HttpService = game:GetService("HttpService")

local function newSessionId()
	return HttpService:GenerateGUID(false):lower()
end

local v5 = ""
local signal, v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Signals").createSignal(nil)

return {
	Get = function(p2)
		if v5 == "" then
			v5 = HttpService:GenerateGUID(false):lower()
		end

		return v5
	end,
	Refresh = function(self)
		v5 = HttpService:GenerateGUID(false):lower()
		return v5
	end,
	Adopt = function(self, value): boolean
		if value == "" then
			return false
		end

		v5 = value:lower()
		return true
	end,
	Commit = function(self, p2): boolean
		local v7 = self:Get()
		local v8 = signal(false)

		if v8 ~= nil and v8.sessionId == v7 then
			return false
		end

		v6({ sessionId = v7, requestId = p2 })
		return true
	end,
	GetCommitted = function(self)
		return signal(false)
	end,
	GetCommittedSignal = function(self)
		return signal
	end
}
