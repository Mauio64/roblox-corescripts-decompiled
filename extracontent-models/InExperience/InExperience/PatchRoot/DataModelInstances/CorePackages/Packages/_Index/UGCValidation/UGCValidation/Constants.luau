local scriptParent = script.Parent
local Cryo = require(scriptParent.Parent.Cryo)
local ValidationRulesUtil = require(scriptParent.util.ValidationRulesUtil)
local ValidationEnums = require(scriptParent.validationSystem.ValidationEnums)
local getFFlagUGCValidationFixConstantsTypoLeg = require(scriptParent.flags.getFFlagUGCValidationFixConstantsTypoLeg)
local getFFlagUGCValidationEyebrowEyelashSupport = require(scriptParent.flags.getFFlagUGCValidationEyebrowEyelashSupport)
local getFFlagUGCValidateCheckHSROwner = require(scriptParent.flags.getFFlagUGCValidateCheckHSROwner)
local getFFlagUGCValidateCheckTexturePackOwner = require(scriptParent.flags.getFFlagUGCValidateCheckTexturePackOwner)
local getFFlagUGCValidationAnimationPackSupport = require(scriptParent.flags.getFFlagUGCValidationAnimationPackSupport)
local v10 = game:DefineFastFlag("UGCValidateMakeupDecalUVProperties", false)
local getFFlagUGCValidationAllowEngineDefaultPartSurfaces = require(scriptParent.flags.getFFlagUGCValidationAllowEngineDefaultPartSurfaces)
local getFFlagUGCValidateAllowEmissives = require(scriptParent.flags.getFFlagUGCValidateAllowEmissives)

local function convertArrayToTable(p1) -- line: 19
	local t1 = {}

	for _, v in pairs(p1) do
		t1[v] = true
	end

	return t1
end

local t2 = {
	MAX_HAT_TRIANGLES = ValidationRulesUtil:getRules().MeshRules.AccessoryMaxTriangles,
	MAX_TEXTURE_SIZE = ValidationRulesUtil:getRules().TextureRules.MaxTextureSize
}
local t3 = { Enum.Material.Plastic }
local t4 = {}

for _, v in pairs(t3) do
	t4[v] = true
end

t2.MATERIAL_WHITELIST = t4
t2.BANNED_CLASS_NAMES = {
	"Script",
	"LocalScript",
	"ModuleScript",
	"ParticleEmitter",
	"Fire",
	"Smoke",
	"Sparkles"
}
t2.R6_BODY_PARTS = {
	"Torso",
	"Left Leg",
	"Right Leg",
	"Left Arm",
	"Right Arm"
}
t2.R15_BODY_PARTS = {
	"Head",
	"UpperTorso",
	"LowerTorso",
	"LeftUpperLeg",
	"LeftLowerLeg",
	"LeftFoot",
	"RightUpperLeg",
	"RightLowerLeg",
	"RightFoot",
	"LeftUpperArm",
	"LeftLowerArm",
	"LeftHand",
	"RightUpperArm",
	"RightLowerArm",
	"RightHand"
}
t2.R15_CAGE_PARTS = {
	"Head_OuterCage",
	"UpperTorso_OuterCage",
	"LowerTorso_OuterCage",
	"LeftUpperLeg_OuterCage",
	"LeftLowerLeg_OuterCage",
	"LeftFoot_OuterCage",
	"RightUpperLeg_OuterCage",
	"RightLowerLeg_OuterCage",
	"RightFoot_OuterCage",
	"LeftUpperArm_OuterCage",
	"LeftLowerArm_OuterCage",
	"LeftHand_OuterCage",
	"RightUpperArm_OuterCage",
	"RightLowerArm_OuterCage",
	"RightHand_OuterCage"
}
t2.NAMED_R15_BODY_PARTS = {}

for _, v20 in t2.R15_BODY_PARTS do
	t2.NAMED_R15_BODY_PARTS[v20] = v20
end

