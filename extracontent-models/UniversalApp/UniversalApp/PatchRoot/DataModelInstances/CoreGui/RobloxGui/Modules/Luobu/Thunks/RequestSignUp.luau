local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local t = require(CorePackages.Packages.t)
local Promise = require(Modules.LuaApp.Promise)
local SignUpRequest = require(Modules.Luobu.Http.Requests.SignUpRequest)
local LaunchLuobuApp = require(Modules.Luobu.Thunks.LaunchLuobuApp)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local AppSignupCounterNames = require(Modules.Luobu.Analytics.Events.AppSignupCounterNames)
local v9 = t.interface({
	birthday = t.string,
	displayName = t.string,
	gender = t.number,
	voucher = t.string,
	channelId = t.number,
	agreementIds = t.table
})

return function(p1, p2, p3, p4, p5) -- line: 19
	-- upvalues: v9 (copy), SignUpRequest (copy), AppSignupCounterNames (copy), LaunchLuobuApp (copy), Promise (copy), SetNetworkingErrorToast (copy)
	return function(p6) -- line: 20
		-- upvalues: v9 (copy), p5 (copy), SignUpRequest (copy), p1 (copy), p4 (copy), p2 (copy), AppSignupCounterNames (copy), LaunchLuobuApp (copy), p3 (copy), Promise (copy), SetNetworkingErrorToast (copy)
		assert(v9(p5))

		return SignUpRequest(p1, p4, p5):andThen(function(_) -- line: 22
			-- upvalues: p2 (copy), AppSignupCounterNames (copy), p6 (copy), LaunchLuobuApp (copy), p1 (copy), p3 (copy), Promise (copy)
			p2.Diag:reportCounter(AppSignupCounterNames.Success, 1)
			p6:dispatch(LaunchLuobuApp(p1, p2, p3))

			return Promise.resolve()
		end, function(_) -- line: 26
			-- upvalues: p2 (copy), AppSignupCounterNames (copy), p6 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p2.Diag:reportCounter(AppSignupCounterNames.Failure, 1)
			p6:dispatch(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))

			return Promise.reject()
		end)
	end
end
