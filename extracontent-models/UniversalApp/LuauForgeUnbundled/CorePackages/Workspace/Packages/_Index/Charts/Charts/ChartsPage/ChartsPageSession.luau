local HttpService = game:GetService("HttpService")

local signal, v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/Signals").createSignal("")

return {
	Get = function(p2)
		local v6 = signal(false)

		if v6 == "" then
			v6 = HttpService:GenerateGUID(false)
			v5(v6)
		end

		return v6
	end,
	Refresh = function(self)
		local guid = HttpService:GenerateGUID(false)
		v5(guid)
		return guid
	end,
	GetSignal = function(p2)
		return signal
	end
}
