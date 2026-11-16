local PolicyService = game:GetService("PolicyService")
local Players = game:GetService("Players")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local Promise = require(parent2.Promise)

local Logger = require(parent.Logger)

return function(options)
	local v = options or {}
	v.PolicyService = v.PolicyService or PolicyService
	v.PlayersService = v.PlayersService or Players

	assert(v.PolicyService, "expected dependencies.PolicyService")
	assert(v.PlayersService, "expected dependencies.PlayersService")

	local policyService = v.PolicyService
	local playersService = v.PlayersService

	return function()
		return {
			read = function(): nil
				return nil
			end,
			onPolicyChanged = function(onEvent)
				local bindableEvent = Instance.new("BindableEvent")

				local eventConnection = bindableEvent.Event:Connect(onEvent)

				Promise.new(function(callback, callback2)
					local localPlayer = playersService.LocalPlayer

					if not localPlayer then
						callback2("LocalPlayer not found")

						return
					end

					local success, result = pcall(function()
						return policyService:GetPolicyInfoForPlayerAsync(localPlayer)
					end)

					if not success then
						callback2("GetPolicyInfoForPlayerAsync had an error when calling")
					elseif result then
						callback(result)
					else
						callback2("GetPolicyInfoForPlayerAsync return nil value")
					end
				end):andThen(function(p)
					bindableEvent:Fire(p)
				end):catch(function(p)
					Logger:warning("Could not fetch from PolicyService due to error: {}", p)
				end)

				return eventConnection
			end
		}
	end
end
