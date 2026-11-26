local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module3 = require("@luauforge/bundled/dPu")

if require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport then
	return function(p2, p3, p4, p5)
		module.isType(p2, "function", "SetLookFavorite thunk expects networkImpl to be a function")
		module.isType(p3, "string", "SetLookFavorite thunk expects lookId to be a string")
		module.isType(p4, "boolean", "SetLookFavorite thunk expects isFavorited to be a boolean")
		return performFetch.Single("look.setlookfavorite", function(object)
			if p4 then
				return GetExperienceSourceLanguage.FavoriteLookV2(p2, p3, p5):andThen(function(p6)
					if p6.responseBody then
						object:dispatch(module3(p3, true))
					end

					return Promise.resolve()
				end, function(p6)
					logging.warn("WebApi failure in SetLookFavorite")
					return Promise.reject(p6)
				end)
			end

			return GetExperienceSourceLanguage.UnfavoriteLookV2(p2, p3, p5):andThen(function(p6)
				if p6.responseBody then
					object:dispatch(module3(p3, false))
				end

				return Promise.resolve()
			end, function(p6)
				logging.warn("WebApi failure in SetLookFavorite")
				object:dispatch(module3({}))
				return Promise.reject(p6)
			end)
		end)
	end
end

return function(p2, p3, p4)
	module.isType(p2, "function", "SetLookFavorite thunk expects networkImpl to be a function")
	module.isType(p3, "string", "SetLookFavorite thunk expects lookId to be a string")
	module.isType(p4, "boolean", "SetLookFavorite thunk expects isFavorited to be a boolean")
	return performFetch.Single("look.setlookfavorite", function(object)
		if p4 then
			return GetExperienceSourceLanguage.FavoriteLook(p2, p3):andThen(function(p5)
				if p5.responseBody then
					object:dispatch(module3(p3, true))
				end

				return Promise.resolve()
			end, function(p5)
				logging.warn("WebApi failure in SetLookFavorite")
				return Promise.reject(p5)
			end)
		end

		return GetExperienceSourceLanguage.UnfavoriteLook(p2, p3):andThen(function(p5)
			if p5.responseBody then
				object:dispatch(module3(p3, false))
			end

			return Promise.resolve()
		end, function(p5)
			logging.warn("WebApi failure in SetLookFavorite")
			object:dispatch(module3({}))
			return Promise.reject(p5)
		end)
	end)
end
