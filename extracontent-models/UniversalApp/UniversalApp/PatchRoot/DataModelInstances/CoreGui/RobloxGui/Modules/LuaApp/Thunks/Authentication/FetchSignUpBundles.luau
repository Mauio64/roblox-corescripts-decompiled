local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local t = require(CorePackages.Packages.t)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Promise = require(CorePackages.Packages.Promise)
local Retry = require(Modules.LuaApp.Thunks.Networking.Util.Retry)
local SignUpBundle = require(Modules.LuaApp.Models.Authentication.SignUpBundle)
local SetSignUpBundles = require(Modules.LuaApp.Actions.Authentication.SetSignUpBundles)
local GetSignUpBundles = require(Modules.LuaApp.Http.Requests.GetSignUpBundles)
local FetchHumanoidDescriptionProperties = require(Modules.LuaApp.Thunks.Authentication.FetchHumanoidDescriptionProperties)
local GetFIntLuaSignUpMaxRetries = require(Modules.LuaApp.Flags.GetFIntLuaSignUpMaxRetries)
local GetFIntLuaSignUpRetryTimeMultiplier = require(Modules.LuaApp.Flags.GetFIntLuaSignUpRetryTimeMultiplier)
local v13 = math.max(0, GetFIntLuaSignUpMaxRetries())
local v14 = math.max(0, GetFIntLuaSignUpRetryTimeMultiplier())
local t1 = {}
local v16 = t.array(t.optional(t.interface({
	bundleId = t.number,
	userOutfitId = t.number
})))

function t1._fetchSignUpBundles(p1) -- line: 44
	-- upvalues: GetSignUpBundles (copy), v16 (copy), Promise (copy)
	return GetSignUpBundles(p1):andThen(function(p2) -- line: 45
		-- upvalues: v16 (copy), Promise (copy)
		local v23 = p2 and (p2.responseBody and p2.responseBody.bundles)

		if v16(v23) then
			return Promise.resolve(v23)
		end

		return Promise.resolve()
	end)
end
function t1._fetchSignUpBundlesWithRetry(p3) -- line: 57
	-- upvalues: t1 (copy), Retry (copy), v13 (copy), v14 (copy)
	local function fetchSignUpBundles() -- line: 58
		-- upvalues: t1 (copy), p3 (copy)
		return t1._fetchSignUpBundles(p3)
	end

	return t1._fetchSignUpBundles(p3):andThen(function(p4) -- line: 62
		-- upvalues: Retry (copy), v13 (copy), v14 (copy), fetchSignUpBundles (copy)
		return Retry({
			retryCount = v13,
			retryTimeMultiplier = v14,
			retryCallback = fetchSignUpBundles,
			previousResult = p4,
			isResolveConditionMet = function(p5) -- line: 71
				return p5 ~= nil
			end
		})
	end)
end
function t1.Fetch(p6) -- line: 78
	-- upvalues: PerformFetch (copy), t1 (copy), v16 (copy), SignUpBundle (copy), SetSignUpBundles (copy), Promise (copy), FetchHumanoidDescriptionProperties (copy)
	return PerformFetch.Single("signUpBundles", function(p7) -- line: 79
		-- upvalues: t1 (copy), p6 (copy), v16 (copy), SignUpBundle (copy), SetSignUpBundles (copy), Promise (copy), FetchHumanoidDescriptionProperties (copy)
		return t1._fetchSignUpBundlesWithRetry(p6):andThen(function(p8) -- line: 86
			-- upvalues: v16 (copy), SignUpBundle (copy), p7 (copy), SetSignUpBundles (copy), Promise (copy)
			local t2 = {}

			if v16(p8) then
				for _, v in ipairs(p8) do
					table.insert(t2, SignUpBundle.fromData(v))
				end

				p7:dispatch(SetSignUpBundles(t2))

				return Promise.resolve(t2)
			end

			return Promise.reject()
		end):andThen(function(p9) -- line: 106
			-- upvalues: p7 (copy), FetchHumanoidDescriptionProperties (copy), p6 (copy)
			local t3 = {}

			for _, v in pairs(p9) do
				table.insert(t3, v.userOutfitId)
			end

			return p7:dispatch(FetchHumanoidDescriptionProperties.Fetch(p6, t3))
		end)
	end)
end
function t1.GetFetchingStatus(p10) -- line: 118
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p10, "signUpBundles")
end

return t1
