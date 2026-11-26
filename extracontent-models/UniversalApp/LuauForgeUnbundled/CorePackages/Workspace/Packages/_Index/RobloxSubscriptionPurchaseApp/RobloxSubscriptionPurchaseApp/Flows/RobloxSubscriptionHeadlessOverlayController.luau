local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/ReactRoblox")

local RobloxSubscriptionHeadlessListenerHost = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/RobloxSubscriptionHeadlessListenerHost")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")

local v5 = nil

return {
	render = function()
		local v6 = RobloxSubscriptionStore.get()
		v6.triggerUnmountUI()

		local robloxSubscriptionPurchaseHeadlessOverlay = Instance.new("Folder")
		robloxSubscriptionPurchaseHeadlessOverlay.Name = "RobloxSubscriptionPurchaseHeadlessOverlay"
		robloxSubscriptionPurchaseHeadlessOverlay.Parent = game:GetService("CoreGui")

		local root = ReactRoblox.createRoot(robloxSubscriptionPurchaseHeadlessOverlay)
		root:render(React.createElement(RobloxSubscriptionHeadlessListenerHost))

		local function cleanup()
			root:unmount()
			robloxSubscriptionPurchaseHeadlessOverlay:Destroy()
		end

		v5 = cleanup
		v6.setOnUnmountUI(cleanup)

		return cleanup
	end,
	close = function()
		if v5 then
			v5()
			v5 = nil
		end
	end
}
