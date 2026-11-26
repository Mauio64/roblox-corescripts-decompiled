local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local isSpatial = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isSpatial
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local fFlagEnableArgus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableArgus

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/dKy")

local function getSwitchRoutesArray()
	local v5, v6 = module2()
	local mapped = Cryo.List.map(v5, function(p2)
		return p2.page
	end)

	if fFlagEnableArgus and v6[module.Moments] == nil and not (isSpatial() or isTenFootInterface()) then
		table.insert(mapped, module.Moments)
	end

	return mapped
end

return getSwitchRoutesArray
