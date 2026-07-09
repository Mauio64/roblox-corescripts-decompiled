local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local createMockNavigationState = require(CorePackages.Workspace.Packages.NavigationRodux).TestUtils.createMockNavigationState
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local SortAndFilters = require(Modules.AvatarExperience.Catalog.Reducers.SortAndFilters)
local AssetInfo = require(Modules.AvatarExperience.Common.Models.AssetInfo)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local t1 = {}

t1.__index = t1
t1.DynamicHeadMoodAnimationAssetId = "10687293613"
t1.DylanDefaultHeadAssetId = "10687288296"
t1.DylanDefaultOutfitId = "11164330909"
t1.GeckoMoodAnimationAssetId = "10647852134"
t1.GeckoBundleId = "965"
t1.GeckoOutfitId = "11625687672"
t1.DylanDefaultBundleId = "945"
t1.YellowSciFiJacketAssetId = "11449307353"
t1.NinjaIdleAnimationAssetId = "658832408"
t1.DefaultLocalUserId = "129687796"
t1.BodybuilderEmoteAssetId = "3994130516"
t1.BodybuilderKeyframeSequenceAssetId = "10713990381"
t1.PirateAnimationBundleId = "55"
t1.PirateIdleAnimationAssetId = "837024662"
t1.PirateRunAnimationAssetId = "837023444"
t1.PirateJumpAnimationAssetId = "837024350"
t1.DummySearchUid = "test_uuid"
t1.DummyKeyword = "test"
t1.DunceHatAssetId = "12536385254"
t1.PirateOutfitId = "132923221"
t1.NumPirateAnimations = 0
t1.UnusedItemId = "1011011010"

local t2 = {
	[t1.PirateRunAnimationAssetId] = {
		assetType = "53"
	},
	["837023892"] = {
		assetType = "55"
	},
	["837024147"] = {
		assetType = "50"
	},
	[t1.PirateJumpAnimationAssetId] = {
		assetType = "52"
	},
	[t1.PirateIdleAnimationAssetId] = {
		assetType = "51"
	},
	["837025054"] = {
		assetType = "54"
	},
	["837025325"] = {
		assetType = "48"
	}
}

for _, _ in t2 do
	t1.NumPirateAnimations = t1.NumPirateAnimations + 1
end

local t3 = {}

for v18, _ in t2 do
	table.insert(t3, {
		id = v18,
		type = Constants.ItemType.Asset
	})
end

table.insert(t3, {
	id = t1.PirateOutfitId,
	type = Constants.ItemType.Outfit
})

function t1.new(p1) -- line: 224
	-- upvalues: t1 (copy)
	local t4 = {}

	setmetatable(t4, t1)
	t4.state = p1 or {}
	t4.itemRecency = 0

	return t4
end

t1.basicScales = {
	bodyType = 1,
	depth = 1,
	head = 1,
	height = 1,
	proportion = 0,
	width = 1
}

function t1.makeBodyColors(n1: number) -- line: 243
	return {
		headColorId = n1,
		leftArmColorId = n1,
		leftLegColorId = n1,
		rightArmColorId = n1,
		rightLegColorId = n1,
		torsoColorId = n1
	}
end
function t1.makeBodyColor3s(color3: Color3) -- line: 254
	return {
		headColor3 = color3,
		torsoColor3 = color3,
		rightArmColor3 = color3,
		leftArmColor3 = color3,
		rightLegColor3 = color3,
		leftLegColor3 = color3
	}
end
function t1.makeSkeletonOutfitInfo() -- line: 265
	-- upvalues: Constants (copy), t1 (copy)
	return {
		avatarType = "R15",
		containsDynamicHead = false,
		isEditable = false,
		name = "SkeletonOutfit",
		outfitId = "1234",
		updateCounter = 0,
		assets = {},
		outfitType = Constants.OutfitTypes.Avatar,
		bodyColor3s = t1.basicBodyColor3s,
		bodyColors = t1.basicBodyColors,
		scales = t1.basicScales
	}
end
function t1.makeSkeletonTryOnItem() -- line: 281
	-- upvalues: Constants (copy)
	return {
		version = "1",
		itemId = "dummy",
		selectedInTryOnManager = true,
		isUnequipped = false,
		receivedBundleInfo = false,
		itemRecency = 0,
		itemType = Constants.ItemType.Asset,
		itemSubType = Constants.AssetTypeIdStrings.JacketAccessory
	}
