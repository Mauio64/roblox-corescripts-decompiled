local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local util = ParentParent.util

require(util.Types)

local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local AssetCalculator = require(util.AssetCalculator)
local validation = ParentParent.validation
local validateAttributes = require(validation.validateAttributes)
local validateTags = require(validation.validateTags)
local ValidatePropertiesSensible = require(validation.ValidatePropertiesSensible)
local flags = ParentParent.flags
local GetFStringUGCValidationMaxAnimationLength = require(flags.GetFStringUGCValidationMaxAnimationLength)
local GetFStringUGCValidationMaxAnimationBounds = require(flags.GetFStringUGCValidationMaxAnimationBounds)
local GetFStringUGCValidationMaxAnimationDeltas = require(flags.GetFStringUGCValidationMaxAnimationDeltas)
local getFFlagUGCValidateAddObjectValueToAcceptableTypes = require(flags.getFFlagUGCValidateAddObjectValueToAcceptableTypes)
local getFFlagUGCValidateDuplicatesInAnimation = require(flags.getFFlagUGCValidateDuplicatesInAnimation)
local getFFlagUGCValidateMaxTotalInstances = require(flags.getFFlagUGCValidateMaxTotalInstances)
local getFIntUGCValidateMaxAnimationFPS = require(flags.getFIntUGCValidateMaxAnimationFPS)
local getFIntUGCValidateMaxMarkerCurveValueLength = require(flags.getFIntUGCValidateMaxMarkerCurveValueLength)
local GetFStringUGCValidateMaxAnimationMovementPerPart = require(flags.GetFStringUGCValidateMaxAnimationMovementPerPart)
local GetFStringUGCValidateFrameDeltaKeyTimeTol = require(flags.GetFStringUGCValidateFrameDeltaKeyTimeTol)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local GetFStringUGCValidateAnimationHeightTol = require(flags.GetFStringUGCValidateAnimationHeightTol)
local getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage = require(flags.getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage)
local getFFlagUGCValidateCurveAnimRotationSpeed = require(flags.getFFlagUGCValidateCurveAnimRotationSpeed)
local getFIntUGCValidationMaxAnimationRotationSpeedPerSecond = require(flags.getFIntUGCValidationMaxAnimationRotationSpeedPerSecond)
local getFFlagUGCValidateCurveAnimFinalFrameBug = require(flags.getFFlagUGCValidateCurveAnimFinalFrameBug)
local getFFlagUGCValidateCurveAnimMinTimeFix = require(flags.getFFlagUGCValidateCurveAnimMinTimeFix)
local GetFStringUGCValidateCurveAnimationMinLength = require(flags.GetFStringUGCValidateCurveAnimationMinLength)
local getFFlagUGCValidateCurveAnimTimeErrorMessageFix = require(flags.getFFlagUGCValidateCurveAnimTimeErrorMessageFix)
local getFFlagUGCValidateRestrictNumMarkerCurves = require(flags.getFFlagUGCValidateRestrictNumMarkerCurves)
local getFIntUGCValidateMaxTotalMarkerCurves = require(flags.getFIntUGCValidateMaxTotalMarkerCurves)
local getFFlagUGCValidateRestrictNumFaceControls = require(flags.getFFlagUGCValidateRestrictNumFaceControls)
local getFIntUGCValidateMaxTotalFaceControls = require(flags.getFIntUGCValidateMaxTotalFaceControls)
local getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves = require(flags.getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves)
local getFIntUGCValidateMaxTotalInternalMarkers = require(flags.getFIntUGCValidateMaxTotalInternalMarkers)
local getFFlagUGCValidateMigrateSchemaProperties = require(flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(flags.getFFlagUGCValidationCombineEntrypointResults)
local t1 = {}

local function reportFailure(s1: string, s2: string, p1) -- line: 66
	-- upvalues: Analytics (copy)
	Analytics.reportFailure(s2, nil, p1)

	return false, { s1 }
end

local u43 = nil

local function getBodyPartToParentMap() -- line: 79
	-- upvalues: u43 (ref), AssetCalculator (copy)
	if not u43 then
		u43 = AssetCalculator.getBodyPartsToParents()
	end

	return u43
end
local function isBodyPartFolderNameValid(s3: string) -- line: 87
	-- upvalues: u43 (ref), AssetCalculator (copy)
	local v72 = true

	if not u43 then
		u43 = AssetCalculator.getBodyPartsToParents()
	end

	if u43[s3] == nil then
		v72 = s3 == "HumanoidRootPart"
	end

	return v72
end
local function areChildrenAcceptable(p2, t2: {[any]: any}) -- line: 91
	if not p2 then
		return true
	end

	local function findAndRemoveMatching(p3) -- line: 96
		-- upvalues: t2 (copy)
		for v333, v334 in t2 do
			if v334.ClassName == p3.ClassName and v334.Name == p3.Name then
				table.remove(t2, v333)

				return true
			end
		end

		return false
	end

	for _, child in p2:GetChildren() do
		if not findAndRemoveMatching(child) then
			return false
		end
	end

	return true
end
local function calculateAcceptableChildBodyPartFolders(s4: string) -- line: 116
	-- upvalues: u43 (ref), AssetCalculator (copy)
	local t3 = {}

	if not u43 then
		u43 = AssetCalculator.getBodyPartsToParents()
	end

	for v80, v81 in u43 do
		if v81 == s4 then
			table.insert(t3, {
				ClassName = "Folder",
				Name = v80
			})
		end
	end

	return t3
end
local function calculateAcceptableBodyPartFolderChildrenArray(p4, b1: boolean) -- line: 130
	-- upvalues: calculateAcceptableChildBodyPartFolders (copy)
	local v84 = calculateAcceptableChildBodyPartFolders(p4.Name)

	if p4.Name == "HumanoidRootPart" then
		return v84
	end

	table.insert(v84, {
		ClassName = "Vector3Curve",
		Name = "Position"
	})
	table.insert(v84, {
		Name = "Rotation",
		ClassName = not b1 and "RotationCurve" or "EulerRotationCurve"
	})

	if p4.Name ~= "Head" then
		return v84
	end

	table.insert(v84, {
		ClassName = "Folder",
		Name = "FaceControls"
	})

	return v84
end
local function calculateAcceptableCurveChildrenArray() -- line: 161
	return {
		{
			ClassName = "FloatCurve",
			Name = "X"
		},
		{
			ClassName = "FloatCurve",
			Name = "Y"
		},
		{
			ClassName = "FloatCurve",
			Name = "Z"
		}
	}
end
local function containsGrandChildren(p5) -- line: 178
	if not p5 then
		return false
	end

	return #p5:GetDescendants() > #p5:GetChildren()
end
local function validateBodyPartFolderChildren(p6) -- line: 185
	-- upvalues: calculateAcceptableBodyPartFolderChildrenArray (copy), areChildrenAcceptable (copy), calculateAcceptableCurveChildrenArray (copy), getFFlagUGCValidateRestrictNumFaceControls (copy), getFIntUGCValidateMaxTotalFaceControls (copy)
	local v87 = calculateAcceptableBodyPartFolderChildrenArray(p6, true)

	if areChildrenAcceptable(p6, v87) then
		local v88 = calculateAcceptableCurveChildrenArray()

		if not areChildrenAcceptable(p6:FindFirstChild("Position"), v88) then
			return false
		end

		local v89 = calculateAcceptableCurveChildrenArray()

		if not areChildrenAcceptable(p6:FindFirstChild("Rotation"), v89) then
			return false
		end

		local FaceControls = p6:FindFirstChild("FaceControls")

		if FaceControls then
			local children = FaceControls:GetChildren()

			if getFFlagUGCValidateRestrictNumFaceControls() and #children > getFIntUGCValidateMaxTotalFaceControls() then
				return false
			end

			for _, v93 in children do
				if not v93:IsA("FloatCurve") then
					return false
				end
			end
		end

		local Position = p6:FindFirstChild("Position")

		if if Position then #Position:GetDescendants() > #Position:GetChildren() else false then
			return false
		end

		local Rotation = p6:FindFirstChild("Rotation")

		if if Rotation then #Rotation:GetDescendants() > #Rotation:GetChildren() else false then
			return false
		end

		if if FaceControls then #FaceControls:GetDescendants() > #FaceControls:GetChildren() else false then
			return false
		end

		return true
	end

	return false
end
local function validateCurveAnimationBodyPartFolder(p7, p8) -- line: 236
	-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), validateBodyPartFolderChildren (copy), reportFailure (copy), Analytics (copy), u43 (ref), AssetCalculator (copy)
	local function validateBodyPartFolderInternal(p9) -- line: 240
		-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), validateBodyPartFolderChildren (copy), reportFailure (copy), Analytics (copy), p8 (copy), validateBodyPartFolderInternal (copy), u43 (ref), AssetCalculator (copy)
		if getFFlagUGCValidateDuplicatesInAnimation() then
			if not validateBodyPartFolderChildren(p9) then
				return reportFailure(string.format("CurveAnimation contains body part Folder %s which has an invalid hierarchy (it has children that are not allowed or set-up incorrectly)", p9.Name), Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p8)
			end

			for _, child in p9:GetChildren() do
				if not child:IsA("Folder") or child.Name == "FaceControls" then
					continue
				end

				local v338, v339 = validateBodyPartFolderInternal(child)

				if not v338 then
					return false, v339
				end
			end

			return true
		end

		for _, child in p9:GetChildren() do
			if not child:IsA("Folder") then
				continue
			end

			if child.Name == "HumanoidRootPart" then
				return false
			end

			if not u43 then
				u43 = AssetCalculator.getBodyPartsToParents()
			end

			local v342 = u43[child.Name]

			if v342 then
				if v342 ~= p9.Name then
					return false
				end

				return validateBodyPartFolderInternal(child)
			end
		end

		return true
	end

	local p7Name = p7.Name
	local v100 = true

	if not u43 then
		u43 = AssetCalculator.getBodyPartsToParents()
	end

	if u43[p7Name] == nil then
		v100 = p7Name == "HumanoidRootPart"
	end

	if not v100 then
		return true
	end

	return validateBodyPartFolderInternal(p7)
