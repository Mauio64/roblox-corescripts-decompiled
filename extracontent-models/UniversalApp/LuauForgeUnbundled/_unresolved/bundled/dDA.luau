require("@game/CorePackages/Workspace/Packages/Navigation")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer
local fFlagEnableAmpV2Wizard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpV2Wizard
local fFlagUserLibrary = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUserLibrary
local module = require("@luauforge/bundled/dDC")
local module2 = require("@luauforge/bundled/eWy")
local module3 = require("@luauforge/bundled/eWB")
local module4 = require("@luauforge/bundled/eXj")
local module5 = require("@luauforge/bundled/fwt")
local module6 = require("@luauforge/bundled/fwv")

local function validateNoDuplicateRoutes(items)
	local set = {}

	for k, item in items do
		local v5 = next(item)

		if set[v5] then
			error(`Duplicate route name found: {v5}`)
		end

		set[v5] = true
	end
end

local function sanitizeRoutes(items)
	local result = {}

	for k, item in items do
		if item ~= nil and next(item) ~= nil then
			table.insert(result, item)
		end
	end

	return result
end

local function joinHoleyArrays(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v5 = select(i, ...)

		if v5 == nil then
			continue
		end

		for k, v6 in v5 do
			if v6 ~= nil then
				table.insert(result, v6)
			end
		end
	end

	return result
end

return function()
	local v6 = sanitizeRoutes(joinHoleyArrays(
		require("@luauforge/bundled/fwP")(getAppFeaturePolicies()),
		require("@luauforge/bundled/hzZ")(),
		require("@luauforge/bundled/hEo")(),
		require("@luauforge/bundled/hGP")(),
		not fFlagProfilePlatformEnableCurrencyTransfer and {} or module2(),
		module3(),
		module4(),
		module(),
		module5(),
		not fFlagEnableAmpV2Wizard and {} or require("@luauforge/bundled/guY").getAmpV2WizardRoutes(),
		not fFlagUserLibrary and {} or module6()
	))

	validateNoDuplicateRoutes(v6)

	return v6
end
