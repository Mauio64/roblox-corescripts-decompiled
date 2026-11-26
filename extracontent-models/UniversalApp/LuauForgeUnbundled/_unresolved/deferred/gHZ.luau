local Players = game:GetService("Players")

local module = require("@luauforge/bundled/egs")

local module2 = require("@luauforge/bundled/dFu")
local module3 = require("@luauforge/bundled/gsv")

local setAuthenticationStatus = require("@luauforge/bundled/ggh").Actions.SetAuthenticationStatus
local module4 = require("@luauforge/bundled/ggj")
local module5 = require("@luauforge/bundled/dKv")
local module6 = require("@luauforge/bundled/gfd")

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

return function(p2, p3, p4)
	return function(object)
		return module3(p2):andThen(function(p5)
			local username = p5.responseBody.Username
			local displayName = p5.responseBody.DisplayName
			Players:SetLocalPlayerInfo(
				p5.responseBody.UserId,
				username,
				displayName,
				tonumber(p5.responseBody.MembershipType),
				p5.responseBody.AgeBracket == 1
			)

			if fFlagUseSignalsForAuthenticationStatus then
				getAuthenticationStatusStore(false).setAuthenticationStatus(module4.LOGGED_IN)
			else
				object:dispatch(setAuthenticationStatus(module4.LOGGED_IN))
			end

			object:dispatch(module5({
				{ name = module2.Home }
			}))
			object:dispatch(module6(p2, p3, p4))
			return module.resolve()
		end, function(p5)
			if fFlagUseSignalsForAuthenticationStatus then
				getAuthenticationStatusStore(false).setAuthenticationStatus(module4.LOGGED_OUT)
			else
				object:dispatch(setAuthenticationStatus(module4.LOGGED_OUT))
			end

			object:dispatch(module5({
				{ name = module2.WeChatLoginWrapper }
			}))
			return module.reject(p5)
		end)
	end
end
