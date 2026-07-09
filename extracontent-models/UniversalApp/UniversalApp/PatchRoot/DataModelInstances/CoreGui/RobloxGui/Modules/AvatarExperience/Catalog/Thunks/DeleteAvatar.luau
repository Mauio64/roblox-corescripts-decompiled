local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Promise = require(Modules.LuaApp.Promise)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local RemoveLook = require(Modules.AvatarExperience.Common.Actions.RemoveLook)
local t1 = {
	toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
	isLocalized = false,
	toastType = ToastType.NetworkingError
}

local function keyMapper(s1: string) -- line: 20
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchLookDetailInfoKey .. s1
end

return function(p1, s2: string) -- line: 26
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), WebApi (copy), RemoveLook (copy), Promise (copy), SetCurrentToastMessage (copy), t1 (copy)
	return function(p2) -- line: 27
		-- upvalues: PerformFetch (copy), s2 (copy), CatalogConstants (copy), WebApi (copy), p1 (copy), RemoveLook (copy), Promise (copy), SetCurrentToastMessage (copy), t1 (copy)
		local Single = PerformFetch.Single
		local v17 = s2

		return Single(CatalogConstants.FetchLookDetailInfoKey .. v17, function(p3) -- line: 28
			-- upvalues: WebApi (copy), p1 (copy), s2 (copy), RemoveLook (copy), Promise (copy), SetCurrentToastMessage (copy), t1 (copy)
			return WebApi.DeleteLook(p1, s2):andThen(function(_) -- line: 30
				-- upvalues: p3 (copy), RemoveLook (copy), s2 (copy), Promise (copy)
				p3:dispatch(RemoveLook(s2))

				return Promise.resolve()
			end):catch(function(p5) -- line: 34
				-- upvalues: p3 (copy), RemoveLook (copy), s2 (copy), Promise (copy), SetCurrentToastMessage (copy), t1 (copy)
				local v21 = p5 and p5.StatusCode

				if v21 and v21 == 404 then
					p3:dispatch(RemoveLook(s2))

					return Promise.resolve()
				end

				p3:dispatch(SetCurrentToastMessage(t1))

				return Promise.reject(p5)
			end)
		end)(p2)
	end
end
