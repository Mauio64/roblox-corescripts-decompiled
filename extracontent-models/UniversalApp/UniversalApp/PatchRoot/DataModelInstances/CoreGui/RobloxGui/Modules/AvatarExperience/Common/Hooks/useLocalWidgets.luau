local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Dash = require(CorePackages.Packages.Dash)
local useSponsoredItemsLocalWidget = require(Modules.AvatarExperience.Common.Hooks.useSponsoredItemsLocalWidget)

require(Modules.AvatarExperience.Common.Types)

local function useLocalWidgets(s1: string, b1: boolean?, b2: boolean?) -- line: 28
	-- upvalues: useSponsoredItemsLocalWidget (copy), Dash (copy)
	local t1 = { useSponsoredItemsLocalWidget(s1, b1, b2) }
	local v10 = Dash.filter(t1, function(p1) -- line: 33
		return p1.isEnabled
	end)

	table.sort(v10, function(p2, p3) -- line: 37
		return p2.row < p3.row
	end)

	return v10
end

return useLocalWidgets
