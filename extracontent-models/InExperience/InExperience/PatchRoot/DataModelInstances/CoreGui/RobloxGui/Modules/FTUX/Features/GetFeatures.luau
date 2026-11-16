local parent = script.Parent.Parent
local features = parent.Features
local PlatformEnum = require(parent.Enums.PlatformEnum)

local EnableSafetyBubbleDummy = require(features.EnableSafetyBubbleDummy)

function GetFeatures(p)
	if p == PlatformEnum.QuestVR then
		EnableSafetyBubbleDummy()
	end
end

return GetFeatures