t2.NAMED_R15_BODY_PARTS.Head = "Head"
setmetatable(t2.NAMED_R15_BODY_PARTS, {
	__index = function() -- line: 108
		error("NAMED_R15_BODY_PARTS key does not exist")

		return nil
	end
})
t2.R15_STANDARD_JOINT_NAMES = {
	Root = true,
	HumanoidRootNode = true,
	DynamicHead = true,
	Head = true,
	UpperTorso = true,
	LowerTorso = true,
	LeftUpperLeg = true,
	LeftLowerLeg = true,
	LeftFoot = true,
	RightUpperLeg = true,
	RightLowerLeg = true,
	RightFoot = true,
	LeftUpperArm = true,
	LeftLowerArm = true,
	LeftHand = true,
	RightUpperArm = true,
	RightLowerArm = true,
	RightHand = true
}
t2.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES = {
	RBX_Leader = true,
	RBX_Follower = true
}

for _, v22 in t2.R15_BODY_PARTS do
	t2.R15_STANDARD_JOINT_NAMES[v22] = true
end

t2.UGC_BODY_PARTS = {
	"Head",
	"UpperTorso",
	"LowerTorso",
	"LeftUpperLeg",
	"LeftLowerLeg",
	"LeftHand",
	"RightUpperArm",
	"RightLowerArm",
	"RightHand",
	"LeftUpperArm",
	"LeftLowerArm",
	"LeftFoot",
	"RightUpperLeg",
	"RightLowerLeg",
	"RightFoot",
	"EyebrowAccessory",
	"EyelashAccessory",
	"HairAccessory"
}
t2.UGC_BODY_PART_NAMES_TO_ASSET_TYPE = {
	Head = Enum.AssetType.DynamicHead,
	UpperTorso = Enum.AssetType.Torso,
	LowerTorso = Enum.AssetType.Torso,
	LeftUpperArm = Enum.AssetType.LeftArm,
	LeftLowerArm = Enum.AssetType.LeftArm,
	LeftHand = Enum.AssetType.LeftArm,
	RightUpperArm = Enum.AssetType.RightArm,
	RightLowerArm = Enum.AssetType.RightArm,
	RightHand = Enum.AssetType.RightArm,
	LeftUpperLeg = Enum.AssetType.LeftLeg,
	LeftLowerLeg = Enum.AssetType.LeftLeg,
	LeftFoot = Enum.AssetType.LeftLeg,
	RightUpperLeg = Enum.AssetType.RightLeg,
	RightLowerLeg = Enum.AssetType.RightLeg,
	RightFoot = Enum.AssetType.RightLeg,
	EyebrowAccessory = Enum.AssetType.EyebrowAccessory,
	EyelashAccessory = Enum.AssetType.EyelashAccessory,
	HairAccessory = Enum.AssetType.HairAccessory
}
t2.UGC_SHOE_NAMES_TO_ASSET_TYPE = {
	LeftShoeAccessory = Enum.AssetType.LeftShoeAccessory,
	RightShoeAccessory = Enum.AssetType.RightShoeAccessory
}
t2.BUNDLE_TO_ASSET_MAPPING = {
	[Enum.BundleType.BodyParts] = t2.UGC_BODY_PART_NAMES_TO_ASSET_TYPE,
	[Enum.BundleType.BodyParts] = t2.UGC_SHOE_NAMES_TO_ASSET_TYPE
}
t2.ASSET_TYPES_THAT_SKIP_FOLDER = {
	Enum.AssetType.DynamicHead,
	Enum.AssetType.EyebrowAccessory,
	Enum.AssetType.EyelashAccessory,
	Enum.AssetType.HairAccessory
}
t2.FOLDER_NAMES = {
	R6 = "R6",
	R15ArtistIntent = "R15ArtistIntent",
	R15Fixed = "R15Fixed"
}
t2.EXTRA_BANNED_NAMES = {
	"Head",
	"HumanoidRootPart",
	"Humanoid"
}

for _, v in ipairs({
	"Body Colors",
	"Shirt Graphic",
	"Shirt",
	"Pants",
	"Health",
	"Animate"
}) do
	table.insert(t2.EXTRA_BANNED_NAMES, v)
end

t2.BANNED_NAMES = {}

for _, v26 in {
	t2.R6_BODY_PARTS,
	t2.R15_BODY_PARTS,
	t2.EXTRA_BANNED_NAMES
} do
	for _, v28 in v26 do
		t2.BANNED_NAMES[v28] = true
	end
end

