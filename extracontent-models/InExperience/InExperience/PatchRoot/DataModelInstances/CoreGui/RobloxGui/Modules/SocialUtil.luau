local t1 = {}
local CorePackages = game:GetService("CorePackages")
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local Size100x100 = Enum.ThumbnailSize.Size100x100
local AvatarThumbnail = Enum.ThumbnailType.AvatarThumbnail

function t1.GetPlayerImage(p1, p2, p3, _) -- line: 23
	-- upvalues: Size100x100 (copy), AvatarThumbnail (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy)
	if not p2 then
		p2 = Size100x100
	end

	if not p3 then
		p3 = AvatarThumbnail
	end

	local n1 = 0

	if p3 == Enum.ThumbnailType.HeadShot or p3 == Enum.ThumbnailType.AvatarBust then
		local v12 = if p2 ~= Enum.ThumbnailSize.Size48x48 then p2 ~= Enum.ThumbnailSize.Size60x60 and 150 or 60 else 48

		return getRbxthumbWithTypeSizeAndOptions(p1, Constants.RbxthumbTypes.AvatarHeadShot, v12)
	end

	if p3 == Enum.ThumbnailType.AvatarThumbnail then
		if p2 == Enum.ThumbnailSize.Size48x48 or p2 == Enum.ThumbnailSize.Size60x60 or p2 == Enum.ThumbnailSize.Size100x100 then
			n1 = 100
		elseif p2 == Enum.ThumbnailSize.Size150x150 or p2 == Enum.ThumbnailSize.Size180x180 or p2 == Enum.ThumbnailSize.Size352x352 then
			n1 = 352
		elseif p2 == Enum.ThumbnailSize.Size420x420 then
			n1 = 720
		end

		return getRbxthumbWithTypeSizeAndOptions(p1, Constants.RbxthumbTypes.Avatar, n1)
	end

	return "ThumbnailErrorForSocialUtil.GetPlayerImage"
end

return t1
