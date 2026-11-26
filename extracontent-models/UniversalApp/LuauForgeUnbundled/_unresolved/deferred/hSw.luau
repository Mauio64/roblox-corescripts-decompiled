local CorePackages = game:GetService("CorePackages")
require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/fFQ")
require("@luauforge/bundled/hSx")

local module2 = require("@luauforge/bundled/hSy")
local module3 = require("@luauforge/bundled/hSA")
local module4 = require("@luauforge/deferred/hTq")
local module5 = require("@luauforge/deferred/hTs")

local module6 = require("@luauforge/bundled/hTt")
local module7 = require("@luauforge/deferred/hTv")

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
