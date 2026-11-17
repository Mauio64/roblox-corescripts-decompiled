local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local CurveAnimJointsAnimated = {}

CurveAnimJointsAnimated.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimJointsAnimated.requiredData = {
	ValidationEnums.SharedDataMember.curveAnimations,
	ValidationEnums.SharedDataMember.curveAnimComputedFrames
}

CurveAnimJointsAnimated.expectedFailures = {}
CurveAnimJointsAnimated.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function validateCurveAnimClip(object, curveAnimComputedFrame)
	local fullName = curveAnimComputedFrame.animation and curveAnimComputedFrame.animation:GetFullName()

	for _, track in curveAnimComputedFrame.tracks do
		if track.pos or track.rot then
			return
		end
	end

	object:fail(
		ErrorSourceStrings.Keys.CurveAnim_NoJointManipulation,
		{ animationName = fullName },
		curveAnimComputedFrame.animation
	)
end

function CurveAnimJointsAnimated.run(p, p2)
	for _, curveAnimComputedFrame in p2.curveAnimComputedFrames do
		validateCurveAnimClip(p, curveAnimComputedFrame)
	end
end

return CurveAnimJointsAnimated
