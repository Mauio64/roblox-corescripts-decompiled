local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Navigation)

local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FFlagProfilePlatformEnableCurrencyTransfer = require(CorePackages.Workspace.Packages.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagLuaAppEnableFeatureTileAdPlayer = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableFeatureTileAdPlayer
local getSocialRoutes = require(Modules.LuaApp.Components.Social.getSocialRoutes)
local getCurrencyTransferRoutes = require(Modules.LuaApp.Components.CurrencyTransfer.getCurrencyTransferRoutes)
local getAdsRoutes = require(Modules.LuaApp.Components.Ads.getAdsRoutes)
local getProfilePlatformRoutes = require(Modules.LuaApp.Components.ProfilePlatform.getProfilePlatformRoutes)
local getGroupRoutes = require(Modules.LuaApp.Components.Groups.getGroupRoutes)

local function validateNoDuplicateRoutes(p1) -- line: 16
	local t1 = {}

	for _, v17 in p1 do
		local v18 = next(v17)

		if t1[v18] then
			error(`Duplicate route name found: { v18 }`)
		end

		t1[v18] = true
	end
end
local function sanitizeRoutes(p2) -- line: 27
	local t2 = {}

	for _, v22 in p2 do
		if v22 ~= nil and next(v22) ~= nil then
			table.insert(t2, v22)
		end
	end

	return t2
end
local function joinHoleyArrays(...) -- line: 39
	local t3 = {}

	for i = 1, select("#", ...) do
		local v25 = select(i, ...)

		if v25 ~= nil then
			for _, v27 in v25 do
				if v27 ~= nil then
					table.insert(t3, v27)
				end
			end
		end
	end

	return t3
end

return function() -- line: 58
	-- upvalues: joinHoleyArrays (copy), Modules (copy), getAppFeaturePolicies (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), getCurrencyTransferRoutes (copy), FFlagLuaAppEnableFeatureTileAdPlayer (copy), getAdsRoutes (copy), getProfilePlatformRoutes (copy), getSocialRoutes (copy), getGroupRoutes (copy), sanitizeRoutes (copy), validateNoDuplicateRoutes (copy)
	local v28 = joinHoleyArrays(require(Modules.LuaApp.Navigation.getLegacyRoutes)(getAppFeaturePolicies()), require(Modules.LuaApp.Components.Authentication.getAuthenticationRoutes)(), require(Modules.Personalization.getPersonalizationRoutes)(), require(Modules.LuaApp.Components.More.getMoreRoutes)(), if not FFlagProfilePlatformEnableCurrencyTransfer then {} else getCurrencyTransferRoutes(), if not FFlagLuaAppEnableFeatureTileAdPlayer then {} else getAdsRoutes(), getProfilePlatformRoutes(), getSocialRoutes(), getGroupRoutes())
	local v29 = sanitizeRoutes(v28)

	validateNoDuplicateRoutes(v29)

	return v29
end
