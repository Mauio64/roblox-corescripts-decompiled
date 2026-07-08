local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local getFFlagUGCValidationAnimationPackFolderStructure = require(ParentParent.flags.getFFlagUGCValidationAnimationPackFolderStructure)

local function createAnimationEntry(b1: boolean?, b2: boolean?) -- line: 6
	local t1 = {
		ClassName = "Animation"
	}

	if b1 then
		t1._optional = true
	end

	if b2 then
		t1._children = {{
			Name = "Weight",
			ClassName = "NumberValue",
			_optional = true
		}}
	end

	return t1
end
local function createStringValueWithAnimations(s1: string, n1: number, b3: boolean?) -- line: 25
	-- upvalues: createAnimationEntry (copy)
	local t2 = {}

	table.insert(t2, (createAnimationEntry(false, b3)))

	if n1 > 1 then
		table.insert(t2, (createAnimationEntry(true, b3)))
	end

	return {
		ClassName = "StringValue",
		Name = s1,
		_children = t2
	}
end
local function createAnimationSchema(p1, p2) -- line: 44
	-- upvalues: Constants (copy), createStringValueWithAnimations (copy), getFFlagUGCValidationAnimationPackFolderStructure (copy)
	local v16 = Constants.ANIMATION_ASSET_INFO[p1]

	assert(v16, `No ANIMATION_ASSET_INFO for { p1 }`)

	local t3 = {}

	if p1 == Enum.AssetType.IdleAnimation then
		table.insert(t3, (createStringValueWithAnimations("idle", 2, true)))
	else
		for _, v19 in v16.stringValueNames do
			local t4 = {}

			table.insert(t4, {
				ClassName = "Animation"
			})
			table.insert(t3, {
				ClassName = "StringValue",
				Name = v19,
				_children = t4
			})
		end
	end

	local t5 = {
		Name = "R15Anim",
		ClassName = "Folder",
		_children = t3
	}

	if getFFlagUGCValidationAnimationPackFolderStructure() and p2 and p2.Name == "R15Anim" then
		return t5
	end

	return {
		ClassName = "Model",
		Name = v16.modelName,
		_children = { t5 }
	}
end

return createAnimationSchema