t2.ASSET_STATUS = {
	UNKNOWN = "Unknown",
	REVIEW_PENDING = "ReviewPending",
	MODERATED = "Moderated"
}
t2.MAKEUP_INFO = ValidationRulesUtil:getMakeupRules()
t2.ASSET_TYPE_INFO = {}
ValidationRulesUtil:getAccessoryRules(t2.ASSET_TYPE_INFO)
t2.FULL_BODY_BOUNDS = ValidationRulesUtil:getFullBodyRulesBounds()
t2.AvatarPartScaleTypes = {
	Classic = true,
	ProportionsSlender = true,
	ProportionsNormal = true
}
ValidationRulesUtil:getBodyPartRules(t2.ASSET_TYPE_INFO)
t2.BODYPART_TO_PARENT = {
	Head = nil,
	LowerTorso = nil,
	UpperTorso = "LowerTorso",
	LeftUpperArm = nil,
	LeftLowerArm = "LeftUpperArm",
	LeftHand = "LeftLowerArm",
	LeftUpperLeg = nil,
	LeftLowerLeg = "LeftUpperLeg",
	RightUpperArm = nil,
	RightLowerArm = "RightUpperArm",
	RightHand = "RightLowerArm",
	RightUpperLeg = nil,
	RightLowerLeg = "RightUpperLeg"
}

if getFFlagUGCValidationFixConstantsTypoLeg() then
	t2.BODYPART_TO_PARENT.RightFoot = "RightLowerLeg"
	t2.BODYPART_TO_PARENT.LeftFoot = "LeftLowerLeg"
else
	t2.BODYPART_TO_PARENT.RightLeg = "RightLowerLeg"
	t2.BODYPART_TO_PARENT.LeftLeg = "LeftLowerLeg"
end

