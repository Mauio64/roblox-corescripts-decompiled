local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)

local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)
local SetRangesAndSliderValuesFromBodyColor3s = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetRangesAndSliderValuesFromBodyColor3s)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)

return function(p1, b1: boolean?) -- line: 27
	-- upvalues: ArgCheck (copy), WebApi (copy), Utils (copy), Cryo (copy), ReceivedAvatarData (copy), SetRangesAndSliderValuesFromBodyColor3s (copy), Logging (copy), Promise (copy)
	ArgCheck.isType(p1, "function", "RefetchAvatarData thunk expects networkImpl to be a function")

	return function(p2, _) -- line: 29
		-- upvalues: WebApi (copy), p1 (copy), b1 (copy), Utils (copy), Cryo (copy), ReceivedAvatarData (copy), SetRangesAndSliderValuesFromBodyColor3s (copy), Logging (copy), Promise (copy)
		return WebApi.GetAvatarData(p1, {
			checkAssetAvailability = b1
		}):andThen(function(p4) -- line: 31
			-- upvalues: Utils (copy), Cryo (copy), p2 (copy), ReceivedAvatarData (copy), SetRangesAndSliderValuesFromBodyColor3s (copy)
			local v17 = Utils.tableToCamelCaseKeys(p4.responseBody)

			if not v17 then
				return
			end

			local v18 = v17.bodyColor3s or {}
			local v19 = Utils.convertBodyColor3HexesToColor3s(v18)
			local v20 = Cryo.Dictionary.join(v17, {
				bodyColor3s = v19
			})

			p2:dispatch(ReceivedAvatarData(v20))

			local DefaultBodyColorRanges = p2:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges

			if DefaultBodyColorRanges and #DefaultBodyColorRanges > 0 then
				p2:dispatch(SetRangesAndSliderValuesFromBodyColor3s(v19))
			end
		end):catch(function(p5) -- line: 49
			-- upvalues: Logging (copy), Promise (copy)
			Logging.warn("WebApi failure in RefetchAvatarData: " .. tostring(p5))

			return Promise.reject(p5)
		end)
	end
end
