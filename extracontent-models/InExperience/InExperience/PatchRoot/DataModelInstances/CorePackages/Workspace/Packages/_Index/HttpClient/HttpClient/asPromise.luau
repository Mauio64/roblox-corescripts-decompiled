local parent = script:FindFirstAncestor("HttpClient").Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

require(script.Parent.types)
local FFlagHttpClientRetryExtensions = require(script.Parent.Flags.FFlagHttpClientRetryExtensions)

local v = {}

local function asPromise(p)
	local v2 = {}
	return Promise.new(function(callback, callback2, callback3)
		local flag = false
		local flag2 = false

		local function cleanupEffect() -- 2 equivalent calls inferred from this helper
			if flag2 then
				return
			end

			flag2 = true
			local v3 = v[v2]
			v[v2] = nil

			if v3 ~= nil then
				v3()
			end

			if FFlagHttpClientRetryExtensions then
				p.dispose()
			end
		end

		local function settle(data)
			if flag then
				return
			end

			flag = true
			cleanupEffect() -- inferred equivalent call

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

		local state = p.state(false)

		if state.status ~= "pending" then
			settle(state)
			return
		end

		local effect = Signals.createEffect(function(p2)
			local state2 = p.state(p2)

			if state2.status == "pending" then
				return
			end

			settle(state2)
		end)

		if flag2 then
			effect()
		else
			v[v2] = effect
		end

		callback3(function()
			if flag then
				return
			end

			flag = true
			cleanupEffect() -- inferred equivalent call
		end)
	end)
end

return asPromise