t2.RenderVsWrapMeshMaxDiff = ValidationRulesUtil:getRules().MeshRules.CageMeshMaxDistanceFromRenderMesh
t2.COMPARISON_METHODS = {
	SMALLER = "<",
	SMALLER_EQ = "<=",
	FUZZY_EQ = "=",
	EXACT_EQ = "==",
	GREATER_EQ = ">=",
	GREATER = ">",
	FOUND_IN = "one of the following:"
}
setmetatable(t2.COMPARISON_METHODS, {
	__index = function(_, p3) -- line: 306
		return error("Invalid COMPARISON_METHOD " .. tostring(p3))
	end
})
t2.INCLUSION_METHODS = {
	RUN_ON_ALL = "RUN_ON_ALL",
	INCLUSION_LIST = "INCLUSION_LIST",
	EXCLUSION_LIST = "EXCLUSION_LIST"
}
setmetatable(t2.INCLUSION_METHODS, {
	__index = function(_, p5) -- line: 321
		return error("Invalid INCLUSION_METHOD " .. tostring(p5))
	end
})
t2.PROPERTIES = {
	Instance = {
		Archivable = true
	},
	Attachment = {
		Visible = false
	},
	Decal = {
		Transparency = 0,
		Color3 = Color3.new(1, 1, 1),
		UVOffset = if not v10 then nil else Vector2.new(0, 0),
		UVScale = if not v10 then nil else Vector2.new(1, 1)
	},
	SpecialMesh = {
		Offset = Vector3.new(0, 0, 0),
		VertexColor = Vector3.new(1, 1, 1),
		MeshType = Enum.MeshType.FileMesh
	},
	BasePart = {
		Anchored = false,
		CollisionGroupId = 0,
		CustomPhysicalProperties = Cryo.None,
		Elasticity = 0.5,
		Friction = 0.3,
		LocalTransparencyModifier = 0,
		Massless = false,
		Reflectance = 0,
		RootPriority = 0,
		RotVelocity = Vector3.new(0, 0, 0),
		Velocity = Vector3.new(0, 0, 0),
		BackParamA = -0.5,
		BackParamB = 0.5,
		BackSurfaceInput = Enum.InputType.NoInput,
		BottomParamA = -0.5,
		BottomParamB = 0.5,
		BottomSurfaceInput = Enum.InputType.NoInput,
		FrontParamA = -0.5,
		FrontParamB = 0.5,
		FrontSurfaceInput = Enum.InputType.NoInput,
		LeftParamA = -0.5,
		LeftParamB = 0.5,
		LeftSurfaceInput = Enum.InputType.NoInput,
		RightParamA = -0.5,
		RightParamB = 0.5,
		RightSurfaceInput = Enum.InputType.NoInput,
		TopParamA = -0.5,
		TopParamB = 0.5,
		TopSurfaceInput = Enum.InputType.NoInput,
		BackSurface = Enum.SurfaceType.Smooth,
		BottomSurface = if not getFFlagUGCValidationAllowEngineDefaultPartSurfaces() then Enum.SurfaceType.Smooth else {
			[t2.COMPARISON_METHODS.FOUND_IN] = {
				Enum.SurfaceType.Smooth,
				Enum.SurfaceType.Inlet
			}
		},
		FrontSurface = Enum.SurfaceType.Smooth,
		LeftSurface = Enum.SurfaceType.Smooth,
		RightSurface = Enum.SurfaceType.Smooth,
		TopSurface = if not getFFlagUGCValidationAllowEngineDefaultPartSurfaces() then Enum.SurfaceType.Smooth else {
			[t2.COMPARISON_METHODS.FOUND_IN] = {
				Enum.SurfaceType.Smooth,
				Enum.SurfaceType.Studs
			}
		},
		Transparency = {
			[t2.COMPARISON_METHODS.EXACT_EQ] = 0
		},
		Color = {
			[t2.COMPARISON_METHODS.FUZZY_EQ] = BrickColor.new("Medium stone grey").Color,
			[t2.INCLUSION_METHODS.EXCLUSION_LIST] = {
				Enum.AssetType.DynamicHead,
				Enum.AssetType.Torso,
				Enum.AssetType.LeftArm,
				Enum.AssetType.RightArm,
				Enum.AssetType.LeftLeg,
				Enum.AssetType.RightLeg
			}
		}
	},
	Part = {
		Shape = Enum.PartType.Block
	},
	SurfaceAppearance = {
		AlphaMode = if not getFFlagUGCValidationEyebrowEyelashSupport() then Enum.AlphaMode.Overlay else {
			{
				[t2.COMPARISON_METHODS.FOUND_IN] = {
					Enum.AlphaMode.Overlay,
					Enum.AlphaMode.Transparency
				},
				[t2.INCLUSION_METHODS.INCLUSION_LIST] = {
					Enum.AssetType.EyelashAccessory,
					Enum.AssetType.EyebrowAccessory
				}
			},
			{
				[t2.COMPARISON_METHODS.EXACT_EQ] = Enum.AlphaMode.Overlay,
				[t2.INCLUSION_METHODS.EXCLUSION_LIST] = {
					Enum.AssetType.EyelashAccessory,
					Enum.AssetType.EyebrowAccessory
				}
			}
		},
		EmissiveMaskContent = if not getFFlagUGCValidateAllowEmissives() then Content.none else nil,
		EmissiveStrength = not getFFlagUGCValidateAllowEmissives() and 1 or {
			[t2.COMPARISON_METHODS.GREATER_EQ] = 0,
			[t2.COMPARISON_METHODS.SMALLER_EQ] = 40
		},
		EmissiveTint = if not getFFlagUGCValidateAllowEmissives() then Color3.new(1, 1, 1) else nil
	},
	WrapLayer = {
		Enabled = true,
		CageOrigin = {
			PositionMagnitude = {
				[t2.COMPARISON_METHODS.SMALLER_EQ] = 10
			},
			Orientation = {
				[t2.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0)
			}
		},
		ReferenceOrigin = {
			PositionMagnitude = {
				[t2.COMPARISON_METHODS.SMALLER_EQ] = 10
			},
			Orientation = {
				[t2.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0)
			}
		},
		ImportOrigin = {
			PositionMagnitude = {
				[t2.COMPARISON_METHODS.SMALLER_EQ] = 8
			}
		},
		BindOffset = {
			Position = {
				[t2.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0)
			},
			Orientation = {
				[t2.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0)
			}
		}
	},
	WrapTarget = {
		CageOrigin = {
			PositionMagnitude = {
				[t2.COMPARISON_METHODS.SMALLER_EQ] = 10
			},
			Orientation = {
				[t2.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0)
			}
		},
		ImportOrigin = {
			PositionMagnitude = {
				[t2.COMPARISON_METHODS.SMALLER_EQ] = 8
			}
		}
	}
}
t2.CONTENT_ID_FIELDS = {
	SpecialMesh = {
		"MeshId",
		"TextureId"
	},
	MeshPart = {
		"MeshId",
		"TextureID"
	},
	SurfaceAppearance = {
		"ColorMap",
		"MetalnessMap",
		"NormalMap",
		"RoughnessMap"
	},
	Decal = {
		"ColorMap",
		"MetalnessMap",
		"NormalMap",
		"RoughnessMap"
	},
	WrapLayer = {
		"CageMeshId",
		"ReferenceMeshId"
	},
	WrapTarget = { "CageMeshId" },
	Animation = { "AnimationId" }
}
t2.CONTENT_FIELDS_WITHOUT_CONTENTID = {
	SurfaceAppearance = { "EmissiveMaskContent" }
}

