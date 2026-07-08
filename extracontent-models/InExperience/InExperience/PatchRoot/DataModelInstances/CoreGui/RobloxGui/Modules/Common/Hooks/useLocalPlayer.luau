local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty

local function useLocalPlayer() -- line: 5
	-- upvalues: useProperty (copy), Players (copy)
	return useProperty(Players, "LocalPlayer")
end

return useLocalPlayer
