local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")

local fFlagEnableSquadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagEnableSquadRegroupExperimentation

return function(p2)
	return function(object)
		if not fFlagEnableSquadRegroupExperimentation then
			return
		end

		object:dispatch(NetworkingSquads.SetRegroupPromptShown.API({ groupUpId = p2 })):andThen(function(p3)
			if p3.success then
				object:dispatch(RoduxSquads.Actions.SelfPermissionUpdated({
					canSeeRegroupPromptToast = false
				}))
			end
		end):catch(function(p3)
			Logger:error("Error occured with NetworkingSquads.SetRegroupPromptShown: {}", (tostring(p3)))
		end)
	end
end
