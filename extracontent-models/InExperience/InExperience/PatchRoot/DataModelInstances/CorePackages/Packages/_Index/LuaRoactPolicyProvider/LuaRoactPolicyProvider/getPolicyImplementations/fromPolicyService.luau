local PolicyService = game:GetService("PolicyService")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Promise = require(ParentParentParent.Promise)
local Logger = require(ParentParent.Logger)

return function(p1) -- line: 10
	-- upvalues: PolicyService (copy), Players (copy), Promise (copy), Logger (copy)
	local v8 = p1 or {}

	v8.PolicyService = v8.PolicyService or PolicyService
	v8.PlayersService = v8.PlayersService or Players
	assert(v8.PolicyService, "expected dependencies.PolicyService")
	assert(v8.PlayersService, "expected dependencies.PlayersService")

	local PolicyService2 = v8.PolicyService
	local PlayersService = v8.PlayersService

	return function() -- line: 21
		-- upvalues: Promise (copy), PlayersService (copy), PolicyService2 (copy), Logger (copy)
		return {
			read = function() -- line: 23
				return nil
			end,
			onPolicyChanged = function(p2) -- line: 27
				-- upvalues: Promise (copy), PlayersService (copy), PolicyService2 (copy), Logger (copy)
				local BindableEvent = Instance.new("BindableEvent")
				local connection = BindableEvent.Event:Connect(p2)

				Promise.new(function(resolve, reject) -- line: 33
					-- upvalues: PlayersService (copy), PolicyService2 (copy)
					local LocalPlayer = PlayersService.LocalPlayer

					if LocalPlayer then
						local ok, result = pcall(function() -- line: 36
							-- upvalues: PolicyService2 (copy), LocalPlayer (copy)
							return PolicyService2:GetPolicyInfoForPlayerAsync(LocalPlayer)
						end)

						if ok then
							if result then
								resolve(result)

								return
							end

							reject("GetPolicyInfoForPlayerAsync return nil value")

							return
						end

						reject("GetPolicyInfoForPlayerAsync had an error when calling")

						return
					end

					reject("LocalPlayer not found")
				end):andThen(function(p3) -- line: 52
					-- upvalues: BindableEvent (copy)
					BindableEvent:Fire(p3)
				end):catch(function(p4) -- line: 55
					-- upvalues: Logger (copy)
					Logger:warning("Could not fetch from PolicyService due to error: {}", p4)
				end)

				return connection
			end
		}
	end
end
