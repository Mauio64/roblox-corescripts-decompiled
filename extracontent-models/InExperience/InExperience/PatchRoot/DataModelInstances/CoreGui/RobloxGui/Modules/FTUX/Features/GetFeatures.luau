local ParentParent = script.Parent.Parent
local Features = ParentParent.Features
local PlatformEnum = require(ParentParent.Enums.PlatformEnum)
local EnableSafetyBubbleDummy = require(Features.EnableSafetyBubbleDummy)

function GetFeatures(p1) -- line: 8
	-- upvalues: PlatformEnum (copy), EnableSafetyBubbleDummy (copy)
	if p1 == PlatformEnum.QuestVR then
		EnableSafetyBubbleDummy()
	end
end

return GetFeatures