end
local function validateSingleBodyRoot(p10, p11) -- line: 289
	-- upvalues: u43 (ref), AssetCalculator (copy), reportFailure (copy), Analytics (copy), getFFlagUGCValidateDuplicatesInAnimation (copy)
	local n1 = 0

	for _, child in p10:GetChildren() do
		if not child:IsA("Folder") then
			continue
		end

		local childName = child.Name
		local v107 = true

		if not u43 then
			u43 = AssetCalculator.getBodyPartsToParents()
		end

		if u43[childName] == nil then
			v107 = childName == "HumanoidRootPart"
		end

		if not v107 then
			continue
		end

		n1 += 1

		if n1 > 1 then
			return reportFailure("CurveAnimation contains more than one body part or HumanoidRootPart Folder children. Please ensure there is only one child Folder named after a body part or HumanoidRootPart.", Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p11)
		end
	end

	if getFFlagUGCValidateDuplicatesInAnimation() and n1 == 0 then
		return reportFailure("CurveAnimation contains zero body part or HumanoidRootPart Folder children. Please ensure there is one (and only one) child Folder named after a body part or HumanoidRootPart.", Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p11)
	end

	return true
end

function t1.validateMarkerCurves(p12, p13) -- line: 319
	-- upvalues: getFIntUGCValidateMaxTotalMarkerCurves (copy), reportFailure (copy), Analytics (copy)
	local v110 = getFIntUGCValidateMaxTotalMarkerCurves()
	local n2 = 0

	for _, descendant in p12:GetDescendants() do
		if not descendant:IsA("MarkerCurve") then
			continue
		end

		n2 += 1

		if v110 < n2 then
			return reportFailure(`CurveAnimation contains more than { v110 } MarkerCurve(s). Please ensure there is no more than { v110 } MarkerCurve descendant(s).`, Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p13)
		end
	end

	return true
