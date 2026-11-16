local CoreGui = game:GetService("CoreGui")

local SystemScrim = script:FindFirstAncestor("SystemScrim")
local parent = SystemScrim.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local SystemScrim2 = require(SystemScrim.SystemScrim)
local SystemScrimSignalStore = require(SystemScrim["data-model"].SystemScrimSignalStore)

local function renderSystemScrim()
	local store = SystemScrimSignalStore(false)

	local systemScrim = Instance.new("ScreenGui")
	systemScrim.Name = "SystemScrim"
	systemScrim.DisplayOrder = -2147483648
	systemScrim.IgnoreGuiInset = true
	systemScrim.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	systemScrim.ClipToDeviceSafeArea = false
	systemScrim.ScreenInsets = Enum.ScreenInsets.None
	systemScrim.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	systemScrim.Parent = CoreGui

	local element = React.createElement(SystemScrim2, { store = store })

	local root = ReactRoblox.createRoot(systemScrim)
	root:render(element)

	return { root = root, store = store }
end

return renderSystemScrim
