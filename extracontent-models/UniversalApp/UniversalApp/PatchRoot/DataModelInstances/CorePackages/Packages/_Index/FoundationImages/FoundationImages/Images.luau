local parent = script.Parent
local GetImageSetData = require(parent.Generated.GetImageSetData)
local FallbackImages = require(parent.Generated.FallbackImages)

require(parent.ImagesTypes)
local getResolutionScale = require(parent.getResolutionScale)

local CorePackages = game:GetService("CorePackages")
local v, v2 = GetImageSetData((getResolutionScale()))

local parent2 = parent.Parent
local BuilderIcons = require(parent2.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local whitelistedIconAssets = require(parent.whitelistedIconAssets)

local function getStaticLuaAppsPackageDir(): nil | string -- 1 equivalent call inferred from this helper
	if CorePackages == nil then
		return nil
	end

	return "LuaPackages/Packages/_Index/FoundationImages/FoundationImages"
end

local function getImagePath(staticLuaAppsPackageDir: string?, p: string) -- 1 equivalent call inferred from this helper
	if staticLuaAppsPackageDir == nil then
		return FallbackImages[p]
	end

	return string.format("rbxasset://%s/SpriteSheets/%s.png", staticLuaAppsPackageDir, p)
end

local staticLuaAppsPackageDir = getStaticLuaAppsPackageDir() -- inferred equivalent call
local Images = {}

for k, v3 in v do
	if not (whitelistedIconAssets[k] ~= nil or not uiblox[k]) then
		continue
	end

	assert(typeof(v3) == "table", "invalid sourceData from GetImageSetData for scale " .. tostring(v2))
	local v4 = {}

	for k2, v5 in v3 do
		if k2 == "ImageSet" then
			v4.Image = getImagePath(staticLuaAppsPackageDir, v5) -- inferred equivalent call
		else
			v4[k2] = v5
		end
	end

	Images[k] = v4
end

setmetatable(Images, {
	__index = function(p, image)
		if not uiblox[image] then
			error(("%q is not a valid member of Images"):format((tostring(image))), 2)
			return
		end

		local v3 = {
			ImageRectOffset = Vector2.new(0, 0),
			ImageRectSize = Vector2.new(0, 0),
			Image = image
		}
		p[image] = v3
		return v3
	end
})

return Images
