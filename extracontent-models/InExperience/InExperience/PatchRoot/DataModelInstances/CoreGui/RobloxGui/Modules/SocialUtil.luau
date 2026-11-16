local CorePackages = game:GetService("CorePackages")

local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib2 = require(CorePackages.Workspace.Packages.UserLib)
local Constants = UserLib2.Utils.Constants

local Size100x100 = Enum.ThumbnailSize.Size100x100
local AvatarThumbnail = Enum.ThumbnailType.AvatarThumbnail
return {
	GetPlayerImage = function(p, p2, p3, _)
		p2 = p2 or Size100x100
		p3 = p3 or AvatarThumbnail

		if p3 == Enum.ThumbnailType.HeadShot or p3 == Enum.ThumbnailType.AvatarBust then
			local v = p2 == Enum.ThumbnailSize.Size48x48 and 48 or p2 == Enum.ThumbnailSize.Size60x60 and 60 or 150

			return getRbxthumbWithTypeSizeAndOptions(p, Constants.RbxthumbTypes.AvatarHeadShot, v)
		end

		if p3 ~= Enum.ThumbnailType.AvatarThumbnail then
			return "ThumbnailErrorForSocialUtil.GetPlayerImage"
		end

		local v

		if
			p2 == Enum.ThumbnailSize.Size48x48
			or p2 == Enum.ThumbnailSize.Size60x60
			or p2 == Enum.ThumbnailSize.Size100x100
		then
			v = 100
		elseif
			p2 == Enum.ThumbnailSize.Size150x150
			or p2 == Enum.ThumbnailSize.Size180x180
			or p2 == Enum.ThumbnailSize.Size352x352
		then
			v = 352
		elseif p2 == Enum.ThumbnailSize.Size420x420 then
			v = 720
		else
			v = 0
		end

		return getRbxthumbWithTypeSizeAndOptions(p, Constants.RbxthumbTypes.Avatar, v)
	end
}
