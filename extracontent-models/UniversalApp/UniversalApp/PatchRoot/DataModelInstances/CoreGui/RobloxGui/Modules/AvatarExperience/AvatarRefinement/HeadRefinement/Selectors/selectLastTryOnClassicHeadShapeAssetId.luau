local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local HeadShapeProperties = AvatarExperienceHeadRefinement.Enums.HeadShapeProperties
local selectLastTryOnClassicHeadShape = require(script.Parent.selectLastTryOnClassicHeadShape)

local function selectLastTryOnClassicHeadShapeAssetId(p1) -- line: 11
	-- upvalues: selectLastTryOnClassicHeadShape (copy), HeadShapeProperties (copy)
	local v8 = selectLastTryOnClassicHeadShape(p1)

	return v8 and (HeadShapeProperties[v8] and HeadShapeProperties[v8].assetId)
end

return selectLastTryOnClassicHeadShapeAssetId