end

t1.basicBodyColors = t1.makeBodyColors(Constants2.DefaultBodyColorBrickId)
t1.basicBodyColor3s = t1.makeBodyColor3s(Constants2.DefaultBodyColor3)

function t1.getState(p2) -- line: 297
	return p2.state
end
function t1.addCameraButtonStatus(t5: {[any]: any}, b1: boolean) -- line: 301
	-- upvalues: Dash (copy)
	local t6 = {
		AvatarExperience = {
			CameraButton = {
				enabled = b1
			}
		}
	}

	t5.state = Dash.joinDeep(t6, t5.state)

	return t5
end
function t1.addCameraButtonErrorOccurred(t7: {[any]: any}, b2: boolean) -- line: 314
	-- upvalues: Dash (copy)
	local t8 = {
		AvatarExperience = {
			CameraButton = {
				errorOccurred = b2
			}
		}
	}

	t7.state = Dash.joinDeep(t8, t7.state)

	return t7
end
function t1.addFetchStatus(t9: {[any]: any}, s1: string, s2: string) -- line: 327
	-- upvalues: Dash (copy)
	local t10 = {
		AvatarExperience = {
			AvatarEditor = {
				UserInventoryRecommendationsFetchStatus = {
					[s1] = s2
				}
			}
		}
	}

	t9.state = Dash.joinDeep(t10, t9.state)

	return t9
end
function t1.addCurrentCharacter(t11: {[any]: any}, p3, b3: boolean?) -- line: 341
	-- upvalues: Constants3 (copy), Dash (copy)
	if not p3 then
		local Players = game:GetService("Players")
		local v39 = if not b3 then Enum.HumanoidRigType.R15 else Enum.HumanoidRigType.R6

		p3 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), v39) else Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), v39)
	end

	assert(p3, "character is not nil.")
	p3.Parent = workspace

	local t12 = {
		AvatarExperience = {
			AvatarEditor = {
				Character = {
					AvatarType = if not b3 then Constants3.AvatarType.R15 else Constants3.AvatarType.R6
				}
			},
			AvatarScene = {
				Character = {
					CurrentCharacter = p3
				}
			}
		}
	}

	t11.state = Dash.joinDeep(t12, t11.state)

	return t11
end
function t1.addPPEStartState(p4) -- line: 384
	-- upvalues: PPEThumbnailType (copy), Dash (copy)
	local t13 = {
		AvatarExperience = {
			ProfilePictureEditor = {
				ProfilePictureParams = {
					ppeEmoteLoadingCount = 0,
					ppeVersion = {
						[PPEThumbnailType.Closeup] = 0,
						[PPEThumbnailType.FullBody] = 0
					}
				}
			}
		}
	}

	p4.state = Dash.joinDeep(t13, p4.state)

	return p4
end
function t1.addLocalUserId(t14: {[any]: any}, s3: string?) -- line: 402
	-- upvalues: t1 (copy), Dash (copy)
	if not s3 then
		s3 = t1.DefaultLocalUserId
	end

	local t15 = {
		LocalUserId = s3
	}

	t14.state = Dash.joinDeep(t15, t14.state)

	return t14
end
function t1.addEquippedItem(p5, p6, p7) -- line: 415
	-- upvalues: Dash (copy)
	local t16 = {
		AvatarExperience = {
			AvatarEditor = {
				Character = {
					EquippedAssets = {
						[p6] = p7
					}
				}
			}
		}
	}

	p5.state = Dash.joinDeep(t16, p5.state)

	return p5
end
function t1.addEquippedNinjaIdleAnimation(p8) -- line: 435
	-- upvalues: Constants (copy), t1 (copy)
	return p8:addEquippedItem(Constants.AssetTypeIdStrings.IdleAnimation, {
		[t1.NinjaIdleAnimationAssetId] = {
			isLayered = false,
			version = "nil"
		}
	})
end
function t1.addEquippedYellowSciFiJacket(p9) -- line: 444
	-- upvalues: Constants (copy), t1 (copy)
	return p9:addEquippedItem(Constants.AssetTypeIdStrings.JacketAccessory, {
		[t1.YellowSciFiJacketAssetId] = {
			isLayered = true,
			order = 12,
			version = "1",
			type = Enum.AccessoryType.Jacket
		}
	})
