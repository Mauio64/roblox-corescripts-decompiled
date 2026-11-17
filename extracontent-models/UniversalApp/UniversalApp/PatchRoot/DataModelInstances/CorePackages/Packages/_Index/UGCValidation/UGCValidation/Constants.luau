local parent = script.Parent

local Cryo = require(parent.Parent.Cryo)

local ValidationRulesUtil = require(parent.util.ValidationRulesUtil)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local getFFlagUGCValidationEyebrowEyelashSupport = require(parent.flags.getFFlagUGCValidationEyebrowEyelashSupport)
local getFFlagUGCValidateCheckHSROwner = require(parent.flags.getFFlagUGCValidateCheckHSROwner)
local getFFlagUGCValidateCheckTexturePackOwner = require(parent.flags.getFFlagUGCValidateCheckTexturePackOwner)
local defineFastFlag = game:DefineFastFlag("UGCValidateMakeupDecalUVProperties", false)
local getFFlagUGCValidateMakeupCategoryParity = require(parent.flags.getFFlagUGCValidateMakeupCategoryParity)
local getFFlagUGCValidateDisallowAeroMeshData = require(parent.flags.getFFlagUGCValidateDisallowAeroMeshData)

local getFFlagUGCValidateWrapLayerDeformationMapsEmpty = require(parent.flags.getFFlagUGCValidateWrapLayerDeformationMapsEmpty)
local engineHasWrapLayerDeformationMaps = require(parent.util.engineHasWrapLayerDeformationMaps)

local function convertArrayToTable(items) -- 1 equivalent call inferred from this helper
	local result = {}

	for _, item in pairs(items) do
		result[item] = true
	end

	return result
end

local Constants = {}

Constants.MAX_HAT_TRIANGLES = ValidationRulesUtil:getRules().MeshRules.AccessoryMaxTriangles

Constants.MAX_TEXTURE_SIZE = ValidationRulesUtil:getRules().TextureRules.MaxTextureSize

Constants.MATERIAL_WHITELIST = convertArrayToTable({ Enum.Material.Plastic }) -- inferred equivalent call

Constants.BANNED_CLASS_NAMES = {
	"Script",
	"LocalScript",
	"ModuleScript",
	"ParticleEmitter",
	"Fire",
	"Smoke",
	"Sparkles"
}

Constants.R6_BODY_PARTS = { "Torso", "Left Leg", "Right Leg", "Left Arm", "Right Arm" }

