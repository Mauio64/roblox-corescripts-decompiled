local SquadsCore = script:FindFirstAncestor("SquadsCore")
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local RoduxSquads = require(SquadsCore.RoduxSquads)
local Logger = require(SquadsCore.Logger)
local SquadsCoreParent = SquadsCore.Parent
local FFlagEnableSquadRegroupExperimentation = require(SquadsCoreParent.SharedFlags).FFlagEnableSquadRegroupExperimentation

return function(s1: string) -- line: 10
	-- upvalues: FFlagEnableSquadRegroupExperimentation (copy), NetworkingSquads (copy), RoduxSquads (copy), Logger (copy)
	return function(p1) -- line: 11
		-- upvalues: FFlagEnableSquadRegroupExperimentation (copy), NetworkingSquads (copy), s1 (copy), RoduxSquads (copy), Logger (copy)
		if not FFlagEnableSquadRegroupExperimentation then
			return
		end

		p1:dispatch(NetworkingSquads.SetRegroupPromptShown.API({
			groupUpId = s1
		})):andThen(function(p2) -- line: 18
			-- upvalues: p1 (copy), RoduxSquads (copy)
			if p2.success then
				p1:dispatch(RoduxSquads.Actions.SelfPermissionUpdated({
					canSeeRegroupPromptToast = false
				}))
			end
		end):catch(function(p3) -- line: 25
			-- upvalues: Logger (copy)
			Logger:error("Error occured with NetworkingSquads.SetRegroupPromptShown: {}", (tostring(p3)))
		end)
	end
end
