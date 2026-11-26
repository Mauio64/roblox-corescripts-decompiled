local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module2 = require("@luauforge/deferred/haQ")
local module3 = require("@luauforge/deferred/haX")

local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled

local v5 = if fFlagAXAvatarFoldersEnabled then require("@luauforge/deferred/hcv") else nil

local function OutfitSwitcherFrameContainer(p2)
	local v6 = module2(p2)
	return React.createElement(module3, v6)
end

local function FolderAwareOutfitSwitcherFrameContainer(p2)
	if p2.showFolders then
		return React.createElement(v5, p2)
	end

	return React.createElement(OutfitSwitcherFrameContainer, p2)
end

if fFlagAXAvatarFoldersEnabled then
	return FolderAwareOutfitSwitcherFrameContainer
end

return OutfitSwitcherFrameContainer
