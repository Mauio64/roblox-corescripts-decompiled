local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local GuiObjectUtils = require(CorePackages.Workspace.Packages.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty

local function useLocalPlayer()
	return useProperty(Players, "LocalPlayer")
end

return useLocalPlayer