end
function t1.addEquippedHat(p10) -- line: 455
	-- upvalues: Constants (copy), t1 (copy)
	return p10:addEquippedItem(Constants.AssetTypeIdStrings.Hat, {
		[t1.DunceHatAssetId] = {
			isLayered = false,
			version = "1",
			type = Enum.AccessoryType.Hat
		}
	})
end
function t1.addEquippedShirt(p11) -- line: 465
	-- upvalues: Constants (copy)
	return p11:addEquippedItem(Constants.AssetTypeIdStrings.ShirtAccessory, {
		["9512497883"] = {
			isLayered = true,
			order = 10,
			version = "1",
			type = Enum.AccessoryType.Shirt
		}
	})
end
function t1.addEquippedGear(p12) -- line: 476
	-- upvalues: Constants (copy)
	return p12:addEquippedItem(Constants.AssetTypeIdStrings.Gear, {
		["1132887630"] = {
			version = "1"
		}
	})
end
function t1.addEquippedDynamicHead(p13) -- line: 484
	-- upvalues: Constants (copy), t1 (copy)
	return p13:addEquippedItem(Constants.AssetTypeIdStrings.DynamicHead, {
		[t1.DylanDefaultHeadAssetId] = {
			isLayered = false,
			version = "nil"
		}
	})
end
function t1.addEquippedMoodAnimation(p14) -- line: 493
	-- upvalues: Constants (copy), t1 (copy)
	return p14:addEquippedItem(Constants.AssetTypeIdStrings.MoodAnimation, {
		[t1.DynamicHeadMoodAnimationAssetId] = {
			isLayered = false,
			version = "nil"
		}
	})
end
function t1.addOutfitTryOnItem(p15, p16, p17) -- line: 502
	-- upvalues: Dash (copy)
	p17.itemRecency = p15.itemRecency
	p15.itemRecency = p15.itemRecency + 1

	local t17 = {
		AvatarExperience = {
			AvatarScene = {
				OutfitTryOn = {
					TryOnItems = {
						[`{ p16 }-{ p17.itemType }`] = p17
					}
				}
			}
		}
	}

	p15.state = Dash.joinDeep(t17, p15.state)

	return p15
end
function t1.addOutfitTryOnLastToggledItem(p18, p19) -- line: 522
	-- upvalues: Dash (copy)
	local t18 = {
		AvatarExperience = {
			AvatarScene = {
				OutfitTryOn = {
					LastToggledItem = p19
				}
			}
		}
	}

	p18.state = Dash.joinDeep(t18, p18.state)

	return p18
end
function t1.addOutfitTryOnItemAsAsset(p20, p21, p22) -- line: 537
	-- upvalues: t1 (copy), Constants (copy), Dash (copy)
	local v67 = t1.makeSkeletonTryOnItem()

	v67.itemId = p21
	v67.itemType = Constants.ItemType.Asset
	v67.itemSubType = p22
	v67.itemRecency = p20.itemRecency
	p20.itemRecency = p20.itemRecency + 1

	local t19 = {
		AvatarExperience = {
			AvatarScene = {
				OutfitTryOn = {
					TryOnItems = {
						[p21] = v67
					}
				}
			}
		}
	}

	p20.state = Dash.joinDeep(t19, p20.state)

	return p20
end
function t1.addOutfitTryOnItemAsPartsBundleAsset(p23, p24, p25, p26) -- line: 565
	-- upvalues: t1 (copy), Constants (copy), Dash (copy)
	local v73 = t1.makeSkeletonTryOnItem()

	v73.itemId = p24
	v73.itemType = Constants.ItemType.Bundle
	v73.itemSubType = Constants.BundleTypeIdStrings.BodyParts
	v73.itemRecency = p23.itemRecency
	v73.bundleInfo = {
		[p25] = {
			assetType = p26
		}
	}
	p23.itemRecency = p23.itemRecency + 1

	local t20 = {
		AvatarExperience = {
			AvatarScene = {
				OutfitTryOn = {
					TryOnItems = {
						[p25] = v73
					}
				}
			}
		}
	}

	p23.state = Dash.joinDeep(t20, p23.state)

	return p23