Constants.R15_BODY_PARTS = {
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

Constants.R15_CAGE_PARTS = {
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

Constants.NAMED_R15_BODY_PARTS = {}

for _, v in Constants.R15_BODY_PARTS do
	Constants.NAMED_R15_BODY_PARTS[v] = v
end

Constants.NAMED_R15_BODY_PARTS.Head = "Head"

setmetatable(Constants.NAMED_R15_BODY_PARTS, {
	__index = function(): nil
		error("NAMED_R15_BODY_PARTS key does not exist")
		return nil
	end
})

Constants.R15_STANDARD_JOINT_NAMES = {
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

Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES = { RBX_Leader = true, RBX_Follower = true }

for _, v in Constants.R15_BODY_PARTS do
	Constants.R15_STANDARD_JOINT_NAMES[v] = true
end

Constants.UGC_BODY_PARTS = {
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

Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE = {
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

Constants.UGC_SHOE_NAMES_TO_ASSET_TYPE = {
	LeftShoeAccessory = Enum.AssetType.LeftShoeAccessory,
	RightShoeAccessory = Enum.AssetType.RightShoeAccessory
}

Constants.BUNDLE_TO_ASSET_MAPPING = {
	[Enum.BundleType.BodyParts] = Constants.UGC_BODY_PART_NAMES_TO_ASSET_TYPE,
	[Enum.BundleType.BodyParts] = Constants.UGC_SHOE_NAMES_TO_ASSET_TYPE
}

Constants.ASSET_TYPES_THAT_SKIP_FOLDER = {
	Enum.AssetType.DynamicHead,
	Enum.AssetType.EyebrowAccessory,
	Enum.AssetType.EyelashAccessory,
	Enum.AssetType.HairAccessory
}

Constants.FOLDER_NAMES = { R6 = "R6", R15ArtistIntent = "R15ArtistIntent", R15Fixed = "R15Fixed" }

Constants.EXTRA_BANNED_NAMES = { "Head", "HumanoidRootPart", "Humanoid" }

for _, v in ipairs({ "Body Colors", "Shirt Graphic", "Shirt", "Pants", "Health", "Animate" }) do
	table.insert(Constants.EXTRA_BANNED_NAMES, v)
end

Constants.BANNED_NAMES = {}

for _, v in { Constants.R6_BODY_PARTS, Constants.R15_BODY_PARTS, Constants.EXTRA_BANNED_NAMES } do
	for _, v2 in v do
		Constants.BANNED_NAMES[v2] = true
	end
end

Constants.ASSET_STATUS = {
	UNKNOWN = "Unknown",
	REVIEW_PENDING = "ReviewPending",
	MODERATED = "Moderated"
}

Constants.MAKEUP_INFO = ValidationRulesUtil:getMakeupRules()

Constants.ASSET_TYPE_INFO = {}
ValidationRulesUtil:getAccessoryRules(Constants.ASSET_TYPE_INFO)

Constants.FULL_BODY_BOUNDS = ValidationRulesUtil:getFullBodyRulesBounds()

Constants.AvatarPartScaleTypes = {
	Classic = true,
	ProportionsSlender = true,
	ProportionsNormal = true
}

ValidationRulesUtil:getBodyPartRules(Constants.ASSET_TYPE_INFO)

Constants.BODYPART_TO_PARENT = {
	["Head"] = nil,
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

Constants.BODYPART_TO_PARENT.RightFoot = "RightLowerLeg"
Constants.BODYPART_TO_PARENT.LeftFoot = "LeftLowerLeg"

Constants.RenderVsWrapMeshMaxDiff = ValidationRulesUtil:getRules().MeshRules.CageMeshMaxDistanceFromRenderMesh

Constants.COMPARISON_METHODS = {
	SMALLER = "<",
	SMALLER_EQ = "<=",
	FUZZY_EQ = "=",
	EXACT_EQ = "==",
	GREATER_EQ = ">=",
	GREATER = ">",
	FOUND_IN = "one of the following:"
}

setmetatable(Constants.COMPARISON_METHODS, {
	__index = function(_, p)
		return error("Invalid COMPARISON_METHOD " .. tostring(p))
	end
})

Constants.INCLUSION_METHODS = {
	RUN_ON_ALL = "RUN_ON_ALL",
	INCLUSION_LIST = "INCLUSION_LIST",
	EXCLUSION_LIST = "EXCLUSION_LIST"
}

setmetatable(Constants.INCLUSION_METHODS, {
	__index = function(_, p)
		return error("Invalid INCLUSION_METHOD " .. tostring(p))
	end
})

local v = getFFlagUGCValidateWrapLayerDeformationMapsEmpty() and engineHasWrapLayerDeformationMaps()

local decal = { Color3 = Color3.new(1, 1, 1), Transparency = 0, UVOffset = 0, UVScale = 0 }
local uvOffset

if defineFastFlag then
	uvOffset = Vector2.new(0, 0)
end

decal.UVOffset = uvOffset
local uvScale

if defineFastFlag then
	uvScale = Vector2.new(1, 1)
end

decal.UVScale = uvScale
local properties = {
	Instance = { Archivable = true },
	Attachment = { Visible = false },
	Decal = decal,
	SpecialMesh = {
		MeshType = Enum.MeshType.FileMesh,
		Offset = Vector3.new(0, 0, 0),
		VertexColor = Vector3.new(1, 1, 1)
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
		BottomSurface = {
			[Constants.COMPARISON_METHODS.FOUND_IN] = { Enum.SurfaceType.Smooth, Enum.SurfaceType.Inlet }
		},
		FrontSurface = Enum.SurfaceType.Smooth,
		LeftSurface = Enum.SurfaceType.Smooth,
		RightSurface = Enum.SurfaceType.Smooth,
		TopSurface = {
			[Constants.COMPARISON_METHODS.FOUND_IN] = { Enum.SurfaceType.Smooth, Enum.SurfaceType.Studs }
		},
		Transparency = { [Constants.COMPARISON_METHODS.EXACT_EQ] = 0 },
		Color = {
			[Constants.COMPARISON_METHODS.FUZZY_EQ] = BrickColor.new("Medium stone grey").Color,
			[Constants.INCLUSION_METHODS.EXCLUSION_LIST] = {
				Enum.AssetType.DynamicHead,
				Enum.AssetType.Torso,
				Enum.AssetType.LeftArm,
				Enum.AssetType.RightArm,
				Enum.AssetType.LeftLeg,
				Enum.AssetType.RightLeg
			}
		}
	},
	Part = { Shape = Enum.PartType.Block },
	MeshPart = 0,
	SurfaceAppearance = 0,
	WrapLayer = 0,
	WrapTarget = 0
}
local fluidFidelity

if getFFlagUGCValidateDisallowAeroMeshData() then
	fluidFidelity = Enum.FluidFidelity.Automatic
end

properties.MeshPart = { FluidFidelity = fluidFidelity }
local alphaMode

if getFFlagUGCValidationEyebrowEyelashSupport() then
	alphaMode = {
		{
			[Constants.COMPARISON_METHODS.FOUND_IN] = { Enum.AlphaMode.Overlay, Enum.AlphaMode.Transparency },
			[Constants.INCLUSION_METHODS.INCLUSION_LIST] = {
				Enum.AssetType.EyelashAccessory,
				Enum.AssetType.EyebrowAccessory
			}
		},
		{
			[Constants.COMPARISON_METHODS.EXACT_EQ] = Enum.AlphaMode.Overlay,
			[Constants.INCLUSION_METHODS.EXCLUSION_LIST] = {
				Enum.AssetType.EyelashAccessory,
				Enum.AssetType.EyebrowAccessory
			}
		}
	}
else
	alphaMode = Enum.AlphaMode.Overlay
end

properties.SurfaceAppearance = {
	AlphaMode = alphaMode,
	EmissiveStrength = {
		[Constants.COMPARISON_METHODS.GREATER_EQ] = 0,
		[Constants.COMPARISON_METHODS.SMALLER_EQ] = 40
	}
}

local wrapLayer = {
	Enabled = true,
	CageOrigin = {
		PositionMagnitude = { [Constants.COMPARISON_METHODS.SMALLER_EQ] = 10 },
		Orientation = { [Constants.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0) }
	},
	ReferenceOrigin = {
		PositionMagnitude = { [Constants.COMPARISON_METHODS.SMALLER_EQ] = 10 },
		Orientation = { [Constants.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0) }
	},
	ImportOrigin = {
		PositionMagnitude = { [Constants.COMPARISON_METHODS.SMALLER_EQ] = 8 }
	},
	BindOffset = {
		Position = { [Constants.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0) },
		Orientation = { [Constants.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0) }
	},
	RotateScaleDeformationMap = 0,
	ScaleOnlyDeformationMap = 0
}
local rotateScaleDeformationMap

if v then
	rotateScaleDeformationMap = Content.none
end

wrapLayer.RotateScaleDeformationMap = rotateScaleDeformationMap
local scaleOnlyDeformationMap

if v then
	scaleOnlyDeformationMap = Content.none
end

wrapLayer.ScaleOnlyDeformationMap = scaleOnlyDeformationMap
properties.WrapLayer = wrapLayer

properties.WrapTarget = {
	CageOrigin = {
		PositionMagnitude = { [Constants.COMPARISON_METHODS.SMALLER_EQ] = 10 },
		Orientation = { [Constants.COMPARISON_METHODS.EXACT_EQ] = Vector3.new(0, 0, 0) }
	},
	ImportOrigin = {
		PositionMagnitude = { [Constants.COMPARISON_METHODS.SMALLER_EQ] = 8 }
	}
}
Constants.PROPERTIES = properties

Constants.CONTENT_ID_FIELDS = {
	SpecialMesh = { "MeshId", "TextureId" },
	MeshPart = { "MeshId", "TextureID" },
	SurfaceAppearance = { "ColorMap", "MetalnessMap", "NormalMap", "RoughnessMap" },
	Decal = { "ColorMap", "MetalnessMap", "NormalMap", "RoughnessMap" },
	WrapLayer = { "CageMeshId", "ReferenceMeshId" },
	WrapTarget = { "CageMeshId" },
	Animation = { "AnimationId" }
}

Constants.CONTENT_FIELDS_WITHOUT_CONTENTID = {
	SurfaceAppearance = { "EmissiveMaskContent" }
}

if getFFlagUGCValidateCheckTexturePackOwner() then
	table.insert(Constants.CONTENT_ID_FIELDS.SurfaceAppearance, "TexturePack")
end

if getFFlagUGCValidateCheckHSROwner() then
	table.insert(Constants.CONTENT_ID_FIELDS.WrapLayer, "HSRAssetId")
end

Constants.CONTENT_ID_REQUIRED_FIELDS = {
	SpecialMesh = { MeshId = true, TextureId = true },
	MeshPart = { MeshId = true },
	WrapTarget = { CageMeshId = true },
	Animation = { AnimationId = true }
}

Constants.CONTENT_ID_EDITABLE_PROPERTY = {
	MeshPart = { MeshId = "MeshContent", TextureID = "TextureContent" },
	WrapTarget = { CageMeshId = "CageMeshContent" },
	WrapLayer = { CageMeshId = "CageMeshContent", ReferenceMeshId = "ReferenceMeshContent" },
	SurfaceAppearance = {
		ColorMap = "ColorMapContent",
		MetalnessMap = "MetalnessMapContent",
		NormalMap = "NormalMapContent",
		RoughnessMap = "RoughnessMapContent"
	}
}

Constants.CONTENT_TYPED_PROPERTIES_BY_CLASS = {
	MeshPart = { "MeshContent", "TextureContent" },
	WrapTarget = { "CageMeshContent" },
	WrapLayer = { "CageMeshContent", "ReferenceMeshContent" },
	SurfaceAppearance = {
		"ColorMapContent",
		"MetalnessMapContent",
		"NormalMapContent",
		"RoughnessMapContent",
		"EmissiveMaskContent"
	},
	Decal = { "ColorMapContent", "MetalnessMapContent", "NormalMapContent", "RoughnessMapContent" },
	WrapTextureTransfer = { "ReferenceCageMeshContent" }
}

Constants.MESH_CONTENT_ID_FIELDS = {
	SpecialMesh = { "MeshId" },
	MeshPart = { "MeshId" },
	WrapTarget = { "CageMeshId" },
	WrapLayer = { "CageMeshId", "ReferenceMeshId" }
}

Constants.TEXTURE_CONTENT_ID_FIELDS = {
	SpecialMesh = { "TextureId" },
	MeshPart = { "TextureID" },
	SurfaceAppearance = { "ColorMap", "MetalnessMap", "NormalMap", "RoughnessMap" },
	Decal = { "ColorMap", "MetalnessMap", "NormalMap", "RoughnessMap" }
}

Constants.ASSET_RENDER_MESH_MAX_TRIANGLES = {
	DynamicHead = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.DynamicHead),
	LeftArm = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.LeftArm),
	RightArm = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.RightArm),
	Torso = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.Torso),
	LeftLeg = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.LeftLeg),
	RightLeg = ValidationRulesUtil:getBodyPartMaxTrianglesRule(Enum.AssetType.RightLeg)
}

Constants.WRAP_TARGET_CAGE_MESH_UV_COUNTS = {
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

Constants.PACKAGE_CONTENT_ID_FIELDS = Cryo.Dictionary.join(Constants.CONTENT_ID_FIELDS, {
	Sound = { "SoundId" },
	Decal = { "Texture" },
	VideoFrame = { "Video" },
	PackageLink = { "PackageId" },
	CharacterMesh = { "baseTextureAssetId", "overlayTextureAssetId", "meshAssetId" },
	Tool = { "TextureId" },
	Sky = { "SkyUp", "SkyLf", "SkyRt", "SkyBk", "SkyFt", "SkyDn", "Sun", "Moon" },
	Trail = { "texture" },
	Beam = { "texture" },
	ShirtGraphic = { "Graphic" },
	Shirt = { "ShirtTemplate" },
	Pants = { "PantsTemplate" },
	AdGui = { "FallbackImage" }
})

Constants.ExperienceAuthHeaderKey = "RBX-ExperienceAuthorization"
Constants.ContentType = "Content-Type"
Constants.ApplicationJson = "application/json"

Constants.GUIDAttributeName = "RBXGUID"
Constants.GUIDAttributeMaxLength = 100

Constants.EmoteIsUGCAttributeName = "RBXisUGCEmote"
Constants.EmoteMaxPartTranslationAttributeName = "RBXmaxPartTranslation"

Constants.AlternateMeshIdAttributeName = "RBX_ALT_MESH_ID"
Constants.MESH_CONTENT_TYPE = {
	RENDER_MESH = "RenderMesh",
	OUTER_CAGE = "OuterCage",
	INNER_CAGE = "InnerCage"
}

Constants.MESH_CONTENT_TYPE_TO_FIELD_NAME = {
	[Constants.MESH_CONTENT_TYPE.RENDER_MESH] = "MeshId",
	[Constants.MESH_CONTENT_TYPE.OUTER_CAGE] = "CageMeshId",
	[Constants.MESH_CONTENT_TYPE.INNER_CAGE] = "ReferenceMeshId"
}

Constants.ANIMATION_ASSET_INFO = {
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
		stringValueNames = { "swim", "swimidle" }
	},
	[Enum.AssetType.WalkAnimation] = {
		modelName = "WalkAnimation",
		stringValueNames = { "walk" }
	}
}

Constants.AllAssetUploadCategories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD,
	ValidationEnums.UploadCategory.LAYERED_CLOTHING,
	ValidationEnums.UploadCategory.EYEBROW_EYELASH,
	ValidationEnums.UploadCategory.RIGID_ACCESSORY,
	ValidationEnums.UploadCategory.EMOTE_ANIMATION
}

