local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetLookFavorite = require(Modules.AvatarExperience.Catalog.Actions.SetLookFavorite)

if require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport then
	return function(p1, p2, p3, s1: string?) -- line: 17
		-- upvalues: ArgCheck (copy), PerformFetch (copy), WebApi (copy), SetLookFavorite (copy), Promise (copy), Logging (copy)
		ArgCheck.isType(p1, "function", "SetLookFavorite thunk expects networkImpl to be a function")
		ArgCheck.isType(p2, "string", "SetLookFavorite thunk expects lookId to be a string")
		ArgCheck.isType(p3, "boolean", "SetLookFavorite thunk expects isFavorited to be a boolean")

		return PerformFetch.Single("look.setlookfavorite", function(p4) -- line: 21
			-- upvalues: p3 (copy), WebApi (copy), p1 (copy), p2 (copy), s1 (copy), SetLookFavorite (copy), Promise (copy), Logging (copy)
			if p3 then
				return WebApi.FavoriteLookV2(p1, p2, s1):andThen(function(p5) -- line: 23
					-- upvalues: p4 (copy), SetLookFavorite (copy), p2 (copy), Promise (copy)
					if p5.responseBody then
						p4:dispatch(SetLookFavorite(p2, true))
					end

					return Promise.resolve()
				end, function(p6) -- line: 29
					-- upvalues: Logging (copy), Promise (copy)
					Logging.warn("WebApi failure in SetLookFavorite")

					return Promise.reject(p6)
				end)
			end

			return WebApi.UnfavoriteLookV2(p1, p2, s1):andThen(function(p7) -- line: 34
				-- upvalues: p4 (copy), SetLookFavorite (copy), p2 (copy), Promise (copy)
				if p7.responseBody then
					p4:dispatch(SetLookFavorite(p2, false))
				end

				return Promise.resolve()
			end, function(p8) -- line: 41
				-- upvalues: Logging (copy), p4 (copy), SetLookFavorite (copy), Promise (copy)
				Logging.warn("WebApi failure in SetLookFavorite")
				p4:dispatch(SetLookFavorite({}))

				return Promise.reject(p8)
			end)
		end)
	end
end

return function(p9, p10, p11) -- line: 50
	-- upvalues: ArgCheck (copy), PerformFetch (copy), WebApi (copy), SetLookFavorite (copy), Promise (copy), Logging (copy)
	ArgCheck.isType(p9, "function", "SetLookFavorite thunk expects networkImpl to be a function")
	ArgCheck.isType(p10, "string", "SetLookFavorite thunk expects lookId to be a string")
	ArgCheck.isType(p11, "boolean", "SetLookFavorite thunk expects isFavorited to be a boolean")

	return PerformFetch.Single("look.setlookfavorite", function(p12) -- line: 54
		-- upvalues: p11 (copy), WebApi (copy), p9 (copy), p10 (copy), SetLookFavorite (copy), Promise (copy), Logging (copy)
		if p11 then
			return WebApi.FavoriteLook(p9, p10):andThen(function(p13) -- line: 56
				-- upvalues: p12 (copy), SetLookFavorite (copy), p10 (copy), Promise (copy)
				if p13.responseBody then
					p12:dispatch(SetLookFavorite(p10, true))
				end

				return Promise.resolve()
			end, function(p14) -- line: 62
				-- upvalues: Logging (copy), Promise (copy)
				Logging.warn("WebApi failure in SetLookFavorite")

				return Promise.reject(p14)
			end)
		end

		return WebApi.UnfavoriteLook(p9, p10):andThen(function(p15) -- line: 67
			-- upvalues: p12 (copy), SetLookFavorite (copy), p10 (copy), Promise (copy)
			if p15.responseBody then
				p12:dispatch(SetLookFavorite(p10, false))
			end

			return Promise.resolve()
		end, function(p16) -- line: 74
			-- upvalues: Logging (copy), p12 (copy), SetLookFavorite (copy), Promise (copy)
			Logging.warn("WebApi failure in SetLookFavorite")
			p12:dispatch(SetLookFavorite({}))

			return Promise.reject(p16)
		end)
	end)
end
