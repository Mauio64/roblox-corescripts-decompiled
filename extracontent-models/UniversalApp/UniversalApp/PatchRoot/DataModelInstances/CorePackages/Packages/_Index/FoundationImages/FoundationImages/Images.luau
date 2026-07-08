local scriptParent = script.Parent
local GetImageSetData = require(scriptParent.Generated.GetImageSetData)
local FallbackImages = require(scriptParent.Generated.FallbackImages)

require(scriptParent.ImagesTypes)

local getResolutionScale = require(scriptParent.getResolutionScale)
local CorePackages = script:FindFirstAncestor("CorePackages")
local v6, v7 = GetImageSetData((getResolutionScale()))
local scriptParentParent = scriptParent.Parent
local uiblox = require(scriptParentParent.BuilderIcons).Migration.uiblox
local whitelistedIconAssets = require(scriptParent.whitelistedIconAssets)

local function getPackagePath() -- line: 20
	-- upvalues: scriptParent (copy), CorePackages (copy)
	local v20 = scriptParent

	if CorePackages == nil then
		return nil
	end

	local t1 = {}

	while v20 ~= nil and v20 ~= CorePackages do
		table.insert(t1, 1, v20.Name)
		v20 = v20.Parent
	end

	return "LuaPackages/" .. table.concat(t1, "/")
end
local function getImagePath(s1: string?, s2: string) -- line: 38
	-- upvalues: FallbackImages (copy)
	if s1 == nil then
		return FallbackImages[s2]
	end

	return string.format("rbxasset://%s/SpriteSheets/%s.png", s1, s2)
end

local v13 = getPackagePath()
local t2 = {}

for v15, v16 in v6 do
	if whitelistedIconAssets[v15] ~= nil or not uiblox[v15] then
		assert(typeof(v16) == "table", "invalid sourceData from GetImageSetData for scale " .. tostring(v7))

		local t3 = {}

		for v18, v19 in v16 do
			if v18 == "ImageSet" then
				t3.Image = if v13 ~= nil then string.format("rbxasset://%s/SpriteSheets/%s.png", v13, v19) else FallbackImages[v19]
			else
				t3[v18] = v19
			end
		end

		t2[v15] = t3
	end
end

setmetatable(t2, {
	__index = function(p1, p2) -- line: 70
		-- upvalues: uiblox (copy)
		if uiblox[p2] then
			local t4 = {
				ImageRectOffset = Vector2.new(0, 0),
				ImageRectSize = Vector2.new(0, 0),
				Image = p2
			}

			p1[p2] = t4

			return t4
		end

		error(("%q is not a valid member of Images"):format((tostring(p2))), 2)
	end
})

return t2
