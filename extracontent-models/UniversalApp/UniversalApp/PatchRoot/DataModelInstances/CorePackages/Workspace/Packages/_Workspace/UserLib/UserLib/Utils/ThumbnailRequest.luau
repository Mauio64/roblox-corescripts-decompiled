local UserLib = script:FindFirstAncestor("UserLib")
local Constants = require(UserLib.Utils.Constants)
local t1 = {
	new = function() -- line: 17
		-- upvalues: Constants (copy)
		return {
			thumbnailType = Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
			thumbnailSize = Constants.RbxThumbnailSizes.Size150x150
		}
	end
}

function t1.fromData(p1, p2) -- line: 26
	-- upvalues: t1 (copy)
	local v6 = t1.new()

	v6.thumbnailType = p1
	v6.thumbnailSize = p2

	return v6
end

return t1
