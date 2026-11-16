local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local module = require("@luauforge/deferred/gTN")

local module2 = require("@luauforge/deferred/gTS")
require("@luauforge/bundled/dMc")

local fFlagAXBackgroundGeneration = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundGeneration

local function useLocalWidgets(p2, p3, p4)
	local v5 = module(p2, p3, p4)

	local v6 = if fFlagAXBackgroundGeneration then module2(p2, p3, p4) else nil

	local v7 = { v5 }

	if fFlagAXBackgroundGeneration then
		table.insert(v7, v6)
	end

	local filtered = Dash.filter(v7, function(p5)
		return p5.isEnabled
	end)

	table.sort(filtered, function(a, b): boolean
		return a.row < b.row
	end)

	return filtered
end

return useLocalWidgets
