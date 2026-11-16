local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/bundled/hCZ")
local module3 = require("@luauforge/bundled/fDB")

local module4 = require("@luauforge/bundled/hDa")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/TextChannelWindow/TextChannelWindow/Logger")

local function LoginSingleSignOn(p2)
	return performFetch.Single("LoginSingleSignOn", function(p3)
		return module2.singleSignOnLogin(p2):andThen(function(list)
			if not (list and list[1]) then
				Logger:warning(string.format("Single sign on result error: %s", (tostring(list))))
				return module.reject({ errorCode = module4.AuthError })
			end

			local success, result = pcall(function()
				return module3.fromJsonData(list[1])
			end)

			if success then
				return module.resolve(result)
			end

			Logger:warning(string.format("Single sign on loginResult error: %s", (tostring(result))))
			return module.reject({ errorCode = module4.AuthError })
		end, function(p4)
			Logger:warning(string.format("Single sign on login error: %s", (tostring(p4))))

			if not (p4 and p4.Body) then
				return module.reject(p4)
			end

			local jsonDecode = HttpService:JSONDecode(p4.Body)
			local v5 = if jsonDecode.errors[1] then jsonDecode.errors[1].code else module4.AuthError
			local v6 = if jsonDecode.errors[1] then jsonDecode.errors[1].userFacingMessage else nil

			return module.reject({ errorCode = v5, userFacingMessage = v6 })
		end)
	end)
end

return LoginSingleSignOn
