local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpSignals/Signals").createSignal

require("@game/CorePackages/Workspace/Packages/_Index/HttpSignals/HttpSignals/types")

local HttpService = game:GetService("HttpService")

local function fetch(p2)
	local signal, v5 = createSignal(function()
		return { status = "pending" }
	end)

	local internal = HttpService:RequestInternal(p2)

	internal:Start(function(p3, p4)
		if p3 then
			v5({ status = "success", data = p4 })
		else
			v5({ status = "error", error = p4 })
		end
	end)

	local function cancelRequest()
		internal:Cancel()
	end

	return signal, cancelRequest
end

return fetch
