local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundsCustomizeHydration = require(script.Parent.FFlagAXBackgroundsCustomizeHydration)
local v3 = game:DefineFastFlag("AXBackgroundsPersistence", false)
local ok = pcall(function() -- line: 7
	local _ = Enum.AvatarAssetType.AvatarBackground
	local _ = game:GetService("AvatarEditorService").PromptApplyProfileConfigurationCompleted

	assert(typeof(game:GetService("Players").GetProfileConfigurationFromUserIdAsync) == "function", "GetProfileConfigurationFromUserIdAsync is unavailable")
end)

return FFlagAXBackgroundsRoot and (FFlagAXBackgroundsCustomizeHydration and (v3 and ok))