table.insert(Constants.AllAssetUploadCategories, ValidationEnums.UploadCategory.ANIMATION)

Constants.AllAssetUploadCategoriesIncludingMakeup = {}

for _, allAssetUploadCategory in Constants.AllAssetUploadCategories do
	table.insert(Constants.AllAssetUploadCategoriesIncludingMakeup, allAssetUploadCategory)
end

table.insert(Constants.AllAssetUploadCategoriesIncludingMakeup, ValidationEnums.UploadCategory.MAKEUP)

if getFFlagUGCValidateMakeupCategoryParity() then
	table.insert(Constants.AllAssetUploadCategories, ValidationEnums.UploadCategory.MAKEUP)
end

Constants.AllBundleUploadCategories = {
	ValidationEnums.UploadCategory.FULL_BODY,
	ValidationEnums.UploadCategory.BOTH_SHOES
}

table.insert(Constants.AllBundleUploadCategories, ValidationEnums.UploadCategory.ANIMATION_PACK)

Constants.AllUploadCategories = {}

for _, v2 in ValidationEnums.UploadCategory do
	table.insert(Constants.AllUploadCategories, v2)
end

local set = {
	[Enum.AssetType.Torso] = true,
	[Enum.AssetType.LeftArm] = true,
	[Enum.AssetType.RightArm] = true,
	[Enum.AssetType.LeftLeg] = true,
	[Enum.AssetType.RightLeg] = true
}
Constants.AssetUploadsWithFolderStructure = set

local set2 = { [Enum.AssetType.EyebrowAccessory] = true, [Enum.AssetType.EyelashAccessory] = true }
Constants.SkinningTransferRequiredTypes = set2

return Constants
