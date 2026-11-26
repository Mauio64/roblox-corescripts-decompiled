local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dRg")
local module2 = require("@luauforge/deferred/gRU")
local module3 = require("@luauforge/bundled/dPN")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory

require("@luauforge/deferred/haQ")

local avatarEditorCategories = require("@luauforge/bundled/dPt").Enums.AvatarEditorCategories

local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled

local function useAvatarOutfitSwitcherFrameProps(p2)
	local categoryInfo = if fFlagAXMigrateOutfitsToUserInventory then p2.categoryInfo else nil
	return React.useMemo(function()
		local v6 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorCategories.Avatars else module.EditableCharacterKey
		local v5 = {
			outfitKey = v6,
			outfitType = module3.OutfitTypes.Avatar,
			scrollPerformanceIntervalName = 0,
			showSettingsTile = true,
			showFolders = 0,
			categoryInfo = 0
		}

		local v7 = if fFlagAXScrollTelemetryIntegration2 then module2.AvatarOutfits else nil
		v5.scrollPerformanceIntervalName = v7

		v5.showFolders = fFlagAXAvatarFoldersEnabled and true or nil
		v5.categoryInfo = if fFlagAXMigrateOutfitsToUserInventory then categoryInfo else nil
		return v5
	end, { categoryInfo })
end

return useAvatarOutfitSwitcherFrameProps
