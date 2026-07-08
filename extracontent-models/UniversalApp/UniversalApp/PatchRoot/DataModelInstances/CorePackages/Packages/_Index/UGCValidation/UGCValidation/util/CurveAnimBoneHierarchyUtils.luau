local ParentParent = script.Parent.Parent
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local t1 = {}
local t2 = {
	"Head",
	"UpperTorso",
	"LeftFoot",
	"RightFoot",
	"LeftHand",
	"RightHand"
}
local u5 = nil
local u6 = nil
local u7 = nil

local function ensureCaches() -- line: 14
	-- upvalues: u7 (ref), t2 (copy), R15plusUtils (copy), u5 (ref), u6 (ref)
	if u7 then
		return
	end

	local t3 = {}
	local t4 = {}
	local t5 = {}

	local function traverse(p1, s1: string?, s2: string) -- line: 23
		-- upvalues: t3 (copy), t4 (copy), t5 (copy), traverse (copy)
		for v24, v25 in p1 do
			if v25.ClassName == "Bone" then
				t3[v24] = true

				if s1 == nil then
					if not t4[s2] then
						t4[s2] = {}
					end

					table.insert(t4[s2], v24)
				else
					if not t5[s1] then
						t5[s1] = {}
					end

					table.insert(t5[s1], v24)
				end

				if v25._children then
					traverse(v25._children, v24, s2)
				end
			end
		end
	end

	for _, v14 in t2 do
		traverse(R15plusUtils.getAvatarBoneSchema(v14), nil, v14)
	end

	u5 = t4
	u6 = t5
	u7 = t3
end

function t1.hasBoneFolders(p2) -- line: 59
	-- upvalues: t1 (copy)
	for _, descendant in p2:GetDescendants() do
		if descendant:IsA("Folder") and t1.isBoneFolderName(descendant.Name) then
			return true
		end
	end

	return false
end
function t1.isBoneFolderName(s3: string) -- line: 68
	-- upvalues: ensureCaches (copy), u7 (ref)
	ensureCaches()

	return u7[s3] == true
end
function t1.getRootBoneNamesForBodyPart(s4: string) -- line: 73
	-- upvalues: ensureCaches (copy), u5 (ref)
	ensureCaches()

	return u5[s4] or {}
end
function t1.getChildBoneNames(s5: string) -- line: 78
	-- upvalues: ensureCaches (copy), u6 (ref)
	ensureCaches()

	return u6[s5] or {}
end

return t1
