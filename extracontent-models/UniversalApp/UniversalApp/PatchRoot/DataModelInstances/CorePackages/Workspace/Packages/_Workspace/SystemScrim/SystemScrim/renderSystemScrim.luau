local CoreGui = game:GetService("CoreGui")
local SystemScrim = script:FindFirstAncestor("SystemScrim")
local SystemScrimParent = SystemScrim.Parent
local React = require(SystemScrimParent.React)
local ReactRoblox = require(SystemScrimParent.ReactRoblox)
local SystemScrim2 = require(SystemScrim.SystemScrim)
local SystemScrimSignalStore = require(SystemScrim["data-model"].SystemScrimSignalStore)

local function renderSystemScrim() -- line: 13
	-- upvalues: SystemScrimSignalStore (copy), CoreGui (copy), React (copy), SystemScrim2 (copy), ReactRoblox (copy)
	local v9 = SystemScrimSignalStore(false)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "SystemScrim"
	ScreenGui.DisplayOrder = -2147483648
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ClipToDeviceSafeArea = false
	ScreenGui.ScreenInsets = Enum.ScreenInsets.None
	ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	ScreenGui.Parent = CoreGui

	local v11 = React.createElement(SystemScrim2, {
		store = v9
	})
	local v12 = ReactRoblox.createRoot(ScreenGui)

	v12:render(v11)

	return {
		root = v12,
		store = v9
	}
end

return renderSystemScrim
