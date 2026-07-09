local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local LoginRequests = require(Modules.LuaApp.Http.Requests.LoginRequests)
local LoginResult = require(Modules.LuaApp.Models.Authentication.LoginResult)
local LoginErrorCodeSSO = require(Modules.LuaApp.Enum.LoginErrorCodeSSO)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Logger = require(Modules.LuaApp.Components.Authentication.Logger)

local function LoginSingleSignOn(p1) -- line: 16
	-- upvalues: PerformFetch (copy), LoginRequests (copy), LoginResult (copy), Promise (copy), Logger (copy), LoginErrorCodeSSO (copy), HttpService (copy)
	return PerformFetch.Single(script.Name, function(_) -- line: 17
		-- upvalues: LoginRequests (copy), p1 (copy), LoginResult (copy), Promise (copy), Logger (copy), LoginErrorCodeSSO (copy), HttpService (copy)
		return LoginRequests.singleSignOnLogin(p1):andThen(function(p3) -- line: 18
			-- upvalues: LoginResult (copy), Promise (copy), Logger (copy), LoginErrorCodeSSO (copy)
			if p3 and p3[1] then
				local ok, result = pcall(function() -- line: 20
					-- upvalues: LoginResult (copy), p3 (copy)
					return LoginResult.fromJsonData(p3[1])
				end)

				if ok then
					return Promise.resolve(result)
				end

				Logger:warning(string.format("Single sign on loginResult error: %s", (tostring(result))))

				return Promise.reject({
					errorCode = LoginErrorCodeSSO.AuthError
				})
			end

			Logger:warning(string.format("Single sign on result error: %s", (tostring(p3))))

			return Promise.reject({
				errorCode = LoginErrorCodeSSO.AuthError
			})
		end, function(p4) -- line: 37
			-- upvalues: Logger (copy), HttpService (copy), LoginErrorCodeSSO (copy), Promise (copy)
			Logger:warning(string.format("Single sign on login error: %s", (tostring(p4))))

			if p4 and p4.Body then
				local data = HttpService:JSONDecode(p4.Body)
				local v18 = if not data.errors[1] then LoginErrorCodeSSO.AuthError else data.errors[1].code
				local v19 = if not data.errors[1] then nil else data.errors[1].userFacingMessage

				return Promise.reject({
					errorCode = v18,
					userFacingMessage = v19
				})
			end

			return Promise.reject(p4)
		end)
	end)
end

return LoginSingleSignOn
