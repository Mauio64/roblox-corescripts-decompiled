local parent = script.Parent.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

require(script.Parent.types)

local HttpService = game:GetService("HttpService")

local function fetch(p)
	local signal, v = createSignal(function()
		return { status = "pending" }
	end)

	local internal = HttpService:RequestInternal(p)

	internal:Start(function(flag: boolean, err)
		if flag then
			v({ status = "success", data = err })
		else
			v({ status = "error", error = err })
		end
	end)

	local function cancelRequest()
		internal:Cancel()
	end

	return signal, cancelRequest
end

return fetch
