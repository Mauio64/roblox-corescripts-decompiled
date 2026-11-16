local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/ecV")

local module2 = require("@luauforge/bundled/dCh")
local module3 = require("@luauforge/bundled/dwB")
local module4 = require("@luauforge/bundled/dME")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local removeLook = require("@luauforge/bundled/dHL").Actions.RemoveLook

local v5 = {
	toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
	isLocalized = false,
	toastType = module3.NetworkingError
}

local function keyMapper(p2)
	return module4.FetchLookDetailInfoKey .. p2
end

return function(p2, p3)
	return function(p4)
		return performFetch.Single(module4.FetchLookDetailInfoKey .. p3, function(object)
			return GetExperienceSourceLanguage.DeleteLook(p2, p3):andThen(function(p5)
				object:dispatch(removeLook(p3))
				return module.resolve()
			end):catch(function(p5)
				local statusCode = p5 and p5.StatusCode

				if statusCode and statusCode == 404 then
					object:dispatch(removeLook(p3))
					return module.resolve()
				end

				object:dispatch(module2(v5))
				return module.reject(p5)
			end)
		end)(p4)
	end
end
