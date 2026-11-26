require("@game/CorePackages/Workspace/Packages/Navigation")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer
local fFlagEnableAmpV2Wizard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpV2Wizard
local fFlagUserLibrary = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUserLibrary
local module = require("@luauforge/bundled/dGH")
local module2 = require("@luauforge/bundled/fdx")
local module3 = require("@luauforge/bundled/fdA")
local module4 = require("@luauforge/bundled/fej")
local module5 = require("@luauforge/bundled/fDT")
local module6 = require("@luauforge/bundled/fDV")

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
		require("@luauforge/bundled/fEp")(getAppFeaturePolicies()),
		require("@luauforge/bundled/hLo")(),
		require("@luauforge/bundled/hPp")(),
		require("@luauforge/bundled/hRv")(),
		not fFlagProfilePlatformEnableCurrencyTransfer and {} or module2(),
		module3(),
		module4(),
		module(),
		module5(),
		not fFlagEnableAmpV2Wizard and {} or require("@luauforge/bundled/fIc").getAmpV2WizardRoutes(),
		not fFlagUserLibrary and {} or module6()
	))

	validateNoDuplicateRoutes(v6)

	return v6
end