end
function t1.validateSingleAnimationRigData(p14, p15) -- line: 341
	-- upvalues: reportFailure (copy), Analytics (copy)
	local n3 = 0

	for _, child in p14:GetChildren() do
		if not child:IsA("AnimationRigData") then
			continue
		end

		n3 += 1

		if n3 > 1 then
			return reportFailure("CurveAnimation contains more than one AnimationRigData children. Please ensure there is only one AnimationRigData child.", Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p15)
		end
	end

	if n3 == 0 then
		return reportFailure("CurveAnimation contains zero AnimationRigData children. Please ensure there is one (and only one) AnimationRigData children.", Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p15)
	end

	return true
end
function t1.validateAnimationRigDataInternals(p16, p17) -- line: 369
	-- upvalues: reportFailure (copy), Analytics (copy)
	for _, child in p16:GetChildren() do
		if child:IsA("AnimationRigData") and not child:IsValidR15() then
			return reportFailure("AnimationRigData failed internal validation. Please ensure the AnimationRigData is set up correctly.", Analytics.ErrorType.validateCurveAnimation_IncorrectAnimationRigData, p17)
		end
	end

	return true
end

local function validateAnimationRigData(p18, p19) -- line: 389
	-- upvalues: t1 (copy)
	local v125, v126 = t1.validateSingleAnimationRigData(p18, p19)

	if not v125 then
		return false, v126
	end

	local v127, v128 = t1.validateAnimationRigDataInternals(p18, p19)

	if not v127 then
		return false, v128
	end

	return true
end
local function validateScripts(p20, p21) -- line: 405
	-- upvalues: reportFailure (copy), Analytics (copy)
	for _, descendant in p20:GetDescendants() do
		if descendant:IsA("Script") or descendant:IsA("ModuleScript") then
			return reportFailure("CurveAnimation hierarchy contains Scripts, LocalScripts, or ModuleScripts. Please remove them.", Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p21)
		end
	end

	return true
end

local t4 = {
	"MarkerCurve",
	"AnimationRigData",
	"Folder",
	"Vector3Curve",
	"EulerRotationCurve",
	"FloatCurve"
}

if getFFlagUGCValidateAddObjectValueToAcceptableTypes() then
	table.insert(t4, "ObjectValue")
end

local function validateExtraInstances(p22, p23) -- line: 434
	-- upvalues: t4 (copy), reportFailure (copy), Analytics (copy)
	for _, descendant in p22:GetDescendants() do
		local v137 = false

		for _, v139 in t4 do
			if descendant:IsA(v139) then
				v137 = true

				break
			end
		end

		if not v137 then
			return reportFailure(`CurveAnimation hierarchy can only contain { table.concat(t4, ", ") }. Please remove any other Instance types.`, Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p23)
		end
	end

	return true
end

function t1.validateExtraInstancesUnitTest(p24, p25) -- line: 458
	-- upvalues: validateExtraInstances (copy)
	return validateExtraInstances(p24, p25)
end
function t1.validateScriptsUnitTest(p26, p27) -- line: 465
	-- upvalues: validateScripts (copy)
	return validateScripts(p26, p27)
end

