local scriptParent = script.Parent
local GetDeprecatedIconImageSetData = require(scriptParent.Deprecated.GetDeprecatedIconImageSetData)
local StaticFallbackImages = require(scriptParent.Deprecated.StaticFallbackImages)
local v4 = GetDeprecatedIconImageSetData((require(scriptParent.getResolutionScale)()))
local scriptParentParent = scriptParent.Parent
local uiblox = require(scriptParentParent.BuilderIcons).Migration.uiblox
local whitelistedIconAssets = require(scriptParent.whitelistedIconAssets)
local t1 = {}

for v9, v10 in v4 do
	if uiblox[v9] and whitelistedIconAssets[v9] == nil then
		local t2 = {}

		for v12, v13 in v10 do
			if v12 == "ImageSet" then
				t2.Image = StaticFallbackImages[v13]
			else
				t2[v12] = v13
			end
		end

		t1[v9] = t2
	end
end

return t1
