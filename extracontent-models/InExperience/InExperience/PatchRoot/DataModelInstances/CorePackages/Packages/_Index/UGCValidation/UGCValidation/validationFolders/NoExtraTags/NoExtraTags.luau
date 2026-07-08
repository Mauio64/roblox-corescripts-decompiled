local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local CollectionService = game:GetService("CollectionService")
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local t1 = {
	categories = Constants.AllAssetUploadCategories,
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	expectedFailures = {
		"Asset_EF_TaggedJacket",
		"Bundle_EF_BodyWithLLLTagged.LeftLeg"
	}
}

local function collectTaggedPaths(p1, t2: {[any]: any}) -- line: 16
	-- upvalues: CollectionService (copy)
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	for _, v13 in descendants do
		if #CollectionService:GetTags(v13) > 0 then
			table.insert(t2, v13:GetFullName())
		end
	end
end

function t1.run(p2, p3) -- line: 26
	-- upvalues: collectTaggedPaths (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), ErrorSourceStrings (copy)
	local t3 = {}

	collectTaggedPaths(p3.rootInstance, t3)

	if getFFlagUGCValidateMigrateSchemaProperties() then
		local hsrAssets = p3.hsrAssets

		if type(hsrAssets) == "table" then
			for _, v19 in hsrAssets do
				if type(v19) == "table" then
					for _, v21 in v19 do
						collectTaggedPaths(v21, t3)
					end
				end
			end
		end
	end

	if #t3 > 0 then
		p2:fail(ErrorSourceStrings.Keys.InstanceTagsFound, {
			ProblematicDescendantPaths = table.concat(t3, ", ")
		})
	end
end

return t1
