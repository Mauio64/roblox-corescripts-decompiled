local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local Flags = require(Foundation.Utility.Flags)
local Wrappers = require(Foundation.Utility.Wrappers)
local getMainGui = require(Foundation.Utility.getMainGui)
local GuiService = Wrappers.Services.GuiService
local CoreGui = Wrappers.Services.CoreGui
local RunService = Wrappers.Services.RunService
local Players = Wrappers.Services.Players
local u9 = nil

if not Flags.FoundationUseMainGuiUtility then
	u9 = if not Players.LocalPlayer or not RunService:IsRunning() then nil else Players.LocalPlayer:WaitForChild("PlayerGui", 3)
end

local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)

local function getHardwareSafeAreaInsets() -- line: 23
	-- upvalues: Flags (copy), GuiService (copy), getMainGui (copy), isPluginSecurity (copy), CoreGui (copy), u9 (ref)
	if Flags.FoundationUseGetInsetArea then
		local InsetArea = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
		local InsetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.None)

		return {
			left = InsetArea.Min.X - InsetArea2.Min.X,
			top = InsetArea.Min.Y - InsetArea2.Min.Y,
			right = InsetArea2.Max.X - InsetArea.Max.X,
			bottom = InsetArea2.Max.Y - InsetArea.Max.Y
		}
	end

	local v14 = if not Flags.FoundationUseMainGuiUtility then if not isPluginSecurity() then u9 else CoreGui else getMainGui()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "_FullscreenTestGui"
	ScreenGui.Parent = v14
	ScreenGui.ScreenInsets = Enum.ScreenInsets.None

	local ScreenGui2 = Instance.new("ScreenGui")

	ScreenGui2.Name = "_DeviceTestGui"
	ScreenGui2.Parent = v14
	ScreenGui2.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

	local v17 = ScreenGui2.AbsolutePosition - ScreenGui.AbsolutePosition
	local v18 = ScreenGui.AbsolutePosition + ScreenGui.AbsoluteSize - (ScreenGui2.AbsolutePosition + ScreenGui2.AbsoluteSize)
	local t1 = {
		left = v17.X,
		top = v17.Y,
		right = v18.X,
		bottom = v18.Y
	}

	ScreenGui.Parent = nil
	ScreenGui2.Parent = nil
	ScreenGui:Destroy()
	ScreenGui2:Destroy()

	return t1
end

return getHardwareSafeAreaInsets
