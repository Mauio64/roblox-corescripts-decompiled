local CorePackages = game:GetService("CorePackages")

local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local v = nil

local function getAccessResponseEnum()
	local v2 = v

	if v2 then
		return v2
	end

	local Eligibility = require(CorePackages.Workspace.Packages.AccountUpgrade.Eligibility)
	local accessResponseEnum = Eligibility.AccessResponseEnum
	v = accessResponseEnum
	return accessResponseEnum
end

local function defaultGetAvailability()
	local Eligibility = require(CorePackages.Workspace.Packages.AccountUpgrade.Eligibility)
	local AccountUpgradeFlow = require(CorePackages.Workspace.Packages.AccountUpgrade.AccountUpgradeFlow)
	return Eligibility.getAvailability(AccountUpgradeFlow.Pioneer)
end

local object = setmetatable({}, { __mode = "k" })

local function getAvailabilityOnce(callback)
	local v2 = object[callback]

	if v2 then
		return v2
	end

	local v3 = callback()

	local access = v3.access
	local v4 = v

	if not v4 then
		local Eligibility = require(CorePackages.Workspace.Packages.AccountUpgrade.Eligibility)
		v4 = Eligibility.AccessResponseEnum
		v = v4
	end

	if access == v4.Denied then
		object[callback] = v3
	end

	return v3
end

local function shouldShowMoreSettingsBanner(callback, callback2): boolean
	if not (callback or isPioneerLaunch)() then
		return false
	end

	local v2 = callback2 or defaultGetAvailability
	local v3 = object[v2]

	if not v3 then
		v3 = v2()

		local access = v3.access
		local v4 = v

		if not v4 then
			local Eligibility = require(CorePackages.Workspace.Packages.AccountUpgrade.Eligibility)
			v4 = Eligibility.AccessResponseEnum
			v = v4
		end

		if access == v4.Denied then
			object[v2] = v3
		end
	end

	local access = v3.access
	local v4 = v

	if not v4 then
		local Eligibility = require(CorePackages.Workspace.Packages.AccountUpgrade.Eligibility)
		v4 = Eligibility.AccessResponseEnum
		v = v4
	end

	return access == v4.Denied
end

return shouldShowMoreSettingsBanner
