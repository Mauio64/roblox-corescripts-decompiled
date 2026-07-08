local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local getStandardSizeAvatarHeadShotRbxthumb = require(Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb

return function(p1) -- line: 7
	-- upvalues: Cryo (copy), getStandardSizeAvatarHeadShotRbxthumb (copy)
	return Cryo.List.map(p1, function(p2) -- line: 8
		-- upvalues: getStandardSizeAvatarHeadShotRbxthumb (copy)
		return getStandardSizeAvatarHeadShotRbxthumb((tostring(p2)))
	end)
end
