local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dRg")
local module2 = require("@luauforge/deferred/gRU")
local module3 = require("@luauforge/bundled/dPN")

local avatarEditorSubcategories = require("@luauforge/bundled/dPt").Enums.AvatarEditorSubcategories

require("@luauforge/deferred/haQ")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2

local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory
local fFlagAXEnableMakeupOutfitCreation = AvatarExperienceFlags.FFlagAXEnableMakeupOutfitCreation

local function useMakeupOutfitSwitcherFrameProps(p2)
	local categoryInfo = if fFlagAXMigrateOutfitsToUserInventory then p2.categoryInfo else nil
	return React.useMemo(function()
		local v6 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorSubcategories.MakeupLooks else module.MakeupOutfitKey
		local v5 = {
			outfitKey = v6,
			outfitType = module3.OutfitTypes.Makeup,
			scrollPerformanceIntervalName = 0,
			showFolders = 0,
			showSettingsTile = 0,
			categoryInfo = 0
		}

		local v7 = if fFlagAXScrollTelemetryIntegration2 then module2.MakeupLooks else nil
		v5.scrollPerformanceIntervalName = v7

		v5.showFolders = if fFlagAXAvatarFoldersEnabled then false else nil
		v5.showSettingsTile = fFlagAXEnableMakeupOutfitCreation
		v5.categoryInfo = if fFlagAXMigrateOutfitsToUserInventory then categoryInfo else nil
		return v5
	end, { categoryInfo })
end

return useMakeupOutfitSwitcherFrameProps
