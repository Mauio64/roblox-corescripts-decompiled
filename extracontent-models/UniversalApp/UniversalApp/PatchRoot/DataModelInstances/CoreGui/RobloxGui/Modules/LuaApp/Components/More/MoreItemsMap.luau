local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.React)

local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)

require(Modules.LuaApp.Components.More.MoreItems.Types)

local SwitchProfileSection = require(Modules.LuaApp.Components.More.MoreItems.SwitchProfileSection)
local DeviceSettingsSection = require(Modules.LuaApp.Components.More.MoreItems.DeviceSettingsSection)
local LicensingSection = require(Modules.LuaApp.Components.More.MoreItems.LicensingSection)
local VersionSection = require(Modules.LuaApp.Components.More.MoreItems.VersionSection)
local AccountSettingsInfoItem = require(Modules.LuaApp.Components.More.MoreItems.AccountSettingsInfoItem)
local LinkButtonItem = require(Modules.LuaApp.Components.More.MoreItems.LinkButtonItem)
local t1 = {
	[MorePageSettings.ItemType.Settings_SwitchProfileSection] = SwitchProfileSection,
	[MorePageSettings.ItemType.Settings_DeviceSettingsSection] = DeviceSettingsSection,
	[MorePageSettings.ItemType.About_LicensingSection] = LicensingSection,
	[MorePageSettings.ItemType.About_VersionSection] = VersionSection
}
local t2 = {
	[MorePageSettings.ItemType.Settings_AccountSettingsInfo] = AccountSettingsInfoItem,
	[MorePageSettings.ItemType.About_TermsOfService] = LinkButtonItem,
	[MorePageSettings.ItemType.About_Privacy] = LinkButtonItem
}

return {
	getSectionComponent = function(s1: string) -- line: 35
		-- upvalues: t1 (copy)
		return t1[s1]
	end,
	getItemComponent = function(s2: string) -- line: 39
		-- upvalues: t2 (copy)
		return t2[s2]
	end
}
