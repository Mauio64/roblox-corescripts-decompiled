local parent = script.Parent.Parent

local AssetCalculator = require(parent.util.AssetCalculator)
local R15plusUtils = require(parent.util.R15plusUtils)

local v = {
	"ChinRaiserUpperLip",
	"ChinRaiser",
	"FlatPucker",
	"Funneler",
	"LowerLipSuck",
	"LipPresser",
	"LipsTogether",
	"MouthLeft",
	"MouthRight",
	"Pucker",
	"UpperLipSuck",
	"LeftCheekPuff",
	"LeftDimpler",
	"LeftLipCornerDown",
	"LeftLowerLipDepressor",
	"LeftLipCornerPuller",
	"LeftLipStretcher",
	"LeftUpperLipRaiser",
	"RightCheekPuff",
	"RightDimpler",
	"RightLipCornerDown",
	"RightLowerLipDepressor",
	"RightLipCornerPuller",
	"RightLipStretcher",
	"RightUpperLipRaiser",
	"JawDrop",
	"JawLeft",
	"JawRight",
	"Corrugator",
	"LeftBrowLowerer",
	"LeftOuterBrowRaiser",
	"LeftNoseWrinkler",
	"LeftInnerBrowRaiser",
	"RightBrowLowerer",
	"RightOuterBrowRaiser",
	"RightInnerBrowRaiser",
	"RightNoseWrinkler",
	"EyesLookDown",
	"EyesLookLeft",
	"EyesLookUp",
	"EyesLookRight",
	"LeftCheekRaiser",
	"LeftEyeUpperLidRaiser",
	"LeftEyeClosed",
	"RightCheekRaiser",
	"RightEyeUpperLidRaiser",
	"RightEyeClosed",
	"TongueDown",
	"TongueOut",
	"TongueUp"
}

local v2 = {
	Head = { "Spine", "Chest" },
	LeftUpperArm = { "Spine", "Chest", "LeftClavicle" },
	RightUpperArm = { "Spine", "Chest", "RightClavicle" }
}

local function buildPositionCurveSchema()
	return {
		ClassName = "Vector3Curve",
		Name = "Position",
		_optional = true,
		_children = {
			{ ClassName = "FloatCurve", Name = "X", _optional = true },
			{ ClassName = "FloatCurve", Name = "Y", _optional = true },
			{ ClassName = "FloatCurve", Name = "Z", _optional = true }
		}
	}
end

local function buildRotationCurveSchema()
	return {
		ClassName = "EulerRotationCurve",
		Name = "Rotation",
		_optional = true,
		_children = {
			{ ClassName = "FloatCurve", Name = "X", _optional = true },
			{ ClassName = "FloatCurve", Name = "Y", _optional = true },
			{ ClassName = "FloatCurve", Name = "Z", _optional = true }
		}
	}
end

local function buildFaceControlsSchema()
	local children = {}

	for _, name in v do
		table.insert(children, { ClassName = "FloatCurve", Name = name, _optional = true })
	end

	return { ClassName = "Folder", Name = "FaceControls", _optional = true, _children = children }
end

local function convertBoneSchemaToChildren(avatarBoneSchema, p)
	local result = {}

	for k, item in avatarBoneSchema do
		if item.ClassName ~= "Bone" then
			continue
		end

		local children = {}

		table.insert(children, buildPositionCurveSchema())
		table.insert(children, buildRotationCurveSchema())

		if item._children then
			local v3 = convertBoneSchemaToChildren(item._children, p)

			for _, v4 in v3 do
				table.insert(children, v4)
			end
		end

		if p and p[k] then
			for _, v3 in p[k] do
				table.insert(children, v3)
			end
		end

		table.insert(result, {
			ClassName = "Folder",
			Name = k,
			_optional = true,
			_children = children
		})
	end

	return result
end

local function fn(name: string, items)
	local children = {}

	table.insert(children, buildPositionCurveSchema())
	table.insert(children, buildRotationCurveSchema())

	local bodyPartsToParents = AssetCalculator.getBodyPartsToParents()
	local v3 = {}

	for _, item in items do
		local v4 = {}

		for k, bodyPartsToParent in bodyPartsToParents do
			if bodyPartsToParent == item then
				table.insert(v4, k)
			end
		end

		v3[item] = fn(item, v4)
	end

	for _, item in items do
		table.insert(children, v3[item])
	end

	local avatarBoneSchema = R15plusUtils.getAvatarBoneSchema(name)

	if next(avatarBoneSchema) ~= nil then
		local v4 = {}

		if name == "UpperTorso" then
			for k, v5 in v2 do
				if not v3[k] then
					continue
				end

				for _, v6 in v5 do
					if not v4[v6] then
						v4[v6] = {}
					end

					table.insert(v4[v6], v3[k])
				end
			end
		end

		local v5 = convertBoneSchemaToChildren(avatarBoneSchema, v4)

		for _, v6 in v5 do
			table.insert(children, v6)
		end
	end

	if name == "Head" then
		table.insert(children, buildFaceControlsSchema())
	end

	return { ClassName = "Folder", Name = name, _optional = true, _children = children }
end

local function buildSchema()
	local bodyPartsToParents = AssetCalculator.getBodyPartsToParents()

	local v3 = {}

	for k, bodyPartsToParent in bodyPartsToParents do
		if bodyPartsToParent == "LowerTorso" then
			table.insert(v3, k)
		end
	end

	return {
		ClassName = "CurveAnimation",
		_children = {
			{ ClassName = "AnimationRigData" },
			{ ClassName = "MarkerCurve", _optional = true },
			{
				ClassName = "Folder",
				Name = "HumanoidRootPart",
				_children = { (fn("LowerTorso", v3)) }
			}
		}
	}
end

return buildSchema()
