local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)
local createEffect = Signals.createEffect

require(script.Parent.types)

local v = {}

local function onTerminal(callback, callback2, callback3)
	local v2 = {}
	local flag = false
	local flag2 = false

	local function cleanupEffect() -- 1 equivalent call inferred from this helper
		if flag2 then
			return
		end

		flag2 = true
		local v3 = v[v2]
		v[v2] = nil

		if v3 ~= nil then
			v3()
		end
	end

	local function settle(data) -- 2 equivalent calls inferred from this helper
		if flag then
			return
		end

		flag = true
		cleanupEffect() -- inferred equivalent call

		if data.status == "succeeded" and callback2 then
			callback2(data.result)
		elseif data.status == "failed" and callback3 then
			callback3(data.error or "request failed", data.errorCode)
		end
	end

	local v3 = callback(false)

	if v3.status == "pending" then
		local effect = createEffect(function(p)
			local v4 = callback(p)

			if v4.status == "pending" then
				return
			end

			settle(v4) -- inferred equivalent call
		end)

		if flag2 then
			effect()
		else
			v[v2] = effect
		end
	else
		settle(v3) -- inferred equivalent call
	end
end

return onTerminal
