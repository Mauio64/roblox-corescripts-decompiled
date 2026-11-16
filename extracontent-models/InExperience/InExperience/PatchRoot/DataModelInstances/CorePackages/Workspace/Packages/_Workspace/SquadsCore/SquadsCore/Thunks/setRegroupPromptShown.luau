local SquadsCore = script:FindFirstAncestor("SquadsCore")
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local RoduxSquads = require(SquadsCore.RoduxSquads)
local Logger = require(SquadsCore.Logger)

local parent = SquadsCore.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

return function(groupUpId: string)
	return function(object)
		if not FFlagEnableSquadRegroupExperimentation then
			return
		end

		object:dispatch(NetworkingSquads.SetRegroupPromptShown.API({ groupUpId = groupUpId })):andThen(function(p)
			if p.success then
				object:dispatch(RoduxSquads.Actions.SelfPermissionUpdated({
					canSeeRegroupPromptToast = false
				}))
			end
		end):catch(function(p)
			Logger:error("Error occured with NetworkingSquads.SetRegroupPromptShown: {}", (tostring(p)))
		end)
	end
end
