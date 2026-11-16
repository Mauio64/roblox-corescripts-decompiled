local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

local MomentType = require(MomentsCreation.Enums.MomentType)

return function(p): boolean
	return type(p) == "table" and p.MomentType == MomentType.Avatar
end