local function validateAnimationHierarchy(p28, p29) -- line: 474
	-- upvalues: Analytics (copy), getFFlagUGCValidateMaxTotalInstances (copy), reportFailure (copy), validateSingleBodyRoot (copy), t1 (copy), getFFlagUGCValidateRestrictNumMarkerCurves (copy), getFFlagUGCValidateDuplicatesInAnimation (copy), u43 (ref), AssetCalculator (copy), validateBodyPartFolderChildren (copy), FailureReasonsAccumulator (copy), validateScripts (copy), validateExtraInstances (copy)
	if not p28:IsA("CurveAnimation") then
		Analytics.reportFailure(Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, nil, p29)

		return false, { "Referenced Animation is not a CurveAnimation. Please ensure the animation is uploaded correctly." }
	end

	local v146 = #p28:GetDescendants()

	if v146 > getFFlagUGCValidateMaxTotalInstances() then
		return reportFailure(`CurveAnimation has { v146 } descendants. Maximum allowed is { getFFlagUGCValidateMaxTotalInstances() }. Please reduce the number of descendants.`, Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p29)
	end

	local v147, v148 = validateSingleBodyRoot(p28, p29)

	if not v147 then
		return false, v148
	end

	local v149, v150 = t1.validateSingleAnimationRigData(p28, p29)
	local v151

	if not v149 then
		v151 = false
	else
		local v152

		v152, v150 = t1.validateAnimationRigDataInternals(p28, p29)

		if not v152 then
			v151 = false
		else
			v151 = true
			v150 = nil
		end
	end

	if not v151 then
		return false, v150
	end

	if getFFlagUGCValidateRestrictNumMarkerCurves() then
		local v153, v154 = t1.validateMarkerCurves(p28, p29)

		if not v153 then
			return false, v154
		end
	end

	for _, child in p28:GetChildren() do
		if not child:IsA("MarkerCurve") and not child:IsA("AnimationRigData") then
			if not child:IsA("Folder") then
				return reportFailure("CurveAnimation contains unexpected child: " .. child.Name, Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p29)
			end

			if not getFFlagUGCValidateDuplicatesInAnimation() then
				local v157 = nil

				local function validateBodyPartFolderInternal(p30) -- line: 240
					-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), validateBodyPartFolderChildren (copy), reportFailure (copy), Analytics (copy), v157 (copy), validateBodyPartFolderInternal (copy), u43 (ref), AssetCalculator (copy)
					if getFFlagUGCValidateDuplicatesInAnimation() then
						if not validateBodyPartFolderChildren(p30) then
							return reportFailure(string.format("CurveAnimation contains body part Folder %s which has an invalid hierarchy (it has children that are not allowed or set-up incorrectly)", p30.Name), Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, v157)
						end

						for _, child2 in p30:GetChildren() do
							if not child2:IsA("Folder") or child2.Name == "FaceControls" then
								continue
							end

							local v354, v355 = validateBodyPartFolderInternal(child2)

							if not v354 then
								return false, v355
							end
						end

						return true
					end

					for _, child3 in p30:GetChildren() do
						if not child3:IsA("Folder") then
							continue
						end

						if child3.Name == "HumanoidRootPart" then
							return false
						end

						if not u43 then
							u43 = AssetCalculator.getBodyPartsToParents()
						end

						local v358 = u43[child3.Name]

						if v358 then
							if v358 ~= p30.Name then
								return false
							end

							return validateBodyPartFolderInternal(child3)
						end
					end

					return true
				end

				local childName = child.Name
				local v160 = true

				if not u43 then
					u43 = AssetCalculator.getBodyPartsToParents()
				end

				if u43[childName] == nil then
					v160 = childName == "HumanoidRootPart"
				end

				if not v160 or validateBodyPartFolderInternal(child) then
					continue
				end

				return reportFailure("CurveAnimation contains child body part Folder " .. child.Name .. " which has an invalid hierarchy", Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p29)
			end

			local childName = child.Name
			local v162 = true

			if not u43 then
				u43 = AssetCalculator.getBodyPartsToParents()
			end

			if u43[childName] == nil then
				v162 = childName == "HumanoidRootPart"
			end

			if not v162 then
				return reportFailure("CurveAnimation contains unexpected child: " .. child.Name, Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p29)
			end

			local function validateBodyPartFolderInternal(p31) -- line: 240
				-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), validateBodyPartFolderChildren (copy), reportFailure (copy), Analytics (copy), p29 (copy), validateBodyPartFolderInternal (copy), u43 (ref), AssetCalculator (copy)
				if getFFlagUGCValidateDuplicatesInAnimation() then
					if not validateBodyPartFolderChildren(p31) then
						return reportFailure(string.format("CurveAnimation contains body part Folder %s which has an invalid hierarchy (it has children that are not allowed or set-up incorrectly)", p31.Name), Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p29)
					end

					for _, child4 in p31:GetChildren() do
						if not child4:IsA("Folder") or child4.Name == "FaceControls" then
							continue
						end

						local v346, v347 = validateBodyPartFolderInternal(child4)

						if not v346 then
							return false, v347
						end
					end

					return true
				end

				for _, child5 in p31:GetChildren() do
					if not child5:IsA("Folder") then
						continue
					end

					if child5.Name == "HumanoidRootPart" then
						return false
					end

					if not u43 then
						u43 = AssetCalculator.getBodyPartsToParents()
					end

					local v350 = u43[child5.Name]

					if v350 then
						if v350 ~= p31.Name then
							return false
						end

						return validateBodyPartFolderInternal(child5)
					end
				end

				return true
			end

			local childName2 = child.Name
			local v165 = true

			if not u43 then
				u43 = AssetCalculator.getBodyPartsToParents()
			end

			if u43[childName2] == nil then
				v165 = childName2 == "HumanoidRootPart"
			end

			local v166, v167

			if not v165 then
				v166 = true
				v167 = nil
			else
				v166, v167 = validateBodyPartFolderInternal(child)
			end

			if v166 then
				continue
			end

			return false, v167
		end

		if getFFlagUGCValidateDuplicatesInAnimation() and #child:GetChildren() > 0 then
			return reportFailure("CurveAnimation child MarkerCurves and AnimationRigData cannot have children", Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, p29)
		end
	end

	local v168 = FailureReasonsAccumulator.new()

	v168:updateReasons(validateScripts(p28, p29))
	v168:updateReasons(validateExtraInstances(p28, p29))

	return v168:getFinalResults()
end
local function createDefaultCharacter(b2: boolean) -- line: 572
	-- upvalues: Players (copy)
	local v170 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then game.Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15) else Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)

	for _, descendant in v170:GetDescendants() do
		if descendant:IsA("Decal") then
			descendant.Transparency = 1
		elseif descendant:IsA("MeshPart") then
			descendant.Transparency = 1
			descendant.CanCollide = false
		elseif descendant:IsA("Motor6D") and b2 then
			descendant:Destroy()
		end
	end

	return v170
end

local v60 = 1 / getFIntUGCValidateMaxAnimationFPS()

local function getBodyPartFolderRoot(p32) -- line: 606
	-- upvalues: u43 (ref), AssetCalculator (copy)
	for _, child in p32:GetChildren() do
		if not child:IsA("Folder") then
			continue
		end

		local childName = child.Name
		local v177 = true

		if not u43 then
			u43 = AssetCalculator.getBodyPartsToParents()
		end

		if u43[childName] == nil then
			v177 = childName == "HumanoidRootPart"
		end

		if v177 then
			return child
		end
	end

	return nil
