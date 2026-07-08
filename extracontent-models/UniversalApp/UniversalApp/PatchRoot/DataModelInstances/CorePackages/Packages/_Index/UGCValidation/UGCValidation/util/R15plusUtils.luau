local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local t1 = {}
local t8 = nil
local flags = ParentParent.flags
local getFFlagUGCValidationAllowHRDUpload = require(flags.getFFlagUGCValidationAllowHRDUpload)
local getFFlagDebugAllowHRDUploadOnBundleBackend = require(flags.getFFlagDebugAllowHRDUploadOnBundleBackend)
local getFFlagUGCValidationExtendSchemaToIgnoreDescendants = require(flags.getFFlagUGCValidationExtendSchemaToIgnoreDescendants)
local t2 = {
	"Index",
	"Middle",
	"Pinky",
	"Ring",
	"Thumb"
}

local function buildDrdSchema(s1: string) -- line: 16
	-- upvalues: t2 (copy)
	local t3 = {}

	for _, v23 in t2 do
		local v24 = `{ s1 }Hand{ v23 }`
		local v25 = `{ v24 }1`
		local v26 = `{ v24 }2`
		local v27 = `{ v24 }3`

		t3[v25] = {
			ClassName = "Bone",
			_children = {
				[v26] = {
					ClassName = "Bone",
					_children = {
						[v27] = {
							ClassName = "Bone"
						}
					}
				}
			}
		}
	end

	return t3
end

local t4 = {
	HeadBase = {
		ClassName = "Bone",
		_children = {
			FaceCenterAttachment = {
				ClassName = "Attachment"
			},
			FaceFrontAttachment = {
				ClassName = "Attachment"
			},
			HairAttachment = {
				ClassName = "Attachment"
			},
			HatAttachment = {
				ClassName = "Attachment"
			}
		}
	}
}
local t5 = {
	Spine = {
		ClassName = "Bone",
		_children = {
			Chest = {
				ClassName = "Bone",
				_children = {
					BodyBackAttachment = {
						ClassName = "Attachment"
					},
					BodyFrontAttachment = {
						ClassName = "Attachment"
					},
					NeckRigAttachment = {
						ClassName = "Attachment"
					},
					NeckAttachment = {
						ClassName = "Attachment"
					},
					LeftClavicle = {
						ClassName = "Bone",
						_children = {
							LeftCollarAttachment = {
								ClassName = "Attachment"
							},
							LeftShoulderRigAttachment = {
								ClassName = "Attachment"
							}
						}
					},
					RightClavicle = {
						ClassName = "Bone",
						_children = {
							RightCollarAttachment = {
								ClassName = "Attachment"
							},
							RightShoulderRigAttachment = {
								ClassName = "Attachment"
							}
						}
					}
				}
			}
		}
	}
}
local t6 = {
	LeftToeBase = {
		ClassName = "Bone"
	}
}
local t7 = {
	RightToeBase = {
		ClassName = "Bone"
	}
}
local v15 = buildDrdSchema("Left")
local v16 = buildDrdSchema("Right")

t1.JointRotationName = "JointRotation"

local u17 = false

function t1.setIsBackendBundleUpload(b1: boolean) -- line: 128
	-- upvalues: u17 (ref)
	u17 = b1
end
function t1.checkFlagEnabledForAllowHrd() -- line: 132
	-- upvalues: getFFlagUGCValidationExtendSchemaToIgnoreDescendants (copy), getFFlagUGCValidationAllowHRDUpload (copy), getFFlagDebugAllowHRDUploadOnBundleBackend (copy), u17 (ref)
	if not getFFlagUGCValidationExtendSchemaToIgnoreDescendants() then
		return false
	end

	if getFFlagUGCValidationAllowHRDUpload() then
		return true
	end

	if getFFlagDebugAllowHRDUploadOnBundleBackend() and u17 then
		return true
	end

	return false
end

local JointLabels = nil
local JointLabels2 = nil

function t1.getHrdJointLabels() -- line: 155
	-- upvalues: JointLabels (ref)
	if JointLabels == nil then
		JointLabels = Instance.new("HumanoidRigDescription"):GetJointLabels()
	end

	return JointLabels
end
function t1.getDrdJointLabels() -- line: 162
	-- upvalues: JointLabels2 (ref)
	if JointLabels2 == nil then
		JointLabels2 = Instance.new("DigitsRigDescription"):GetJointLabels()
	end

	return JointLabels2
end
function t1.getJointNameWhitelist() -- line: 169
	-- upvalues: t8 (ref), Constants (copy), t1 (copy)
	if t8 ~= nil then
		return t8
	end

	t8 = {}

	for v29, _ in Constants.R15_STANDARD_JOINT_NAMES do
		t8[v29] = true
	end

	for _, v32 in t1.getHrdJointLabels() do
		t8[v32.Name] = true
	end

	for _, v34 in t1.getDrdJointLabels() do
		t8[`LeftHand{ v34.Name }`] = true
		t8[`RightHand{ v34.Name }`] = true
	end

	return t8
end
function t1.getNameWhitelistOfClassInSchema(p1, s2: string) -- line: 191
	-- upvalues: t1 (copy)
	local t9 = {}

	for v38, v39 in p1 do
		if s2 == v39.ClassName then
			t9[v38] = true
		end

		if v39._children ~= nil then
			for v40, v41 in t1.getNameWhitelistOfClassInSchema(v39._children, s2) do
				t9[v40] = v41
			end
		end
	end

	return t9
end
function t1.getSchemaFlatHierarchyList(p2, t10: {[any]: any}) -- line: 211
	-- upvalues: t1 (copy)
	local t11 = {}

	for v45, v46 in p2 do
		local v47 = table.clone(t10)

		table.insert(v47, v45)
		t11[v45] = {
			ClassName = v46.ClassName,
			path = v47
		}

		if v46._children ~= nil then
			for v48, v49 in t1.getSchemaFlatHierarchyList(v46._children, v47) do
				t11[v48] = v49
			end
		end
	end

	return t11
end
function t1.getFingerFlatSuffixes() -- line: 235
	-- upvalues: t2 (copy)
	return t2
end
function t1.getDrdSchema(s3: string) -- line: 239
	-- upvalues: v15 (copy), v16 (copy)
	if s3 == "Left" then
		return v15
	end

	if s3 == "Right" then
		return v16
	end

	error("Invalid side: " .. s3)
end
function t1.getAvatarBoneSchema(s4: string) -- line: 249
	-- upvalues: t4 (copy), t5 (copy), t6 (copy), t7 (copy), v15 (copy), v16 (copy)
	if s4 == "Head" then
		return t4
	end

	if s4 == "UpperTorso" then
		return t5
	end

	if s4 == "LeftFoot" then
		return t6
	end

	if s4 == "RightFoot" then
		return t7
	end

	if s4 == "LeftHand" then
		return v15
	end

	if s4 == "RightHand" then
		return v16
	end

	return {}
end

return t1
