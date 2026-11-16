local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableInExperienceHandheldControls = SharedFlags.FFlagEnableInExperienceHandheldControls

local Chrome = script.Parent.Parent.Parent.Chrome
local FFlagUnibarMenuOpenHamburger = require(Chrome.Flags.FFlagUnibarMenuOpenHamburger)
local FFlagUnibarMenuOpenSubmenu = require(Chrome.Flags.FFlagUnibarMenuOpenSubmenu)

return FFlagUnibarMenuOpenHamburger or FFlagUnibarMenuOpenSubmenu or FFlagEnableInExperienceHandheldControls