end
local function hasFloatCurveKeys(p33) -- line: 615
	local X = p33:FindFirstChild("X")
	local Y = p33:FindFirstChild("Y")
	local Z = p33:FindFirstChild("Z")
	local v182 = not not X and (X:IsA("FloatCurve") and #X:GetKeys() > 0)

	if not v182 then
		v182 = not not Y and (Y:IsA("FloatCurve") and #Y:GetKeys() > 0)

		if not v182 then
			if Z then
				v182 = Z:IsA("FloatCurve")

				if v182 then
					return #Z:GetKeys() > 0
				end
			else
				v182 = false
			end
		end
	end

	return v182
end
local function hasPositionKeys(p34) -- line: 625
	-- upvalues: hasFloatCurveKeys (copy)
	if not p34 then
		return false
	end

	if not p34:IsA("Vector3Curve") then
		return false
	end

	return (hasFloatCurveKeys(p34))
end
local function hasRotationKeys(p35) -- line: 636
	-- upvalues: hasFloatCurveKeys (copy)
	if not p35 then
		return false
	end

	if not p35:IsA("EulerRotationCurve") then
		return false
	end

	return (hasFloatCurveKeys(p35))
end
local function calculateAnimFramesAtOriginManual(p36) -- line: 648
	-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), getBodyPartFolderRoot (copy), u43 (ref), AssetCalculator (copy), hasFloatCurveKeys (copy), Constants (copy), createDefaultCharacter (copy), getFFlagUGCValidateCurveAnimFinalFrameBug (copy), v60 (copy)
	local function getCurveTracks() -- line: 651
		-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), getBodyPartFolderRoot (copy), p36 (copy), u43 (ref), AssetCalculator (copy), hasFloatCurveKeys (copy), Constants (copy)
		local t5 = {}
		local descendants

		if getFFlagUGCValidateDuplicatesInAnimation() then
			local v360 = getBodyPartFolderRoot(p36)

			assert(v360, "ValidateCurveAnimation.validateStructure() ensures CurveAnimation has one and only one body part Folder child or HumanoidRootPart child.")
			descendants = v360:GetDescendants()
			table.insert(descendants, v360)
		else
			descendants = p36:GetDescendants()
		end

		for _, v363 in descendants do
			if v363:IsA("Folder") then
				if not u43 then
					u43 = AssetCalculator.getBodyPartsToParents()
				end

				if u43[v363.Name] then
					local Position = v363:FindFirstChild("Position")
					local Rotation = v363:FindFirstChild("Rotation")

					t5[v363.Name] = {
						pos = if not if Position then if Position:IsA("Vector3Curve") then hasFloatCurveKeys(Position) else false else false then nil else Position,
						rot = if not if Rotation then if Rotation:IsA("EulerRotationCurve") then hasFloatCurveKeys(Rotation) else false else false then nil else Rotation,
						faceControls = if v363.Name ~= Constants.NAMED_R15_BODY_PARTS.Head then nil else v363:FindFirstChild("FaceControls")
					}
				end
			end
		end

		return t5
	end
	local function calculateCurveAnimLength(p37) -- line: 684
		local n4 = -1

		local function getMaxTimeFromFloatCurveChildren(p38) -- line: 687
			-- upvalues: n4 (ref)
			if not p38 then
				return
			end

			for _, child in p38:GetChildren() do
				if child:IsA("FloatCurve") then
					for _, v391 in child:GetKeys() do
						n4 = math.max(n4, v391.Time)
					end
				end
			end
		end

		for _, v370 in p37 do
			getMaxTimeFromFloatCurveChildren(v370.pos)
			getMaxTimeFromFloatCurveChildren(v370.rot)
			getMaxTimeFromFloatCurveChildren(v370.faceControls)
		end

		return n4
	end
	local function calculateTransformsAtTime(n5: number, p39) -- line: 710
		local t6 = {}

		for v374, v375 in p39 do
			local v376 = if not v375.pos then Vector3.new(0, 0, 0) else Vector3.new(unpack(v375.pos:GetValueAtTime(n5)))

			t6[v374] = ((if not v375.rot then CFrame.new() else v375.rot:GetRotationAtTime(n5))) + v376
		end

		return t6
	end
	local function calculatePositionMagnitudeResultsAtTime(n6: number, p40) -- line: 720
		local t7 = {}

		for v380, v381 in p40 do
			if v381.pos then
				t7[v380] = Vector3.new(unpack(v381.pos:GetValueAtTime(n6))).Magnitude
			end
		end

		return t7
	end

	local v190 = createDefaultCharacter(false)
	local t8 = {}

	for _, child in v190:GetChildren() do
		local childName = child.Name
		local v195 = true

		if not u43 then
			u43 = AssetCalculator.getBodyPartsToParents()
		end

		if u43[childName] == nil then
			v195 = childName == "HumanoidRootPart"
		end

		if v195 then
			t8[child.Name] = child
		end
	end

	local v196 = getCurveTracks()
	local v197 = calculateCurveAnimLength(v196)
	local t9 = {}
	local t10 = {}

	local function addData(n7: number) -- line: 746
		-- upvalues: calculateTransformsAtTime (copy), v196 (copy), AssetCalculator (copy), t8 (copy), t9 (copy), t10 (copy), calculatePositionMagnitudeResultsAtTime (copy)
		local v383 = calculateTransformsAtTime(n7, v196)
		local v384 = AssetCalculator.calculateAllTransformsForFullBody(t8, v383)

		table.insert(t9, v384)
		table.insert(t10, (calculatePositionMagnitudeResultsAtTime(n7, v196)))
	end

	local n8 = 0

	while n8 <= v197 do
		if getFFlagUGCValidateCurveAnimFinalFrameBug() then
			local v202 = calculateTransformsAtTime(n8, v196)

			table.insert(t9, (AssetCalculator.calculateAllTransformsForFullBody(t8, v202)))
			table.insert(t10, (calculatePositionMagnitudeResultsAtTime(n8, v196)))
		else
			local v203 = calculateTransformsAtTime(n8, v196)

			table.insert(t9, (AssetCalculator.calculateAllTransformsForFullBody(t8, v203)))
			table.insert(t10, (calculatePositionMagnitudeResultsAtTime(n8, v196)))
		end

		n8 += v60
	end

	if getFFlagUGCValidateCurveAnimFinalFrameBug() and v197 >= 0 then
		local v204 = calculateTransformsAtTime(v197, v196)

		table.insert(t9, (AssetCalculator.calculateAllTransformsForFullBody(t8, v204)))
		table.insert(t10, (calculatePositionMagnitudeResultsAtTime(v197, v196)))
	end

	v190:Destroy()

	return t9, v197, t10, v196
