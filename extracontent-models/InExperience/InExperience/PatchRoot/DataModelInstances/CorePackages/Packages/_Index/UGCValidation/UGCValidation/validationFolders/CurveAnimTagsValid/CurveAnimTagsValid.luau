local CollectionService = game:GetService("CollectionService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local CurveAnimTagsValid = {}

CurveAnimTagsValid.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimTagsValid.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }

CurveAnimTagsValid.expectedFailures = {}
CurveAnimTagsValid.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function isTimeStamp(value: string): boolean -- 1 equivalent call inferred from this helper
	return not (#value > 30) and string.match(value, "^[0-9]+$") ~= nil
end

function CurveAnimTagsValid.run(object, p)
	for _, curveAnimation in p.curveAnimations do
		for _, folder in curveAnimation:GetChildren() do
			local descendants = folder:GetDescendants()
			table.insert(descendants, folder)

			local fullNames = {}

			for _, descendant in descendants do
				if #CollectionService:GetTags(descendant) > 0 then
					table.insert(fullNames, descendant:GetFullName())
				end
			end

			if #fullNames > 0 then
				object:fail(ErrorSourceStrings.Keys.InstanceTagsFound, {
					ProblematicDescendantPaths = table.concat(fullNames, ", ")
				})

				return
			end
		end

		local tags = CollectionService:GetTags(curveAnimation)
		local count = #tags

		if count > 0 then
			if not (count > 1) and isTimeStamp(tags[1]) then -- inferred equivalent call
				continue
			end

			object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidTags)
			break
		end
	end
end

return CurveAnimTagsValid
