local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local Screens = require(AvatarWorkshop.Navigation.Screens)

local InventoryOutfitType = AvatarExperienceModel.Enums.InventoryOutfitType

return {
	[Screens.Inventory.Avatars] = { outfitInventoryType = InventoryOutfitType.Avatar },
	[Screens.Inventory.Body.FullBody] = { outfitInventoryType = InventoryOutfitType.Body },
	[Screens.Inventory.Body.Head] = { outfitInventoryType = InventoryOutfitType.DynamicHead },
	[Screens.Inventory.Body.Hair] = {
		assetTypes = { Enum.AvatarAssetType.HairAccessory }
	},
	[Screens.Inventory.Clothing.Top] = {
		assetTypes = {
			Enum.AvatarAssetType.TShirtAccessory,
			Enum.AvatarAssetType.ShirtAccessory,
			Enum.AvatarAssetType.SweaterAccessory
		}
	},
	[Screens.Inventory.Clothing.Outterwear] = {
		assetTypes = { Enum.AvatarAssetType.JacketAccessory }
	},
	[Screens.Inventory.Clothing.Bottom] = {
		assetTypes = {
			Enum.AvatarAssetType.PantsAccessory,
			Enum.AvatarAssetType.ShortsAccessory,
			Enum.AvatarAssetType.DressSkirtAccessory
		}
	},
	[Screens.Inventory.Clothing.Shoes] = { outfitInventoryType = InventoryOutfitType.Shoes },
	[Screens.Inventory.Clothing.ClassicShirt] = {
		assetTypes = { Enum.AvatarAssetType.Shirt }
	},
	[Screens.Inventory.Clothing.ClassicPants] = {
		assetTypes = { Enum.AvatarAssetType.Pants }
	},
	[Screens.Inventory.Clothing.ClassicTShirt] = {
		assetTypes = { Enum.AvatarAssetType.TShirt }
	},
	[Screens.Inventory.Accessories.Hat] = {
		assetTypes = { Enum.AvatarAssetType.Hat }
	},
	[Screens.Inventory.Accessories.Face] = {
		assetTypes = { Enum.AvatarAssetType.FaceAccessory }
	},
	[Screens.Inventory.Accessories.Neck] = {
		assetTypes = { Enum.AvatarAssetType.NeckAccessory }
	},
	[Screens.Inventory.Accessories.Back] = {
		assetTypes = { Enum.AvatarAssetType.BackAccessory }
	},
	[Screens.Inventory.Accessories.Waist] = {
		assetTypes = { Enum.AvatarAssetType.WaistAccessory }
	},
	[Screens.Inventory.Accessories.Shoulder] = {
		assetTypes = { Enum.AvatarAssetType.ShoulderAccessory }
	},
	[Screens.Inventory.Accessories.Front] = {
		assetTypes = { Enum.AvatarAssetType.FrontAccessory }
	},
	[Screens.Inventory.Accessories.Gear] = {
		assetTypes = { Enum.AvatarAssetType.Gear }
	},
	[Screens.Inventory.Animations.FullSet] = {
		outfitInventoryType = InventoryOutfitType.Animations
	},
	[Screens.Inventory.Animations.Idle] = {
		assetTypes = { Enum.AvatarAssetType.IdleAnimation }
	},
	[Screens.Inventory.Animations.Walk] = {
		assetTypes = { Enum.AvatarAssetType.WalkAnimation }
	},
	[Screens.Inventory.Animations.Run] = {
		assetTypes = { Enum.AvatarAssetType.RunAnimation }
	},
	[Screens.Inventory.Animations.Jump] = {
		assetTypes = { Enum.AvatarAssetType.JumpAnimation }
	},
	[Screens.Inventory.Animations.Fall] = {
		assetTypes = { Enum.AvatarAssetType.FallAnimation }
	},
	[Screens.Inventory.Animations.Climb] = {
		assetTypes = { Enum.AvatarAssetType.ClimbAnimation }
	},
	[Screens.Inventory.Animations.Swim] = {
		assetTypes = { Enum.AvatarAssetType.SwimAnimation }
	},
	[Screens.Inventory.Emotes] = {
		assetTypes = { Enum.AvatarAssetType.EmoteAnimation }
	}
}