end

function t1.validateAnimationLength(n9: number, p41) -- line: 779
	-- upvalues: getFFlagUGCValidateCurveAnimMinTimeFix (copy), GetFStringUGCValidateCurveAnimationMinLength (copy), GetFStringUGCValidationMaxAnimationLength (copy), getFFlagUGCValidateCurveAnimTimeErrorMessageFix (copy), reportFailure (copy), Analytics (copy)
	local v207 = not getFFlagUGCValidateCurveAnimMinTimeFix() and 0 or GetFStringUGCValidateCurveAnimationMinLength.asNumber()

	if n9 <= v207 or n9 > GetFStringUGCValidationMaxAnimationLength.asNumber() then
		if getFFlagUGCValidateCurveAnimTimeErrorMessageFix() then
			return reportFailure(`CurveAnimation must be between { v207 } and { GetFStringUGCValidationMaxAnimationLength.asString() } seconds long. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_UnacceptableLength, p41)
		end

		return reportFailure(`CurveAnimation must be between 0 and { GetFStringUGCValidationMaxAnimationLength.asString() } seconds long. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_UnacceptableLength, p41)
	end

	return true
end
function t1.validateBounds(t11: {[any]: any}, p42, n10: number) -- line: 806
	-- upvalues: getFFlagUGCValidateCurveAnimTimeErrorMessageFix (copy), GetFStringUGCValidateAnimationHeightTol (copy), GetFStringUGCValidationMaxAnimationBounds (copy), v60 (copy), reportFailure (copy), Analytics (copy), FailureReasonsAccumulator (copy)
	local n11 = 1e999
	local n12 = 0
	local v213 = nil
	local v214 = nil

	if getFFlagUGCValidateCurveAnimTimeErrorMessageFix() then
		v213 = GetFStringUGCValidateAnimationHeightTol.asNumber()
		v214 = GetFStringUGCValidationMaxAnimationBounds.asNumber()
	end

	for v215, v216 in t11 do
		for v217, v218 in v216 do
			if getFFlagUGCValidateCurveAnimTimeErrorMessageFix() then
				if v213 > v218.Position.Y then
					local v219 = string.format("In CurveAnimation at time %.2f seconds, body part %s is at height %.2f studs from the HumanoidRootPart. Body parts cannot be lower than %s studs from the HumanoidRootPart. Please fix the animation.", math.min(n10, (v215 - 1) * v60), v217, v218.Position.Y, GetFStringUGCValidateAnimationHeightTol.asString())

					return reportFailure(v219, Analytics.ErrorType.validateCurveAnimation_UnacceptableSizeBounds, p42)
				end

				if not (v214 < v218.Position.Magnitude) then
					continue
				end

				local v220 = string.format("In CurveAnimation at time %.2f seconds, body part %s is %.2f studs from the HumanoidRootPart. Body parts cannot be more than %s studs from the HumanoidRootPart. Please fix the animation.", math.min(n10, (v215 - 1) * v60), v217, v218.Position.Magnitude, GetFStringUGCValidationMaxAnimationBounds.asString())

				return reportFailure(v220, Analytics.ErrorType.validateCurveAnimation_UnacceptableSizeBounds, p42)
			end

			n12 = math.max(n12, v218.Position.Magnitude)
			n11 = math.min(n11, v218.Position.Y)
		end
	end

	if not getFFlagUGCValidateCurveAnimTimeErrorMessageFix() then
		local v221 = FailureReasonsAccumulator.new()

		v221:updateReasons(n11 >= GetFStringUGCValidateAnimationHeightTol.asNumber(), { `Body parts in a CurveAnimation cannot be lower than { GetFStringUGCValidateAnimationHeightTol.asString() } studs from the HumanoidRootPart. Please fix the animation.` })
		v221:updateReasons(n12 <= GetFStringUGCValidationMaxAnimationBounds.asNumber(), { `Body parts in a CurveAnimation cannot get more than { GetFStringUGCValidationMaxAnimationBounds.asString() } studs from the HumanoidRootPart. Please fix the animation.` })

		if not v221:getFinalResults() then
			Analytics.reportFailure(Analytics.ErrorType.validateCurveAnimation_UnacceptableSizeBounds, nil, p42)
		end

		return v221:getFinalResults()
	end

	return true
