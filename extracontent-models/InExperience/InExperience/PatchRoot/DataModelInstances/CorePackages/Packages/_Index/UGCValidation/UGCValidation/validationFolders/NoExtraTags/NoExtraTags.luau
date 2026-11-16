local parent = script.Parent.Parent.Parent
local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local CollectionService = game:GetService("CollectionService")
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateNoExtraTagsRequireHsrAssets = require(parent.flags.getFFlagUGCValidateNoExtraTagsRequireHsrAssets)

local NoExtraTags = {}

NoExtraTags.categories = Constants.AllAssetUploadCategories
local requiredData

if getFFlagUGCValidateNoExtraTagsRequireHsrAssets() then
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.hsrAssets }
else
	requiredData = { ValidationEnums.SharedDataMember.rootInstance }
end

NoExtraTags.requiredData = requiredData

NoExtraTags.expectedFailures = { "Asset_EF_TaggedJacket", "Bundle_EF_BodyWithLLLTagged.LeftLeg" }

local function collectTaggedPaths(folder, fullNames)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)

	for _, descendant in descendants do
		if #CollectionService:GetTags(descendant) > 0 then
			table.insert(fullNames, descendant:GetFullName())
		end
	end
end

function NoExtraTags.run(object, p)
	local v = {}
	collectTaggedPaths(p.rootInstance, v)

	if getFFlagUGCValidateNoExtraTagsRequireHsrAssets() then
		for _, hsrAsset in p.hsrAssets do
			for _, v2 in hsrAsset do
				collectTaggedPaths(v2, v)
			end
		end
	else
		local hsrAssets = p.hsrAssets

		if type(hsrAssets) == "table" then
			for _, hsrAsset in hsrAssets do
				if type(hsrAsset) ~= "table" then
					continue
				end

				for _, v2 in hsrAsset do
					collectTaggedPaths(v2, v)
				end
			end
		end
	end

	if #v > 0 then
		object:fail(ErrorSourceStrings.Keys.InstanceTagsFound, {
			ProblematicDescendantPaths = table.concat(v, ", ")
		})
	end
end

return NoExtraTags
