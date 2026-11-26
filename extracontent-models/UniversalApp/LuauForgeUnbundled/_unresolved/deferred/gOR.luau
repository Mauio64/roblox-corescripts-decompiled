local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/deferred/gOS")

local module2 = require("@luauforge/deferred/gRD")
local module3 = require("@luauforge/deferred/gRS")
local module4 = require("@luauforge/deferred/gSc")

local module5 = require("@luauforge/deferred/gSi")
local module6 = require("@luauforge/deferred/gSl")
local module7 = require("@luauforge/deferred/gSr")
local module8 = require("@luauforge/deferred/gTs")

local module9 = require("@luauforge/deferred/gVp")

local module10 = require("@luauforge/deferred/gRz")

local fFlagAXGifting = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXGifting

local v5 = {
	[avatarScreen.ItemDetails] = module,
	[avatarScreen.ResellersPage] = module3,
	[avatarScreen.SellItemPage] = module4,
	[avatarScreen.TryOnItem] = module7,
	[avatarScreen.ItemOwnershipPage] = module5,
	[avatarScreen.SellItemPeekView] = module6,
	[avatarScreen.AvatarBackground] = module10(module8),
	[avatarScreen.OutfitDetails] = module2,
	[avatarScreen.AppCatalogContextMenuHost] = module9
}

if not fFlagAXGifting then
	return v5
end

local components = require("@luauforge/deferred/gRa").Components
local module11 = require("@luauforge/deferred/gVq")

v5[avatarScreen.SendGiftRecipientPicker] = module11(components.AvatarItemGiftRecipientPicker)
v5[avatarScreen.SendGiftReview] = module11(components.AvatarItemGiftReviewSheet)

return v5