end
function t1.addDylanDefaultOutfitTryOnItem(p27) -- line: 599
	-- upvalues: t1 (copy), Constants (copy)
	return p27:addOutfitTryOnItem(t1.DylanDefaultBundleId, {
		isUnequipped = false,
		itemRecency = 0,
		receivedBundleInfo = false,
		selectedInTryOnManager = true,
		version = "1",
		bundleInfo = {
			[t1.DylanDefaultHeadAssetId] = {
				assetType = Constants.AssetTypeIdStrings.DynamicHead
			},
			[t1.DynamicHeadMoodAnimationAssetId] = {
				assetType = Constants.AssetTypeIdStrings.MoodAnimation
			}
		},
		itemId = t1.DylanDefaultBundleId,
		itemSubType = Constants.BundleTypeIdStrings.DynamicHead,
		itemType = Constants.ItemType.Bundle
	})
end
function t1.addGeckoOutfitTryOnItem(p28) -- line: 620
	-- upvalues: t1 (copy), Constants (copy)
	return p28:addOutfitTryOnItem(t1.GeckoBundleId, {
		isUnequipped = false,
		itemRecency = 7,
		receivedBundleInfo = false,
		selectedInTryOnManager = true,
		version = "1",
		bundleInfo = {
			["10407915508"] = {
				assetType = Constants.AssetTypeIdStrings.DynamicHead
			},
			[t1.GeckoMoodAnimationAssetId] = {
				assetType = Constants.AssetTypeIdStrings.MoodAnimation
			},
			["2510230574"] = {
				assetType = "48"
			},
			["2510233257"] = {
				assetType = "50"
			},
			["2510235063"] = {
				assetType = "51"
			},
			["2510236649"] = {
				assetType = "52"
			},
			["2510238627"] = {
				assetType = "53"
			},
			["2510240941"] = {
				assetType = "54"
			},
			["2510242378"] = {
				assetType = "55"
			},
			["7200822331"] = {
				assetType = "29"
			},
			["7200822888"] = {
				assetType = "30"
			},
			["7200823471"] = {
				assetType = "28"
			},
			["7200824015"] = {
				assetType = "31"
			},
			["7200824885"] = {
				assetType = "27"
			},
			["7200826678"] = {
				assetType = "47"
			}
		},
		itemId = t1.GeckoBundleId,
		itemSubType = Constants.BundleTypeIdStrings.BodyParts,
		itemType = Constants.ItemType.Bundle
	})
end
function t1.addPirateAnimationOutfitTryOnItem(p29) -- line: 680
	-- upvalues: t1 (copy), t2 (copy), Constants (copy)
	return p29:addOutfitTryOnItem(t1.PirateAnimationBundleId, {
		isUnequipped = false,
		itemRecency = 0,
		receivedBundleInfo = true,
		selectedInTryOnManager = true,
		version = "1",
		bundleInfo = t2,
		itemId = t1.PirateAnimationBundleId,
		itemSubType = Constants.BundleTypeIdStrings.Animations,
		itemType = Constants.ItemType.Bundle
	})
end
function t1.addPirateAnimationOutfitTryOnLastToggledItem(p30) -- line: 694
	-- upvalues: t1 (copy), Constants (copy)
	local v79 = t1.makeSkeletonTryOnItem()

	v79.itemId = t1.PirateAnimationBundleId
	v79.itemType = Constants.ItemType.Bundle

	return p30:addOutfitTryOnLastToggledItem(v79)
end
function t1.addDHWithNoMoodOutfitTryOnItem(p31) -- line: 706
	-- upvalues: t1 (copy), Constants (copy)
	return p31:addOutfitTryOnItem(t1.GeckoBundleId, {
		isUnequipped = false,
		itemRecency = 7,
		itemSubType = "1",
		receivedBundleInfo = false,
		selectedInTryOnManager = true,
		version = "1",
		bundleInfo = {
			["10407915508"] = {
				assetType = Constants.AssetTypeIdStrings.DynamicHead
			},
			["2510230574"] = {
				assetType = "48"
			},
			["2510233257"] = {
				assetType = "50"
			},
			["2510235063"] = {
				assetType = "51"
			},
			["2510236649"] = {
				assetType = "52"
			},
			["2510238627"] = {
				assetType = "53"
			},
			["2510240941"] = {
				assetType = "54"
			},
			["2510242378"] = {
				assetType = "55"
			},
			["7200822331"] = {
				assetType = "29"
			},
			["7200822888"] = {
				assetType = "30"
			},
			["7200823471"] = {
				assetType = "28"
			},
			["7200824015"] = {
				assetType = "31"
			},
			["7200824885"] = {
				assetType = "27"
			},
			["7200826678"] = {
				assetType = "47"
			}
		},
		itemId = t1.GeckoBundleId,
		itemType = Constants.ItemType.Bundle
	})
