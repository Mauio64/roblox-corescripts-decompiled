local CollectionService = game:GetService("CollectionService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }
t1.fflag = getFFlagUGCValidateMigrateCurveAnim
t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function isTimeStamp(s1: string) -- line: 26
	if #s1 > 30 then
		return false
	end

	return string.match(s1, "^[0-9]+$") ~= nil
end

function t1.run(p1, p2) -- line: 34
	-- upvalues: CollectionService (copy), ErrorSourceStrings (copy)
	local g22 = nil

	for _, v13 in p2.curveAnimations do
		for _, child in v13:GetChildren() do
			local descendants = child:GetDescendants()

			table.insert(descendants, child)

			local t2 = {}

			for _, v19 in descendants do
				if #CollectionService:GetTags(v19) > 0 then
					table.insert(t2, v19:GetFullName())
				end
			end

			if #t2 > 0 then
				p1:fail(ErrorSourceStrings.Keys.InstanceTagsFound, {
					ProblematicDescendantPaths = table.concat(t2, ", ")
				})

				return
			end
		end

		local Tags = CollectionService:GetTags(v13)
		local v21 = #Tags

		if not (v21 > 0) then
			continue
		end

		repeat
			if g22 or v21 > 1 then
				g22 = false
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidTags)

				return
			end

			local v23 = Tags[1]

			if #v23 > 30 or string.match(v23, "^[0-9]+$") == nil then
				g22 = true
			end
		until not g22
	end
end

return t1
