local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundsCustomizeHydration = require(script.Parent.FFlagAXBackgroundsCustomizeHydration)

local defineFastFlag = game:DefineFastFlag("AXBackgroundsPersistence", false)

local v = pcall(function()
	local _avatarBackground = Enum.AvatarAssetType.AvatarBackground

	local AvatarEditorService = game:GetService("AvatarEditorService")
	local _promptApplyProfileConfigurationCompleted = AvatarEditorService.PromptApplyProfileConfigurationCompleted
	local Players = game:GetService("Players")
	assert(
		typeof(Players.GetProfileConfigurationFromUserIdAsync) == "function",
		"GetProfileConfigurationFromUserIdAsync is unavailable"
	)
end)

return FFlagAXBackgroundsRoot and FFlagAXBackgroundsCustomizeHydration and defineFastFlag and v
