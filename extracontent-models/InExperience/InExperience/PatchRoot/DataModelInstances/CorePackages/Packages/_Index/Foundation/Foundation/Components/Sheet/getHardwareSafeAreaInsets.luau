local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local Wrappers = require(Foundation.Utility.Wrappers)
local getMainGui = require(Foundation.Utility.getMainGui)
local GuiService = Wrappers.Services.GuiService

local function getHardwareSafeAreaInsets() -- line: 11
	-- upvalues: Flags (copy), GuiService (copy), getMainGui (copy)
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

	local v9 = getMainGui()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "_FullscreenTestGui"
	ScreenGui.Parent = v9
	ScreenGui.ScreenInsets = Enum.ScreenInsets.None

	local ScreenGui2 = Instance.new("ScreenGui")

	ScreenGui2.Name = "_DeviceTestGui"
	ScreenGui2.Parent = v9
	ScreenGui2.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

	local v12 = ScreenGui2.AbsolutePosition - ScreenGui.AbsolutePosition
	local v13 = ScreenGui.AbsolutePosition + ScreenGui.AbsoluteSize - (ScreenGui2.AbsolutePosition + ScreenGui2.AbsoluteSize)
	local t1 = {
		left = v12.X,
		top = v12.Y,
		right = v13.X,
		bottom = v13.Y
	}

	ScreenGui.Parent = nil
	ScreenGui2.Parent = nil
	ScreenGui:Destroy()
	ScreenGui2:Destroy()

	return t1
end

return getHardwareSafeAreaInsets
