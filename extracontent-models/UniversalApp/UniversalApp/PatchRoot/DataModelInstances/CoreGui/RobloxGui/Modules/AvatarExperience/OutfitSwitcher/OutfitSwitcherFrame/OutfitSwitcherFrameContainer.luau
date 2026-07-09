local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useOutfitSwitcherFrameProps = require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherFrame.useOutfitSwitcherFrameProps)
local OutfitSwitcherFrame = require(Modules.AvatarExperience.OutfitSwitcher.OutfitSwitcherFrame.OutfitSwitcherFrame)

local function OutfitSwitcherFrameContainer(p1) -- line: 11
	-- upvalues: useOutfitSwitcherFrameProps (copy), React (copy), OutfitSwitcherFrame (copy)
	local v8 = useOutfitSwitcherFrameProps(p1)

	return React.createElement(OutfitSwitcherFrame, v8)
end

return OutfitSwitcherFrameContainer