end
function t1.validateFrameDeltas(t12: {[any]: any}, p43) -- line: 884
	-- upvalues: v60 (copy), GetFStringUGCValidationMaxAnimationDeltas (copy), getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage (copy), reportFailure (copy), Analytics (copy)
	local v224 = v60 / 0.03333333333333333
	local v225 = GetFStringUGCValidationMaxAnimationDeltas.asNumber() * v224
	local v226 = nil

	if getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage() then
		v226 = GetFStringUGCValidationMaxAnimationDeltas.asNumber() * 30
	end

	local t13 = {}

	for v228, v229 in t12 do
		for v230, v231 in v229 do
			local v232 = t13[v230]

			if not v232 then
				continue
			end

			local Magnitude = (v231.Position - v232.Position).Magnitude

			if v225 < Magnitude then
				if getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage() then
					local v234 = (v228 - 1) * v60
					local v235 = Magnitude / v224 * 30
					local v236 = string.format("In CurveAnimation at time %.2f seconds, body part %s is moving at a speed of %.2f studs/second. %.2f is the maximum studs/second speed. Please fix the animation.", v234, v230, v235, v226)

					return reportFailure(v236, Analytics.ErrorType.validateCurveAnimation_UnacceptableFrameDelta, p43)
				end

				return reportFailure(`Body part { v230 } in CurveAnimation moves more than { GetFStringUGCValidationMaxAnimationDeltas.asString() } studs between frames. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_UnacceptableFrameDelta, p43)
			end
		end

		t13 = v229
	end

	return true
end
function t1.validateFrameRotationDeltas(t14: {[any]: any}, p44) -- line: 942
	-- upvalues: v60 (copy), getFIntUGCValidateMaxAnimationFPS (copy), getFIntUGCValidationMaxAnimationRotationSpeedPerSecond (copy), reportFailure (copy), Analytics (copy)
	assert(math.abs(1 / v60 - getFIntUGCValidateMaxAnimationFPS()) < 1E-05, "frameDelta should be calculated as 1 / getFIntUGCValidateMaxAnimationFPS()")

	local v239 = getFIntUGCValidationMaxAnimationRotationSpeedPerSecond()
	local v240 = v239 / getFIntUGCValidateMaxAnimationFPS()
	local t15 = {}

	for v242, v243 in t14 do
		for v244, v245 in v243 do
			local v246 = t15[v244]

			if not v246 then
				continue
			end

			local v247 = math.deg((math.abs((v245:AngleBetween(v246)))))

			if v240 < v247 then
				local v248 = (v242 - 1) * v60
				local v249 = v247 * getFIntUGCValidateMaxAnimationFPS()
				local v250 = string.format("In CurveAnimation at time %.2f seconds, body part %s is moving at a rotation speed of %.2f degrees/second. %.2f is the maximum degrees/second speed. Please fix the animation.", v248, v244, v249, v239)

				return reportFailure(v250, Analytics.ErrorType.validateCurveAnimation_UnacceptableFrameRotationDelta, p44)
			end
		end

		t15 = v243
	end

	return true
end
function t1.validateMinimumTransformations(t16: {[any]: any}, p45) -- line: 991
	-- upvalues: reportFailure (copy), Analytics (copy)
	for _, v254 in t16 do
		if v254.pos or v254.rot then
			return true
		end
	end

	return reportFailure("CurveAnimation does not contain any joint manipulation.", Analytics.ErrorType.validateCurveAnimation_AnimationContainsNoJointManipulation, p45)
end
function t1.validateContainsJointManipulation(p46, p47) -- line: 1008
	-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), getBodyPartFolderRoot (copy), u43 (ref), AssetCalculator (copy), reportFailure (copy), Analytics (copy)
	local descendants

	if getFFlagUGCValidateDuplicatesInAnimation() then
		local v257 = getBodyPartFolderRoot(p46)

		assert(v257, "ValidateCurveAnimation.validateStructure() ensures CurveAnimation has one and only one body part Folder child or HumanoidRootPart child.")
		descendants = v257:GetDescendants()
		table.insert(descendants, v257)
	else
		descendants = p46:GetDescendants()
	end

	for _, v260 in descendants do
		if not v260:IsA("Folder") then
			continue
		end

		if not u43 then
			u43 = AssetCalculator.getBodyPartsToParents()
		end

		if not u43[v260.Name] then
			continue
		end

		local Position = v260:FindFirstChild("Position")
		local Rotation = v260:FindFirstChild("Rotation")

		if Position and Position:IsA("Vector3Curve") and Rotation and Rotation:IsA("EulerRotationCurve") then
			return true
		end
	end

	return reportFailure("CurveAnimation does not contain any joint manipulation.", Analytics.ErrorType.validateCurveAnimation_AnimationContainsNoJointManipulation, p47)
end

local function isTimeStamp(s5: string) -- line: 1045
	if #s5 > 30 then
		return false
	end

	return string.match(s5, "^[0-9]+$") ~= nil
end

function t1.validateAllowedTags(p48, p49) -- line: 1053
	-- upvalues: validateTags (copy), CollectionService (copy), reportFailure (copy), Analytics (copy)
	for _, child in p48:GetChildren() do
		local v268, v269 = validateTags(child, p49)

		if not v268 then
			return v268, v269
		end
	end

	local Tags = CollectionService:GetTags(p48)
	local v271 = #Tags

	if v271 > 0 then
		if v271 > 1 then
			return reportFailure("CurveAnimation can only contain a single timestamp tag. Please remove all other tags.", Analytics.ErrorType.validateTags, p49)
		end

		local v272 = Tags[1]

		if #v272 > 30 or string.match(v272, "^[0-9]+$") == nil then
			return reportFailure("CurveAnimation can only contain a single timestamp tag. Please remove all other tags.", Analytics.ErrorType.validateTags, p49)
		end
	end

	return true
end
function t1.validateStructure(p50, p51) -- line: 1080
	-- upvalues: validateAnimationHierarchy (copy)
	return validateAnimationHierarchy(p50, p51)
end

local function areNumbersGood(...) -- line: 1087
	local function isNaN(n13: number) -- line: 1088
		return n13 ~= n13
	end
	local function isInfinite(n14: number) -- line: 1092
		return n14 == 1e999 or n14 == -1e999
	end

	for _, v278 in { ... } do
		if v278 ~= v278 then
			return false
		end

		if v278 == 1e999 or v278 == -1e999 then
			return false
		end
	end

	return true
end

function t1.validateData(p52, p53) -- line: 1107
	-- upvalues: v60 (copy), GetFStringUGCValidateFrameDeltaKeyTimeTol (copy), GetFStringUGCValidationMaxAnimationLength (copy), getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves (copy), getFIntUGCValidateMaxTotalInternalMarkers (copy), reportFailure (copy), Analytics (copy), areNumbersGood (copy), getFIntUGCValidateMaxMarkerCurveValueLength (copy), getFIntUGCValidateMaxAnimationFPS (copy)
	local v281 = v60 * GetFStringUGCValidateFrameDeltaKeyTimeTol.asNumber()
	local v282 = math.ceil(1 / v281 * GetFStringUGCValidationMaxAnimationLength.asNumber())

	for _, descendant in p52:GetDescendants() do
		if not descendant:IsA("MarkerCurve") then
			if not descendant:IsA("FloatCurve") then
				continue
			end

			local Keys = descendant:GetKeys()

			if v282 < #Keys then
				return reportFailure(`CurveAnimation contains Curves with too many keys. { v282 } is the maximum per Curve. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p53)
			end

			local Time = nil

			for _, v288 in Keys do
				if not v288.Time or not areNumbersGood(v288.Time) or not v288.Value or not areNumbersGood(v288.Value) then
					return reportFailure("CurveAnimation contains Curves with invalid Time or Value. Please fix the animation.", Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p53)
				end

				if Time then
					if Time + v281 > v288.Time then
						local v289 = not descendant.Parent.Parent and "-" or descendant.Parent.Parent.Name

						return reportFailure(`CurveAnimation contains Curve { v289 }.{ descendant.Parent.Name }.{ descendant.Name } with keys that are too close together in time for a maximum { getFIntUGCValidateMaxAnimationFPS() } fps animation. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p53)
					end
				elseif v288.Time < 0 then
					local v290 = not descendant.Parent.Parent and "-" or descendant.Parent.Parent.Name

					return reportFailure(`CurveAnimation contains Curve { v290 }.{ descendant.Parent.Name }.{ descendant.Name } with a key that has a negative time. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p53)
				end

				Time = v288.Time
			end

			continue
		end

		local Markers = descendant:GetMarkers()

		if getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves() then
			local v292 = math.min(getFIntUGCValidateMaxTotalInternalMarkers(), v282)

			if v292 < #Markers then
				return reportFailure(`CurveAnimation contains a MarkerCurve with { #Markers } Markers. { v292 } is the maximum per MarkerCurve. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p53)
			end
		elseif v282 < #Markers then
			return reportFailure(`CurveAnimation contains MarkerCurve with too many markers. { v282 } is the maximum per MarkerCurve. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p53)
		end

		for _, v294 in Markers do
			if not v294.Time or not areNumbersGood(v294.Time) or not v294.Value or #v294.Value > getFIntUGCValidateMaxMarkerCurveValueLength() then
				return reportFailure("CurveAnimation contains MarkerCurves with invalid Time or Value, or Value is too long. Please fix the animation.", Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p53)
			end
		end
	end

	return true
