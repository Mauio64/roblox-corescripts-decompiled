local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpClient/Promise")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpClient/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")
local FFlagHttpClientRetryExtensions = require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/Flags/FFlagHttpClientRetryExtensions")

local v5 = {}

local function asPromise(p2)
	local v6 = {}
	return Promise.new(function(callback, callback2, callback3)
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

			if FFlagHttpClientRetryExtensions then
				p2.dispose()
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

				if FFlagHttpClientRetryExtensions then
					p2.dispose()
				end
			end

			if data.status == "succeeded" then
				callback(data.result)
			elseif FFlagHttpClientRetryExtensions then
				callback2({
					responseCode = data.errorCode,
					errorMessage = data.error,
					response = data.response
				})
			else
				callback2({ responseCode = data.errorCode, errorMessage = data.error })
			end
		end

		local state = p2.state(false)

		if state.status ~= "pending" then
			settle(state)
			return
		end

		local effect = Signals.createEffect(function(p3)
			local state2 = p2.state(p3)

			if state2.status == "pending" then
				return
			end

			settle(state2)
		end)

		if flag2 then
			effect()
		else
			v5[v6] = effect
		end

		callback3(function()
			if flag then
				return
			end

			flag = true

			if flag2 then
				return
			end

			flag2 = true
			local v7 = v5[v6]
			v5[v6] = nil

			if v7 ~= nil then
				v7()
			end

			if FFlagHttpClientRetryExtensions then
				p2.dispose()
			end
		end)
	end)
end

return asPromise