end
function t1.addTryOnAnimation(t21: {[any]: any}, s4: string) -- line: 763
	-- upvalues: Dash (copy)
	local t22 = {
		AvatarExperience = {
			AvatarScene = {
				TryOn = {
					AnimationPreview = s4
				}
			}
		}
	}

	t21.state = Dash.joinDeep(t22, t21.state)

	return t21
end
function t1.addPirateTryOnAnimation(p32) -- line: 778
	-- upvalues: t1 (copy)
	return p32:addTryOnAnimation(t1.PirateIdleAnimationAssetId)
end
function t1.addAssetInfo(p33, p34) -- line: 782
	-- upvalues: Dash (copy)
	local id = p34.id

	assert(id ~= nil, "assetInfo should have an id")

	local t23 = {
		AvatarExperience = {
			Common = {
				AssetInfos = {
					[id] = p34
				}
			}
		}
	}

	p33.state = Dash.joinDeep(t23, p33.state)

	return p33
end
function t1.addBundleInfo(p35, p36) -- line: 799
	-- upvalues: Dash (copy)
	local id = p36.id

	assert(id ~= nil, "bundleInfo should have an id")

	local t24 = {
		AvatarExperience = {
			Common = {
				BundleInfos = {
					[id] = p36
				}
			}
		}
	}

	p35.state = Dash.joinDeep(t24, p35.state)

	return p35
end
function t1.addPirateAnimationAssetInfos(p37) -- line: 816
	-- upvalues: t2 (copy), AssetInfo (copy)
	for v94, v95 in t2 do
		local v96 = AssetInfo.mock()

		v96.id = v94
		v96.assetType = v95.assetType
		p37 = p37:addAssetInfo(v96)
	end

	return p37
end
function t1.addDunceHatAssetInfo(p38) -- line: 826
	-- upvalues: AssetInfo (copy), t1 (copy)
	return p38:addAssetInfo((AssetInfo.fromGetCatalogItemData({
		receivedCatalogData = true,
		name = "Dunce Hat",
		description = "Go sit in the corner",
		price = 69,
		favoriteCount = 7486,
		isOwned = false,
		isPurchasable = true,
		id = t1.DunceHatAssetId,
		assetType = Enum.AvatarAssetType.Hat.Name,
		product = {
			id = "1379526016"
		},
		creator = {
			id = "13805545",
			name = "BRICK UGC",
			type = "Group",
			hasVerifiedBadge = true
		},
		itemStatus = {},
		itemRestrictions = {}
	})))
end
function t1.addDylanDefaultBundleInfo(p39) -- line: 852
	-- upvalues: t1 (copy), Constants (copy)
	return p39:addBundleInfo({
		description = "A look that never goes out of style.",
		expectedSellerId = "1",
		favoriteCount = 196358,
		isOwned = true,
		isPublicDomain = true,
		isPurchasable = false,
		name = "Dylan Default",
		priceInRobux = 0,
		priceStatus = "Free",
		receivedBundleDetails = true,
		receivedCatalogData = true,
		receivedFromSortResults = true,
		bundleType = tostring(Enum.BundleType.DynamicHead.Value),
		id = t1.DylanDefaultBundleId,
		itemStatus = {},
		itemType = Constants.ItemType.Bundle,
		items = {
			[1] = {
				id = t1.DylanDefaultHeadAssetId,
				type = Constants.ItemType.Asset
			},
			[2] = {
				id = t1.DynamicHeadMoodAnimationAssetId,
				type = Constants.ItemType.Asset
			},
			[3] = {
				id = t1.DylanDefaultOutfitId,
				type = Constants.ItemType.Outfit
			}
		}
	})