end
function t1.validateCalculatedData(t17: {[any]: any}, t18: {[any]: any}, p54) -- line: 1201
	-- upvalues: areNumbersGood (copy), reportFailure (copy), Analytics (copy)
	for _, v299 in t17 do
		for _, v301 in v299 do
			if not areNumbersGood(v301:GetComponents()) then
				return reportFailure("CurveAnimation contains Curves with invalid numerical data. Please fix the animation.", Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p54)
			end
		end
	end

	for _, v303 in t18 do
		for _, v305 in v303 do
			if not areNumbersGood(v305) then
				return reportFailure("CurveAnimation contains Curves with invalid numerical data. Please fix the animation.", Analytics.ErrorType.validateCurveAnimation_IncorrectNumericalData, p54)
			end
		end
	end

	return true
end
function t1.calculateAnimFramesAtOrigin(p55) -- line: 1232
	-- upvalues: calculateAnimFramesAtOriginManual (copy)
	return calculateAnimFramesAtOriginManual(p55)
end
function t1.validatePositionMagnitudes(t19: {[any]: any}, p56) -- line: 1238
	-- upvalues: Constants (copy), GetFStringUGCValidateMaxAnimationMovementPerPart (copy), reportFailure (copy), Analytics (copy)
	local t20 = {}

	for _, v311 in t19 do
		for v312, v313 in v311 do
			if v312 == Constants.NAMED_R15_BODY_PARTS.LowerTorso then
				continue
			end

			if not t20[v312] then
				t20[v312] = GetFStringUGCValidateMaxAnimationMovementPerPart.asNumber(v312)
			end

			if v313 > t20[v312] then
				return reportFailure(`CurveAnimation contains positional separation of body parts. Only LowerTorso can change position. All other body parts can only change their orientation. { v312 } moves more than { t20[v312] } studs from its parent. Please fix the animation.`, Analytics.ErrorType.validateCurveAnimation_PositionalMovement, p56)
			end
		end
	end

	return true
end
function t1.validateFrames(p57, p58) -- line: 1266
	-- upvalues: t1 (copy), FailureReasonsAccumulator (copy), getFFlagUGCValidateCurveAnimRotationSpeed (copy)
	local v316, v317, v318, v319 = t1.calculateAnimFramesAtOrigin(p57)
	local v320, v321 = t1.validateCalculatedData(v316, v318, p58)

	if not v320 then
		return v320, v321
	end

	local v322 = FailureReasonsAccumulator.new()

	v322:updateReasons(t1.validateMinimumTransformations(v319, p58))
	v322:updateReasons(t1.validatePositionMagnitudes(v318, p58))
	v322:updateReasons(t1.validateAnimationLength(v317, p58))
	v322:updateReasons(t1.validateBounds(v316, p58, v317))
	v322:updateReasons(t1.validateFrameDeltas(v316, p58))

	if getFFlagUGCValidateCurveAnimRotationSpeed() then
		v322:updateReasons(t1.validateFrameRotationDeltas(v316, p58))
	end

	return v322:getFinalResults()
end
function t1.validate(p59, p60) -- line: 1297
	-- upvalues: t1 (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), FailureReasonsAccumulator (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validateAttributes (copy)
	local v325, v326 = t1.validateStructure(p59, p60)

	if not v325 then
		return v325, v326
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v327, v328 = ValidatePropertiesSensible.validate(p59, p60)

		if not v327 then
			return false, v328
		end
	end

	local v329, v330 = t1.validateData(p59, p60)

	if not v329 then
		return v329, v330
	end

	local v331 = FailureReasonsAccumulator.new()

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v331:updateReasons(validateAttributes(p59, p60))
	end

	v331:updateReasons(t1.validateAllowedTags(p59, p60))
	v331:updateReasons(t1.validateFrames(p59, p60))

	return v331:getFinalResults()
end

return t1
