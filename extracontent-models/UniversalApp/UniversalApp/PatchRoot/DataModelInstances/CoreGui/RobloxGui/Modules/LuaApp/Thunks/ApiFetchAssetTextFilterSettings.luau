local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetAssetTextFilterSettings = require(Modules.LuaApp.Actions.SetAssetTextFilterSettings)
local GetAssetTextFilterSettings = require(Modules.LuaApp.Http.Requests.GetAssetTextFilterSettings)
local t1 = {}

local function fetchKeymapper(p1) -- line: 14
	return "luaapp.asset-text-filter-settings.get-settings" .. p1
end

function t1.Fetch(p2, s1: string) -- line: 18
	-- upvalues: PerformFetch (copy), GetAssetTextFilterSettings (copy), Logging (copy), Promise (copy), SetAssetTextFilterSettings (copy), SetNetworkingErrorToast (copy)
	return PerformFetch.Single("luaapp.asset-text-filter-settings.get-settings" .. s1, function(p3) -- line: 19
		-- upvalues: GetAssetTextFilterSettings (copy), p2 (copy), s1 (copy), Logging (copy), Promise (copy), SetAssetTextFilterSettings (copy), SetNetworkingErrorToast (copy)
		return GetAssetTextFilterSettings(p2, s1):andThen(function(p4) -- line: 20
			-- upvalues: Logging (copy), s1 (copy), Promise (copy), p3 (copy), SetAssetTextFilterSettings (copy)
			local responseBody = p4.responseBody

			if responseBody ~= nil then
				if responseBody.Profanity ~= nil then
					local Profanity = responseBody.Profanity

					p3:dispatch(SetAssetTextFilterSettings(s1, Profanity))

					return Promise.resolve(Profanity)
				end

				Logging.warn("Failed to parse GetAssetTextFilterSettings for `" .. s1 .. "`")

				return Promise.reject(false)
			end

			p3:dispatch(SetAssetTextFilterSettings(s1, false))

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end, function(p5) -- line: 38
			-- upvalues: p3 (copy), SetAssetTextFilterSettings (copy), s1 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p3:dispatch(SetAssetTextFilterSettings(s1, false))
			p3:dispatch(SetNetworkingErrorToast(p5))

			return Promise.reject(p5)
		end)
	end)
end
function t1.GetFetchingStatus(p6, p7) -- line: 46
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p6, "luaapp.asset-text-filter-settings.get-settings" .. p7)
end

return t1
