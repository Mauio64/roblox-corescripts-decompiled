local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local RobloxSubscriptionHeadlessListenerHost = require(RobloxSubscriptionPurchaseApp.Components.RobloxSubscriptionHeadlessListenerHost)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

local v = nil
local RobloxSubscriptionHeadlessOverlayController = {}

function RobloxSubscriptionHeadlessOverlayController.render()
	local v2 = RobloxSubscriptionStore.get()
	v2.triggerUnmountUI()

	local robloxSubscriptionPurchaseHeadlessOverlay = Instance.new("Folder")
	robloxSubscriptionPurchaseHeadlessOverlay.Name = "RobloxSubscriptionPurchaseHeadlessOverlay"
	robloxSubscriptionPurchaseHeadlessOverlay.Parent = game:GetService("CoreGui")

	local root = ReactRoblox.createRoot(robloxSubscriptionPurchaseHeadlessOverlay)
	root:render(React.createElement(RobloxSubscriptionHeadlessListenerHost))

	local function cleanup()
		root:unmount()
		robloxSubscriptionPurchaseHeadlessOverlay:Destroy()
	end

	v = cleanup
	v2.setOnUnmountUI(cleanup)

	return cleanup
end

function RobloxSubscriptionHeadlessOverlayController.close()
	if v then
		v()
		v = nil
	end
end

return RobloxSubscriptionHeadlessOverlayController
