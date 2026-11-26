local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dzP")
local Promise = require(CorePackages.Packages.Promise)

local module2 = require("@luauforge/bundled/dRg")
local module3 = require("@luauforge/bundled/fDG")

local module4 = require("@luauforge/bundled/fCe")

local defineFastInt = game:DefineFastInt("DebugAvatarDataDelay", 0)

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow

return function(p2, p3)
	module.isType(p2, "function", "GetAvatarData thunk expects networkImpl to be a function")
	return performFetch.Single(module2.GetAvatarDataKey, function(p4)
		return module3.GetAvatarData(
			p2,
			fFlagAXModeratedItemsFlow and { checkAssetAvailability = p3 } or nil
		):andThen(
			function(p5)
				if defineFastInt > 0 then
					task.wait(defineFastInt)
				end

				return module4.tableToCamelCaseKeys(p5.responseBody)
			end,
			function(p5)
				logging.warn("WebApi failure in GetAvatarData: " .. tostring(p5))
				return Promise.reject(p5)
			end
		)
	end)
end
