local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/Foundation")

require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/AccountSettingsPage")
local AccountSettingsQrDialog = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/AccountSettingsQrDialog")

local v5 = nil

return {
	show = function(p2, onClosed)
		local v6 = v5

		if v6 then
			v5 = nil
			v6.root:unmount()
			v6.container:Destroy()

			if v6.onClosed then
				v6.onClosed()
			end
		end

		local accountSettingsQrCode = Instance.new("Folder")
		accountSettingsQrCode.Name = "AccountSettingsQrCode"
		accountSettingsQrCode.Parent = CoreGui

		local root = ReactRoblox.createRoot(accountSettingsQrCode)
		local v7 = {
			root = root,
			container = accountSettingsQrCode,
			onClosed = onClosed
		}
		v5 = v7

		root:render(React.createElement(
			Foundation.FoundationProvider,
			{ colorMode = Foundation.Enums.ColorMode.Dark },
			{
				QrDialog = React.createElement(AccountSettingsQrDialog, {
					page = p2,
					onClose = function()
						task.defer(function()
							if v5 == v7 then
								local v8 = v5

								if not v8 then
									return
								end

								v5 = nil
								v8.root:unmount()
								v8.container:Destroy()

								if v8.onClosed then
									v8.onClosed()
								end
							end
						end)
					end
				})
			}
		))
	end,
	hide = function()
		local v6 = v5

		if not v6 then
			return
		end

		v5 = nil
		v6.root:unmount()
		v6.container:Destroy()

		if v6.onClosed then
			v6.onClosed()
		end
	end
}
