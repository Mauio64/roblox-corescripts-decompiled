local FFlagAXBackgroundsRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsRoot")
local FFlagAXBackgroundsCustomizeHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsCustomizeHydration")

local defineFastFlag = game:DefineFastFlag("AXBackgroundsPersistence", false)

local v5 = pcall(function()
	local avatarBackground = Enum.AvatarAssetType.AvatarBackground

	local Players = game:GetService("Players")
	assert(
		typeof(Players.GetProfileConfigurationFromUserIdAsync) == "function",
		"GetProfileConfigurationFromUserIdAsync is unavailable"
	)
end)

return FFlagAXBackgroundsRoot and FFlagAXBackgroundsCustomizeHydration and defineFastFlag and v5
