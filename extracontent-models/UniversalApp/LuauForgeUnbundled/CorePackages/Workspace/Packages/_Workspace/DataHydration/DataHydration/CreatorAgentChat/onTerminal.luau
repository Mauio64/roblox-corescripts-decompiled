local createEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals").createEffect

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local v5 = {}

local function onTerminal(callback, callback2, callback3)
	local v6 = {}
	local flag = false
	local flag2 = false

	local function cleanupEffect()
		if flag2 then
			return
		end

		flag2 = true
		local v7 = v5[v6]
		v5[v6] = nil

		if v7 ~= nil then
			v7()
		end
	end

	local function settle(data)
		if flag then
			return
		end

		flag = true

		if not flag2 then
			flag2 = true
			local v7 = v5[v6]
			v5[v6] = nil

			if v7 ~= nil then
				v7()
			end
		end

		if data.status == "succeeded" and callback2 then
			callback2(data.result)
		elseif data.status == "failed" and callback3 then
			callback3(data.error or "request failed", data.errorCode)
		end
	end

	local v7 = callback(false)

	if v7.status == "pending" then
		local effect = createEffect(function(p2)
			local v8 = callback(p2)

			if v8.status == "pending" or flag then
				return
			end

			flag = true

			if not flag2 then
				flag2 = true
				local v9 = v5[v6]
				v5[v6] = nil

				if v9 ~= nil then
					v9()
				end
			end

			if v8.status == "succeeded" and callback2 then
				callback2(v8.result)
			elseif v8.status == "failed" and callback3 then
				callback3(v8.error or "request failed", v8.errorCode)
			end
		end)

		if flag2 then
			effect()
		else
			v5[v6] = effect
		end
	elseif not flag then
		flag = true

		if not flag2 then
			flag2 = true
			local v8 = v5[v6]
			v5[v6] = nil

			if v8 ~= nil then
				v8()
			end
		end

		if v7.status == "succeeded" and callback2 then
			callback2(v7.result)
		elseif v7.status == "failed" and callback3 then
			callback3(v7.error or "request failed", v7.errorCode)
		end
	end
end

return onTerminal
