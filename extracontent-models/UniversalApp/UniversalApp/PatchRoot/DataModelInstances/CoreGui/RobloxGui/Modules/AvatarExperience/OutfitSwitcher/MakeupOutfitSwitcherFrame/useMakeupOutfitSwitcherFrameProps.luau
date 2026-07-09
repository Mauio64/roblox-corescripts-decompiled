local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherFrame.useOutfitSwitcherFrameProps)

local FFlagAXOutfitPageRevamp = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXOutfitPageRevamp

local function useMakeupOutfitSwitcherFrameProps() -- line: 20
	-- upvalues: React (copy), Constants (copy), Constants2 (copy), FFlagAXOutfitPageRevamp (copy)
	return React.useMemo(function() -- line: 21
		-- upvalues: Constants (copy), Constants2 (copy), FFlagAXOutfitPageRevamp (copy)
		return {
			outfitKey = Constants.MakeupOutfitKey,
			outfitType = Constants2.OutfitTypes.Makeup,
			showSettingsTile = FFlagAXOutfitPageRevamp
		}
	end, {})
end

return useMakeupOutfitSwitcherFrameProps
