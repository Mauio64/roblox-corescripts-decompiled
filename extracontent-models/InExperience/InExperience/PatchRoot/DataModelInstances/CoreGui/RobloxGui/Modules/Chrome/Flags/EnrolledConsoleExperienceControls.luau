local CorePackages = game:GetService("CorePackages")
local FFlagEnableInExperienceHandheldControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableInExperienceHandheldControls
local Chrome = script.Parent.Parent.Parent.Chrome
local FFlagUnibarMenuOpenHamburger = require(Chrome.Flags.FFlagUnibarMenuOpenHamburger)
local FFlagUnibarMenuOpenSubmenu = require(Chrome.Flags.FFlagUnibarMenuOpenSubmenu)

return FFlagUnibarMenuOpenHamburger or FFlagUnibarMenuOpenSubmenu or FFlagEnableInExperienceHandheldControls