if getFFlagUGCValidateCheckTexturePackOwner() then
	table.insert(t2.CONTENT_ID_FIELDS.SurfaceAppearance, "TexturePack")
end

if getFFlagUGCValidateCheckHSROwner() then
	table.insert(t2.CONTENT_ID_FIELDS.WrapLayer, "HSRAssetId")
end

t2.CONTENT_ID_REQUIRED_FIELDS = {
	SpecialMesh = {
		MeshId = true,
		TextureId = true
	},
	MeshPart = {
		MeshId = true
	},
	WrapTarget = {
		CageMeshId = true
	},
	Animation = {
		AnimationId = true
	}
}
t2.CONTENT_ID_EDITABLE_PROPERTY = {
	MeshPart = {
		MeshId = "MeshContent",
		TextureID = "TextureContent"
	},
	WrapTarget = {
		CageMeshId = "CageMeshContent"
	},
	WrapLayer = {
		CageMeshId = "CageMeshContent",
		ReferenceMeshId = "ReferenceMeshContent"
	},
	SurfaceAppearance = {
		ColorMap = "ColorMapContent",
		MetalnessMap = "MetalnessMapContent",
		NormalMap = "NormalMapContent",
		RoughnessMap = "RoughnessMapContent"
	}
}
t2.MESH_CONTENT_ID_FIELDS = {
	SpecialMesh = { "MeshId" },
	MeshPart = { "MeshId" },
	WrapTarget = { "CageMeshId" },
	WrapLayer = {
		"CageMeshId",
		"ReferenceMeshId"
	}
}
t2.TEXTURE_CONTENT_ID_FIELDS = {
	SpecialMesh = { "TextureId" },
	MeshPart = { "TextureID" },
	SurfaceAppearance = {
		"ColorMap",
		"MetalnessMap",
		"NormalMap",
		"RoughnessMap"
	},
	Decal = {
		"ColorMap",
		"MetalnessMap",
		"NormalMap",
		"RoughnessMap"
	}
}
t2.ASSET_RENDER_MESH_MAX_TRIANGLES = {
	DynamicHead = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.DynamicHead),
	LeftArm = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.LeftArm),
	RightArm = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.RightArm),
	Torso = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.Torso),
	LeftLeg = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.LeftLeg),
	RightLeg = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.RightLeg)
}
t2.WRAP_TARGET_CAGE_MESH_UV_COUNTS = {
	Head = 343,
	LeftUpperArm = 77,
	LeftLowerArm = 77,
	LeftHand = 86,
	RightUpperArm = 77,
	RightLowerArm = 77,
	RightHand = 86,
	UpperTorso = 257,
	LowerTorso = 105,
	LeftUpperLeg = 88,
	LeftLowerLeg = 88,
	LeftFoot = 86,
	RightUpperLeg = 88,
	RightLowerLeg = 88,
	RightFoot = 86
}
t2.PACKAGE_CONTENT_ID_FIELDS = Cryo.Dictionary.join(t2.CONTENT_ID_FIELDS, {
	Sound = { "SoundId" },
	Decal = { "Texture" },
	VideoFrame = { "Video" },
	PackageLink = { "PackageId" },
	CharacterMesh = {
		"baseTextureAssetId",
		"overlayTextureAssetId",
		"meshAssetId"
	},
	Tool = { "TextureId" },
	Sky = {
		"SkyUp",
		"SkyLf",
		"SkyRt",
		"SkyBk",
		"SkyFt",
		"SkyDn",
		"Sun",
		"Moon"
	},
	Trail = { "texture" },
	Beam = { "texture" },
	ShirtGraphic = { "Graphic" },
	Shirt = { "ShirtTemplate" },
	Pants = { "PantsTemplate" },
	AdGui = { "FallbackImage" }
})
t2.ExperienceAuthHeaderKey = "RBX-ExperienceAuthorization"
t2.ContentType = "Content-Type"
t2.ApplicationJson = "application/json"
t2.GUIDAttributeName = "RBXGUID"
t2.GUIDAttributeMaxLength = 100
t2.AlternateMeshIdAttributeName = "RBX_ALT_MESH_ID"
t2.MESH_CONTENT_TYPE = {
	RENDER_MESH = "RenderMesh",
	OUTER_CAGE = "OuterCage",
	INNER_CAGE = "InnerCage"
}
t2.MESH_CONTENT_TYPE_TO_FIELD_NAME = {
	[t2.MESH_CONTENT_TYPE.RENDER_MESH] = "MeshId",
	[t2.MESH_CONTENT_TYPE.OUTER_CAGE] = "CageMeshId",
	[t2.MESH_CONTENT_TYPE.INNER_CAGE] = "ReferenceMeshId"
}

