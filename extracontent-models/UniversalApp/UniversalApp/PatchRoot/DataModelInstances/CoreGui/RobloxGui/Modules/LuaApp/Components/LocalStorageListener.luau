local AppStorageService = game:GetService("AppStorageService")
local LocalizationService = game:GetService("LocalizationService")
local NotificationService = game:GetService("NotificationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local CorePackages = game:GetService("CorePackages")
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local t = require(CorePackages.Packages.t)
local v10 = Roact.PureComponent:extend("LocalStorageListener")
local t1 = {
	mid = MessageBus.getMessageId("Locale", "RobloxLocaleIdChanged"),
	validateParams = t.strictInterface({
		localeId = t.string
	})
}

function v10.init(_) -- line: 23
end
function v10.render(_) -- line: 25
end
function v10.didMount(p3) -- line: 27
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy), LocalizationService (copy), MessageBus (copy), t1 (copy), NotificationService (copy)
	local Item = AppStorageService:GetItem(LocalStorageKey.RobloxLocaleId)

	if Item ~= "" then
		LocalizationService:SetRobloxLocaleId(Item)
	end

	p3.connections = { AppStorageService.ItemWasSet:Connect(function(p4, p5) -- line: 35
		-- upvalues: LocalStorageKey (copy), LocalizationService (copy), MessageBus (copy), t1 (copy), NotificationService (copy)
		if p4 == LocalStorageKey.RobloxLocaleId then
			LocalizationService:SetRobloxLocaleId(p5)

			local t2 = {
				localeId = p5
			}

			MessageBus.publish(t1, t2)

			return
		end

		if p4 == LocalStorageKey.AuthenticatedTheme then
			NotificationService.SelectedTheme = p5
		end
	end) }
end
function v10.willUnmount(p6) -- line: 49
	for _, v in ipairs(p6.connections) do
		v:Disconnect()
	end
end

return v10
