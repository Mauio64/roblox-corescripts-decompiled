local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local GameGetPrivateServersEnabled = require(Modules.LuaApp.Http.Requests.GamesApi.GameGetPrivateServersEnabled)
local SetGamePrivateServersEnabled = require(Modules.LuaApp.Actions.Games.SetGamePrivateServersEnabled)

return function(p1, p2) -- line: 8
	-- upvalues: GameGetPrivateServersEnabled (copy), SetGamePrivateServersEnabled (copy), Promise (copy), Logging (copy)
	if type(p2) ~= "string" then
		error("ApiFetchPrivateServersEnabled thunk expects universeId to be a string")
	end

	return function(p3) -- line: 13
		-- upvalues: GameGetPrivateServersEnabled (copy), p1 (copy), p2 (copy), SetGamePrivateServersEnabled (copy), Promise (copy), Logging (copy)
		return GameGetPrivateServersEnabled(p1, p2):andThen(function(p4) -- line: 14
			-- upvalues: p3 (copy), SetGamePrivateServersEnabled (copy), p2 (copy), Promise (copy), Logging (copy)
			local responseBody = p4.responseBody

			if responseBody ~= nil and responseBody.privateServersEnabled ~= nil then
				p3:dispatch(SetGamePrivateServersEnabled(p2, responseBody.privateServersEnabled))

				return Promise.resolve(p4)
			end

			Logging.warn("Response from GameGetPrivateServersEnabled is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end
end
