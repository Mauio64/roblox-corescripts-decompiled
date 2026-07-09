local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useMakeupOutfitSwitcherFrameProps = require(Modules.AvatarExperience.OutfitSwitcher.MakeupOutfitSwitcherFrame.useMakeupOutfitSwitcherFrameProps)
local OutfitSwitcherFrameContainer = require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherFrame.OutfitSwitcherFrameContainer)

local function MakeupOutfitSwitcherFrame() -- line: 15
	-- upvalues: useMakeupOutfitSwitcherFrameProps (copy), React (copy), OutfitSwitcherFrameContainer (copy)
	local v7 = useMakeupOutfitSwitcherFrameProps()

	return React.createElement(OutfitSwitcherFrameContainer, v7)
end

return MakeupOutfitSwitcherFrame
