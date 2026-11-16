local CorePackages = game:GetService("CorePackages")
require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/fya")
require("@luauforge/bundled/hHQ")

local module2 = require("@luauforge/bundled/hHR")
local module3 = require("@luauforge/bundled/hHT")
local module4 = require("@luauforge/deferred/hIJ")
local module5 = require("@luauforge/deferred/hIL")

local module6 = require("@luauforge/bundled/hIM")
local module7 = require("@luauforge/deferred/hIO")

local modules = {
	[module.ItemType.Settings_SwitchProfileSection] = module2,
	[module.ItemType.Settings_DeviceSettingsSection] = module3,
	[module.ItemType.About_LicensingSection] = module4,
	[module.ItemType.About_VersionSection] = module5
}

local modules2 = {
	[module.ItemType.Settings_AccountSettingsInfo] = module6,
	[module.ItemType.About_TermsOfService] = module7,
	[module.ItemType.About_Privacy] = module7
}

return {
	getSectionComponent = function(p2)
		return modules[p2]
	end,
	getItemComponent = function(p2)
		return modules2[p2]
	end
}
