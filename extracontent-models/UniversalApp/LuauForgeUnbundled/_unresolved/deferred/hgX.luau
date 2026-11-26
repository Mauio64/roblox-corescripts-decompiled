local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local Cryo = require(CorePackages.Packages.Cryo)
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")
require("@luauforge/bundled/dPs")

local module2 = require("@luauforge/bundled/dQs")

local module3 = require("@luauforge/bundled/hgY")
local module4 = require("@luauforge/bundled/fCe")
local module5 = require("@luauforge/bundled/fDG")

return function(p2, p3)
	module.isType(p2, "function", "RefetchAvatarData thunk expects networkImpl to be a function")
	return function(object, p4)
		return module5.GetAvatarData(p2, { checkAssetAvailability = p3 }):andThen(function(p5)
			local tableToCamelCaseKeys = module4.tableToCamelCaseKeys(p5.responseBody)

			if not tableToCamelCaseKeys then
				return
			end

			local bodyColor3s = tableToCamelCaseKeys.bodyColor3s or {}
			local convertBodyColor3HexesToColor3s = module4.convertBodyColor3HexesToColor3s(bodyColor3s)
			object:dispatch(module2((Cryo.Dictionary.join(tableToCamelCaseKeys, {
				bodyColor3s = convertBodyColor3HexesToColor3s
			}))))

			local defaultBodyColorRanges = object:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges

			if defaultBodyColorRanges and #defaultBodyColorRanges > 0 then
				object:dispatch(module3(convertBodyColor3HexesToColor3s))
			end
		end):catch(function(p5)
			logging.warn("WebApi failure in RefetchAvatarData: " .. tostring(p5))
			return Promise.reject(p5)
		end)
	end
end
