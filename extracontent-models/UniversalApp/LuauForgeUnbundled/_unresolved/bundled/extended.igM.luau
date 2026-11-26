local AppStorageService = game:GetService("AppStorageService")
local LocalizationService = game:GetService("LocalizationService")
local NotificationService = game:GetService("NotificationService")

local module = require("@luauforge/bundled/ego")

local CorePackages = game:GetService("CorePackages")
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local messageBus = require("@luauforge/bundled/ggr").MessageBus
local t = require(CorePackages.Packages.t)

local extended = module.PureComponent:extend("LocalStorageListener")

local v5 = {
	mid = messageBus.getMessageId("Locale", "RobloxLocaleIdChanged"),
	validateParams = t.strictInterface({ localeId = t.string })
}

function extended.init(p2) end

function extended.render(p2) end

function extended:didMount()
	local item = AppStorageService:GetItem(localStorageKey.RobloxLocaleId)

	if item ~= "" then
		LocalizationService:SetRobloxLocaleId(item)
	end

	self.connections = { AppStorageService.ItemWasSet:Connect(function(p3, selectedTheme)
			if p3 == localStorageKey.RobloxLocaleId then
				LocalizationService:SetRobloxLocaleId(selectedTheme)
				messageBus.publish(v5, { localeId = selectedTheme })
			elseif p3 == localStorageKey.AuthenticatedTheme then
				NotificationService.SelectedTheme = selectedTheme
			end
		end) }
end

function extended.willUnmount(p2)
	for i, connection in ipairs(p2.connections) do
		connection:Disconnect()
	end
end

return extended
