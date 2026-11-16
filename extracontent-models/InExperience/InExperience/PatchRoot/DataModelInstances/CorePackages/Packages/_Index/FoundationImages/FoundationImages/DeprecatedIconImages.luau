local parent = script.Parent

local GetDeprecatedIconImageSetData = require(parent.Deprecated.GetDeprecatedIconImageSetData)
local StaticFallbackImages = require(parent.Deprecated.StaticFallbackImages)

local getResolutionScale = require(parent.getResolutionScale)

local deprecatedIconImageSetData = GetDeprecatedIconImageSetData((getResolutionScale()))

local parent2 = parent.Parent
local BuilderIcons = require(parent2.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local whitelistedIconAssets = require(parent.whitelistedIconAssets)

local DeprecatedIconImages = {}

for k, v in deprecatedIconImageSetData do
	if not (uiblox[k] and whitelistedIconAssets[k] == nil) then
		continue
	end

	local v2 = {}

	for k2, v3 in v do
		if k2 == "ImageSet" then
			v2.Image = StaticFallbackImages[v3]
		else
			v2[k2] = v3
		end
	end

	DeprecatedIconImages[k] = v2
end

return DeprecatedIconImages