if getFFlagUGCValidationAnimationPackSupport() then
	t2.ANIMATION_ASSET_INFO = {
		[Enum.AssetType.ClimbAnimation] = {
			modelName = "ClimbAnimation",
			stringValueNames = { "climb" }
		},
		[Enum.AssetType.FallAnimation] = {
			modelName = "FallAnimation",
			stringValueNames = { "fall" }
		},
		[Enum.AssetType.IdleAnimation] = {
			modelName = "IdleAnimation",
			stringValueNames = { "idle" }
		},
		[Enum.AssetType.JumpAnimation] = {
			modelName = "JumpAnimation",
			stringValueNames = { "jump" }
		},
		[Enum.AssetType.RunAnimation] = {
			modelName = "RunAnimation",
			stringValueNames = { "run" }
		},
		[Enum.AssetType.SwimAnimation] = {
			modelName = "SwimAnimation",
			stringValueNames = {
				"swim",
				"swimidle"
			}
		},
		[Enum.AssetType.WalkAnimation] = {
			modelName = "WalkAnimation",
			stringValueNames = { "walk" }
		}
	}
end

t2.AllAssetUploadCategories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD,
	ValidationEnums.UploadCategory.LAYERED_CLOTHING,
	ValidationEnums.UploadCategory.RIGID_ACCESSORY,
	ValidationEnums.UploadCategory.EMOTE_ANIMATION
}

if getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t2.AllAssetUploadCategories, ValidationEnums.UploadCategory.ANIMATION)
end

t2.AllAssetUploadCategoriesIncludingMakeup = {}

for _, v30 in t2.AllAssetUploadCategories do
	table.insert(t2.AllAssetUploadCategoriesIncludingMakeup, v30)
end

table.insert(t2.AllAssetUploadCategoriesIncludingMakeup, ValidationEnums.UploadCategory.MAKEUP)
t2.AllBundleUploadCategories = {
	ValidationEnums.UploadCategory.FULL_BODY,
	ValidationEnums.UploadCategory.BOTH_SHOES
}

if getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t2.AllBundleUploadCategories, ValidationEnums.UploadCategory.ANIMATION_PACK)
end

t2.AllUploadCategories = {}

for _, v32 in ValidationEnums.UploadCategory do
	table.insert(t2.AllUploadCategories, v32)
end

t2.AssetUploadsWithFolderStructure = {
	[Enum.AssetType.Torso] = true,
	[Enum.AssetType.LeftArm] = true,
	[Enum.AssetType.RightArm] = true,
	[Enum.AssetType.LeftLeg] = true,
	[Enum.AssetType.RightLeg] = true
}
t2.SkinningTransferRequiredTypes = {
	[Enum.AssetType.EyebrowAccessory] = true,
	[Enum.AssetType.EyelashAccessory] = true
}

return t2
