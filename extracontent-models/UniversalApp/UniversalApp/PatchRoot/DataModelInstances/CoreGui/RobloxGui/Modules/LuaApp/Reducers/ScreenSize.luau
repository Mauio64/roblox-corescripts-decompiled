local CorePackages = game:GetService("CorePackages")
local Display = require(CorePackages.Workspace.Packages.Display)
local FFlagUseSignalsRoduxStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseSignalsRoduxStore
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetScreenSize = require(Modules.LuaApp.Actions.SetScreenSize)
local v6 = game:DefineFastFlag("DebugScreenSizeUseDisplayStore", false)

return function(vector2: Vector2?, p1, p2) -- line: 13
	-- upvalues: FFlagUseSignalsRoduxStore (copy), v6 (copy), Display (copy), SetScreenSize (copy)
	if FFlagUseSignalsRoduxStore and v6 then
		return Display.GetDisplayStore(false).getViewportSize(p2)
	end

	local v10 = vector2 or Vector2.new(0, 0)

	assert(v10, "")

	if p1.type == SetScreenSize.name then
		return p1.screenSize
	end

	return v10
end
