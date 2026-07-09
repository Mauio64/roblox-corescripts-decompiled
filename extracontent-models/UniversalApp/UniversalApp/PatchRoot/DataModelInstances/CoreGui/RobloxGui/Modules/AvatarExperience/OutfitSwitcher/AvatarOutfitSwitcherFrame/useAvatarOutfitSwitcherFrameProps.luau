local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherFrame.useOutfitSwitcherFrameProps)

local function useAvatarOutfitSwitcherFrameProps() -- line: 17
	-- upvalues: React (copy), Constants (copy), Constants2 (copy)
	return React.useMemo(function() -- line: 18
		-- upvalues: Constants (copy), Constants2 (copy)
		return {
			showSettingsTile = true,
			outfitKey = Constants.EditableCharacterKey,
			outfitType = Constants2.OutfitTypes.Avatar
		}
	end, {})
end

return useAvatarOutfitSwitcherFrameProps
