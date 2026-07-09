local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Promise = require(CorePackages.Packages.Promise)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local v11 = game:DefineFastInt("DebugAvatarDataDelay", 0)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow

return function(p1, b1: boolean?) -- line: 19
	-- upvalues: ArgCheck (copy), PerformFetch (copy), Constants (copy), FFlagAXModeratedItemsFlow (copy), WebApi (copy), v11 (copy), Utils (copy), Logging (copy), Promise (copy)
	ArgCheck.isType(p1, "function", "GetAvatarData thunk expects networkImpl to be a function")

	return PerformFetch.Single(Constants.GetAvatarDataKey, function(_) -- line: 21
		-- upvalues: FFlagAXModeratedItemsFlow (copy), b1 (copy), WebApi (copy), p1 (copy), v11 (copy), Utils (copy), Logging (copy), Promise (copy)
		local v16 = if not FFlagAXModeratedItemsFlow then nil else {
			checkAssetAvailability = b1
		}

		return WebApi.GetAvatarData(p1, v16):andThen(function(p3) -- line: 25
			-- upvalues: v11 (copy), Utils (copy)
			if v11 > 0 then
				task.wait(v11)
			end

			return Utils.tableToCamelCaseKeys(p3.responseBody)
		end, function(p4) -- line: 33
			-- upvalues: Logging (copy), Promise (copy)
			Logging.warn("WebApi failure in GetAvatarData: " .. tostring(p4))

			return Promise.reject(p4)
		end)
	end)
end
