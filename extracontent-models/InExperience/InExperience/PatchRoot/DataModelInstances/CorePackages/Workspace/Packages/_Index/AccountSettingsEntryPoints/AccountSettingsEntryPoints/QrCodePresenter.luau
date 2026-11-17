local CoreGui = game:GetService("CoreGui")

local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ReactRoblox = require(parent2.ReactRoblox)
local Foundation = require(parent2.Foundation)

require(parent.AccountSettingsPage)
local AccountSettingsQrDialog = require(parent.AccountSettingsQrDialog)

local v = nil

local function hide() -- 2 equivalent calls inferred from this helper
	local v2 = v

	if not v2 then
		return
	end

	v = nil
	v2.root:unmount()
	v2.container:Destroy()

	if v2.onClosed then
		v2.onClosed()
	end
end

return {
	show = function(page, onClosed)
		hide() -- inferred equivalent call
		local accountSettingsQrCode = Instance.new("Folder")
		accountSettingsQrCode.Name = "AccountSettingsQrCode"
		accountSettingsQrCode.Parent = CoreGui

		local root = ReactRoblox.createRoot(accountSettingsQrCode)
		local v2 = { root = root, container = accountSettingsQrCode, onClosed = onClosed }
		v = v2

		root:render(React.createElement(
			Foundation.FoundationProvider,
			{ colorMode = Foundation.Enums.ColorMode.Dark },
			{
				QrDialog = React.createElement(AccountSettingsQrDialog, {
					page = page,
					onClose = function()
						task.defer(function()
							if v == v2 then
								hide() -- inferred equivalent call
							end
						end)
					end
				})
			}
		))
	end,
	hide = hide
}
