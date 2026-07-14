local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local ReactRoblox = require(RobloxSubscriptionPurchaseAppParent.ReactRoblox)
local RobloxSubscriptionHeadlessListenerHost = require(RobloxSubscriptionPurchaseApp.Components.RobloxSubscriptionHeadlessListenerHost)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local u7 = nil

return {
	render = function() -- line: 19
		-- upvalues: RobloxSubscriptionStore (copy), ReactRoblox (copy), React (copy), RobloxSubscriptionHeadlessListenerHost (copy), u7 (ref)
		local v8 = RobloxSubscriptionStore.get()

		v8.triggerUnmountUI()

		local Folder = Instance.new("Folder")

		Folder.Name = "RobloxSubscriptionPurchaseHeadlessOverlay"
		Folder.Parent = game:GetService("CoreGui")

		local v10 = ReactRoblox.createRoot(Folder)

		v10:render(React.createElement(RobloxSubscriptionHeadlessListenerHost))

		local function cleanup() -- line: 30
			-- upvalues: v10 (copy), Folder (copy)
			v10:unmount()
			Folder:Destroy()
		end

		u7 = cleanup
		v8.setOnUnmountUI(cleanup)

		return cleanup
	end,
	close = function() -- line: 12
		-- upvalues: u7 (ref)
		if u7 then
			u7()
			u7 = nil
		end
	end
}
