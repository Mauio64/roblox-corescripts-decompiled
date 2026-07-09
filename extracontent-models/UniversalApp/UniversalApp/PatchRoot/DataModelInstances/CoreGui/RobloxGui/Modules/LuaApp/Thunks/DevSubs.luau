local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetDevSubs = require(Modules.LuaApp.Actions.SetDevSubs)
local GetDevSubs = require(Modules.LuaApp.Http.Requests.GetDevSubs)
local ApiFetchGameIcons = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.ApiFetchGameIcons
local DevSubStatus = require(Modules.LuaApp.Enum.DevSubStatus)
local DevSubTypes = require(Modules.LuaApp.Types.DevSubTypes)
local DevSub = require(Modules.LuaApp.Models.DevSub)
local t1 = {}

local function getSubscriptionData(p1, p2, p3, p4, p5) -- line: 20
	-- upvalues: GetDevSubs (copy), DevSubTypes (copy), getSubscriptionData (copy)
	local u19 = p4 or {
		subscriptions = {},
		games = {},
		plans = {}
	}

	return GetDevSubs(p1, p2, p3, p5):andThen(function(p6) -- line: 27
		-- upvalues: DevSubTypes (copy), u19 (ref), getSubscriptionData (copy), p1 (copy), p2 (copy), p3 (copy)
		if not DevSubTypes.SubscriptionsResponseCheck(p6.responseBody) then
			return nil, false
		end

		for _, v in pairs(p6.responseBody.data) do
			u19.subscriptions[v.id] = v
		end

		for _, v in pairs(p6.responseBody.auxiliaryData.plans) do
			u19.plans[v.id] = v
		end

		for _, v in pairs(p6.responseBody.auxiliaryData.universes) do
			u19.games[v.id] = v
		end

		local nextPageCursor = p6.responseBody.nextPageCursor

		if nextPageCursor then
			return getSubscriptionData(p1, p2, p3, u19, nextPageCursor)
		end

		return u19, true
	end)
end
local function getAllSubscriptionData(p7, p8) -- line: 53
	-- upvalues: getSubscriptionData (copy), DevSubStatus (copy)
	return getSubscriptionData(p7, p8, DevSubStatus.Active):andThen(function(p9) -- line: 54
		-- upvalues: getSubscriptionData (copy), p7 (copy), p8 (copy), DevSubStatus (copy)
		return getSubscriptionData(p7, p8, DevSubStatus.Inactive, p9)
	end)
end

function t1.Fetch(p10) -- line: 59
	-- upvalues: PerformFetch (copy), getSubscriptionData (copy), DevSubStatus (copy), Promise (copy), ApiFetchGameIcons (copy), DevSub (copy), SetDevSubs (copy)
	local LocalPlayer = game:GetService("Players").LocalPlayer

	assert(LocalPlayer)

	local UserId = LocalPlayer.UserId

	return PerformFetch.Single("DevSubs", function(p11) -- line: 64
		-- upvalues: p10 (copy), UserId (copy), getSubscriptionData (copy), DevSubStatus (copy), Promise (copy), ApiFetchGameIcons (copy), DevSub (copy), SetDevSubs (copy)
		local v36 = p10
		local v37 = UserId

		return getSubscriptionData(v36, v37, DevSubStatus.Active):andThen(function(p12) -- line: 54
			-- upvalues: getSubscriptionData (copy), v36 (copy), v37 (copy), DevSubStatus (copy)
			return getSubscriptionData(v36, v37, DevSubStatus.Inactive, p12)
		end):andThen(function(p13, p14) -- line: 66
			-- upvalues: Promise (copy), p11 (copy), ApiFetchGameIcons (copy), p10 (copy), DevSub (copy), SetDevSubs (copy)
			if not p14 then
				return Promise.resolve()
			end

			local t2 = {}

			for k, _ in pairs(p13.games) do
				table.insert(t2, k)
			end

			p11:dispatch(ApiFetchGameIcons(p10, t2))

			local t3 = {}

			for _, v in pairs(p13.subscriptions) do
				v.planData = p13.plans[v.planId]

				if v.planData then
					v.gameData = p13.games[v.planData.universeId]

					if v.gameData then
						table.insert(t3, DevSub.fromJsonData(v))
					end
				end
			end

			p11:dispatch(SetDevSubs(t3))

			return Promise.resolve()
		end, function(p15) -- line: 102
			-- upvalues: Promise (copy)
			return Promise.reject(p15)
		end)
	end)
end
function t1.GetFetchingStatus(p16) -- line: 108
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p16, "DevSubs")
end

return t1
