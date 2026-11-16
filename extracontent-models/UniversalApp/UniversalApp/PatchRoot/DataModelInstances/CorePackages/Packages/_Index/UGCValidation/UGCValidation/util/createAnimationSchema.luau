local parent = script.Parent.Parent
local Constants = require(parent.Constants)

local function createAnimationEntry(flag: boolean?, flag2: boolean?)
	local animationEntry = { ClassName = "Animation" }

	if flag then
		animationEntry._optional = true
	end

	if flag2 then
		animationEntry._children = {
			{ Name = "Weight", ClassName = "NumberValue", _optional = true }
		}
	end

	return animationEntry
end

local function createStringValueWithAnimations(name: string, p: number, flag: boolean?)
	local children = {}
	table.insert(children, createAnimationEntry(false, flag))

	if p > 1 then
		table.insert(children, createAnimationEntry(true, flag))
	end

	return { Name = name, ClassName = "StringValue", _children = children }
end

local function createAnimationSchema(p)
	local v = Constants.ANIMATION_ASSET_INFO[p]
	assert(v, `No ANIMATION_ASSET_INFO for {p}`)

	local children = {}

	if p == Enum.AssetType.IdleAnimation then
		table.insert(children, createStringValueWithAnimations("idle", 2, true))
	else
		for _, stringValueName in v.stringValueNames do
			local children2 = {}
			table.insert(children2, { ClassName = "Animation" })

			table.insert(children, {
				Name = stringValueName,
				ClassName = "StringValue",
				_children = children2
			})
		end
	end

	return { Name = "R15Anim", ClassName = "Folder", _children = children }
end

return createAnimationSchema
