local ParentParent = script.Parent.Parent
local createSignal = require(ParentParent.Signals).createSignal

require(script.Parent.types)

local HttpService = game:GetService("HttpService")

local function fetch(p1) -- line: 16
	-- upvalues: createSignal (copy), HttpService (copy)
	local v6, v7 = createSignal(function() -- line: 17
		return {
			status = "pending"
		}
	end)
	local v8 = HttpService:RequestInternal(p1)

	v8:Start(function(b1: boolean, p2) -- line: 23
		-- upvalues: v7 (copy)
		if b1 then
			v7({
				status = "success",
				data = p2
			})

			return
		end

		v7({
			status = "error",
			error = p2
		})
	end)

	local function cancelRequest() -- line: 31
		-- upvalues: v8 (copy)
		v8:Cancel()
	end

	return v6, cancelRequest
end

return fetch