end
function t1.addGeckoBundleInfo(p40) -- line: 887
	-- upvalues: Constants (copy), t1 (copy)
	return p40:addBundleInfo({
		description = "Some geckos have been seen running across the surface of water. Other geckos refer to them as \"overachievers.\"",
		expectedSellerId = "1",
		favoriteCount = 24889,
		isOwned = false,
		isPublicDomain = false,
		isPurchasable = true,
		name = "Galloping Gecko",
		priceInRobux = 500,
		receivedBundleDetails = true,
		receivedCatalogData = true,
		receivedFromSortResults = true,
		bundleType = Constants.BundleTypeIdStrings.BodyParts,
		creator = {
			hasVerifiedBadge = true,
			id = "1",
			name = "Roblox",
			type = "User"
		},
		id = t1.GeckoBundleId,
		itemRestrictions = {},
		itemStatus = {},
		itemType = Constants.ItemType.Bundle,
		items = {
			[1] = {
				id = "7200822331",
				type = Constants.ItemType.Asset
			},
			[2] = {
				id = "7200822888",
				type = Constants.ItemType.Asset
			},
			[3] = {
				id = "7200823471",
				type = Constants.ItemType.Asset
			},
			[4] = {
				id = "7200824015",
				type = Constants.ItemType.Asset
			},
			[5] = {
				id = "7200824885",
				type = Constants.ItemType.Asset
			},
			[6] = {
				id = "10407915508",
				type = Constants.ItemType.Asset
			},
			[7] = {
				id = "7200826678",
				type = Constants.ItemType.Asset
			},
			[8] = {
				id = "2510230574",
				type = Constants.ItemType.Asset
			},
			[9] = {
				id = "2510233257",
				type = Constants.ItemType.Asset
			},
			[10] = {
				id = "2510235063",
				type = Constants.ItemType.Asset
			},
			[11] = {
				id = "2510236649",
				type = Constants.ItemType.Asset
			},
			[12] = {
				id = "2510238627",
				type = Constants.ItemType.Asset
			},
			[13] = {
				id = "2510240941",
				type = Constants.ItemType.Asset
			},
			[14] = {
				id = "2510242378",
				type = Constants.ItemType.Asset
			},
			[15] = {
				id = t1.GeckoMoodAnimationAssetId,
				type = Constants.ItemType.Asset
			},
			[16] = {
				id = t1.GeckoOutfitId,
				type = Constants.ItemType.Outfit
			},
			[17] = {
				id = "11625698220",
				type = Constants.ItemType.Outfit
			}
		},
		product = {
			id = "1324726369",
			isForSale = true,
			type = "productType"
		}
	})
end
function t1.addPirateAnimationBundleInfo(p41) -- line: 989
	-- upvalues: Constants (copy), t3 (copy)
	return p41:addBundleInfo({
		bundleType = "2",
		description = "This animation pack only works with R15 avatars. Arr, I'll wipe the deck with ya blasted swabbies!",
		expectedSellerId = "1",
		favoriteCount = 99606,
		id = "55",
		isOwned = true,
		isPublicDomain = false,
		isPurchasable = false,
		name = "Pirate Animation Package",
		priceInRobux = 750,
		receivedBundleDetails = true,
		receivedCatalogData = true,
		receivedFromSortResults = true,
		creator = {
			hasVerifiedBadge = true,
			id = "1",
			name = "Roblox",
			type = "User"
		},
		itemRestrictions = {},
		itemStatus = {},
		itemType = Constants.ItemType.Bundle,
		items = t3,
		product = {
			id = "1324726369",
			isForSale = true,
			type = "productType"
		}
	})
end
function t1.addOutfitInfo(p42, p43, p44) -- line: 1022
	-- upvalues: Dash (copy)
	local t25 = {
		AvatarExperience = {
			AvatarEditor = {
				OutfitInfos = {
					[p43] = p44
				}
			}
		}
	}

	p42.state = Dash.joinDeep(t25, p42.state)

	return p42
