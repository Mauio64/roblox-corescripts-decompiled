local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetIABottomBarItems = require(Modules.LuaApp.Components.AppNav.GetIABottomBarItems)

local function getSwitchRoutesArray() -- line: 7
	-- upvalues: GetIABottomBarItems (copy), Cryo (copy)
	local v6, _ = GetIABottomBarItems()

	return Cryo.List.map(v6, function(p1) -- line: 9
		return p1.page
	end)
end

return getSwitchRoutesArray
