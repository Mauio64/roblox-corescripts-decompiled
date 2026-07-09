local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useAvatarOutfitSwitcherFrameProps = require(Modules.AvatarExperience.OutfitSwitcher.AvatarOutfitSwitcherFrame.useAvatarOutfitSwitcherFrameProps)
local OutfitSwitcherFrameContainer = require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherFrame.OutfitSwitcherFrameContainer)

local function AvatarOutfitSwitcherFrame() -- line: 15
	-- upvalues: useAvatarOutfitSwitcherFrameProps (copy), React (copy), OutfitSwitcherFrameContainer (copy)
	local v7 = useAvatarOutfitSwitcherFrameProps()

	return React.createElement(OutfitSwitcherFrameContainer, v7)
end

return AvatarOutfitSwitcherFrame