end
function t1.addDylanDefaultOutfitInfo(p45) -- line: 1037
	-- upvalues: t1 (copy), Constants (copy)
	local v106 = t1.makeSkeletonOutfitInfo()

	v106.assets = {
		[Constants.AssetTypeIdStrings.MoodAnimation] = {
			[t1.DynamicHeadMoodAnimationAssetId] = {
				isLayered = false,
				version = "nil"
			}
		},
		[Constants.AssetTypeIdStrings.DynamicHead] = {
			[t1.DylanDefaultHeadAssetId] = {
				isLayered = false,
				version = "nil"
			}
		}
	}
	v106.containsDynamicHead = true
	v106.name = "Dylan Default"
	v106.outfitId = t1.DylanDefaultOutfitId
	v106.outfitType = Constants.OutfitTypes.DynamicHead

	return p45:addOutfitInfo(t1.DylanDefaultOutfitId, v106)
end
function t1.addGeckoOutfitInfo(p46) -- line: 1061
	-- upvalues: t1 (copy), Constants (copy)
	local v108 = t1.makeSkeletonOutfitInfo()

	v108.assets = {
		["27"] = {
			["7200824885"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["28"] = {
			["7200823471"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["29"] = {
			["7200822331"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["30"] = {
			["7200822888"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["31"] = {
			["7200824015"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["47"] = {
			["7200826678"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["48"] = {
			["2510230574"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["50"] = {
			["2510233257"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["51"] = {
			["2510235063"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["52"] = {
			["2510236649"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["53"] = {
			["2510238627"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["54"] = {
			["2510240941"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["55"] = {
			["2510242378"] = {
				isLayered = false,
				version = "nil"
			}
		},
		[Constants.AssetTypeIdStrings.MoodAnimation] = {
			[t1.GeckoMoodAnimationAssetId] = {
				isLayered = false,
				version = "nil"
			}
		},
		[Constants.AssetTypeIdStrings.DynamicHead] = {
			["10407915508"] = {
				isLayered = false,
				version = "nil"
			}
		}
	}
	v108.outfitType = Constants.OutfitTypes.Avatar
	v108.name = "Galloping Gecko"
	v108.outfitId = t1.GeckoOutfitId
	v108.containsDynamicHead = true

	return p46:addOutfitInfo(t1.GeckoOutfitId, v108)
end
function t1.addPirateAnimationOutfitInfo(p47) -- line: 1162
	-- upvalues: t1 (copy)
	local v110 = t1.makeSkeletonOutfitInfo()

	v110.assets = {
		["48"] = {
			["837025325"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["50"] = {
			["837024147"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["51"] = {
			[t1.PirateIdleAnimationAssetId] = {
				isLayered = false,
				version = "nil"
			}
		},
		["52"] = {
			[t1.PirateJumpAnimationAssetId] = {
				isLayered = false,
				version = "nil"
			}
		},
		["53"] = {
			[t1.PirateRunAnimationAssetId] = {
				isLayered = false,
				version = "nil"
			}
		},
		["54"] = {
			["837025054"] = {
				isLayered = false,
				version = "nil"
			}
		},
		["55"] = {
			["837023892"] = {
				isLayered = false,
				version = "nil"
			}
		}
	}
	v110.name = "Pirate Animation Package"
	v110.outfitId = t1.PirateOutfitId

	return p47:addOutfitInfo(t1.PirateOutfitId, v110)
end
function t1.addCategory(t26: {[any]: any}, n2: number) -- line: 1214
	-- upvalues: Dash (copy)
	local t27 = {
		AvatarExperience = {
			AvatarEditor = {
				Categories = {
					category = n2
				}
			}
		}
	}

	t26.state = Dash.joinDeep(t27, t26.state)

	return t26
end
function t1.addEquippedEmote(t28: {[any]: any}, n3: number, s5: string) -- line: 1228
	-- upvalues: Dash (copy)
	local t29 = {
		AvatarExperience = {
			AvatarEditor = {
				EquippedEmotes = {
					selectedSlot = n3,
					slotInfo = {{
						assetId = s5
					}}
				}
			}
		}
	}

	t28.state = Dash.joinDeep(t29, t28.state)

	return t28
end
function t1.addBodybuilderEquippedEmote(p48) -- line: 1247
	-- upvalues: t1 (copy)
	return p48:addEquippedEmote(1, t1.BodybuilderEmoteAssetId)
end
function t1.addIsInAx(p49) -- line: 1251
	-- upvalues: createMockNavigationState (copy), AvatarScreen (copy), Dash (copy)
	local t30 = {
		Navigation = createMockNavigationState(AvatarScreen.AvatarExperienceRoot)
	}

	p49.state = Dash.joinDeep(t30, p49.state)

	return p49
end
function t1.addPPEFinalPageFullView(p50) -- line: 1259
	-- upvalues: PPEThumbnailType (copy), Dash (copy)
	local t31 = {
		AvatarExperience = {
			ProfilePictureEditor = {
				FinalPageViewMode = {
					finalPageViewMode = PPEThumbnailType.FullBody
				}
			}
		}
	}

	p50.state = Dash.joinDeep(t31, p50.state)

	return p50
end
function t1.addSelectedPPEEmote(t32: {[any]: any}, s6: string) -- line: 1273
	-- upvalues: Dash (copy)
	local t33 = {
		AvatarExperience = {
			ProfilePictureEditor = {
				ProfilePictureParams = {
					emoteAssetId = s6
				}
			}
		}
	}

	t32.state = Dash.joinDeep(t33, t32.state)

	return t32
end
function t1.addBodyBuilderSelectedPPEEmote(p51) -- line: 1287
	-- upvalues: t1 (copy)
	return p51:addSelectedPPEEmote(t1.BodybuilderEmoteAssetId)
end
function t1.addAvatarEditorCategoryAndSubcategory(t34: {[any]: any}, n4: number, n5: number?) -- line: 1291
	-- upvalues: Dash (copy)
	local t35 = {
		AvatarExperience = {
			AvatarEditor = {
				Categories = {
					category = n4,
					subcategory = n5
				}
			}
		}
	}

	t34.state = Dash.joinDeep(t35, t34.state)

	return t34
end
function t1.addAvatarEditorCategoryAndSubcategoryByName(t36: {[any]: any}, s7: string, s8: string?) -- line: 1309
	-- upvalues: GetAvatarEditorCategories (copy)
	local v134 = nil
	local v135 = nil
	local g140 = nil

	for v136, v137 in (GetAvatarEditorCategories()) do
		if s7 == v137.Name then
			v134 = v136

			if not s8 then
				break
			end

			assert(v137.Subcategories, "category.Subcategories should be non-nil")

			for v138, v139 in v137.Subcategories do
				if s8 == v139.Name then
					v135 = v138
					g140 = true
				end

				if g140 then
					break
				end
			end

			if not g140 then
				break
			end
		end

		if g140 then
			break
		end
	end

	g140 = false
	assert(v134, "categoryIndex should be non-nil")

	if s8 then
		assert(v135, "subcategoryIndex should be non-nil")
	end

	return t36:addAvatarEditorCategoryAndSubcategory(v134, v135)
end
function t1.addSortAndFilters(p52) -- line: 1339
	-- upvalues: SortAndFilters (copy), Dash (copy)
	local t37 = {
		AvatarExperience = {
			Catalog = {
				SortAndFilters = SortAndFilters(nil, {})
			}
		}
	}

	p52.state = Dash.joinDeep(t37, p52.state)

	return p52
end
function t1.addSearchInCatalog(p53, p54) -- line: 1351
	-- upvalues: t1 (copy), Dash (copy)
	local t38 = {
		AvatarExperience = {
			Search = {
				SearchesInCatalog = {
					[t1.DummySearchUid] = {
						keyword = t1.DummyKeyword,
						items = p54
					}
				}
			}
		}
	}

	p53.state = Dash.joinDeep(t38, p53.state)

	return p53
end
function t1.addItemDetailsPeekViewState(p55, p56) -- line: 1369
	-- upvalues: Dash (copy)
	local t39 = {
		AvatarExperience = {
			Common = {
				ItemDetailsPeekView = {
					viewState = p56
				}
			}
		}
	}

	p55.state = Dash.joinDeep(t39, p55.state)

	return p55
end
function t1.addFetchingStatus(t40: {[any]: any}, s9: string, s10: string) -- line: 1384
	-- upvalues: Dash (copy)
	local t41 = {
		FetchingStatus = {
			[s9] = s10
		}
	}

	t40.state = Dash.joinDeep(t41, t40.state)

	return t40
end

return t1
