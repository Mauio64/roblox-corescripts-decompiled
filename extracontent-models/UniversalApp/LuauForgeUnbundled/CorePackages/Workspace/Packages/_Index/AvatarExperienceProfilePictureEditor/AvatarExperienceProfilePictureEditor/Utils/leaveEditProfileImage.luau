local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")
local closeProfilePictureEditor = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/closeProfilePictureEditor")
local entrySurface = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/entrySurface")

local function readCallback(p2)
	if p2.getParam == nil then
		return nil
	end

	local param = p2.getParam("callback")

	if typeof(param) == "string" and param ~= "" then
		return param
	end

	return nil
end

local function leaveEditProfileImage(p2, callback)
	local v5

	if p2.getParam ~= nil then
		v5 = p2.getParam("callback")

		if typeof(v5) ~= "string" or v5 == "" then
			v5 = nil
		end
	end

	if callback == nil or v5 == nil then
		closeProfilePictureEditor(p2)
		return
	end

	if p2.setParams ~= nil then
		p2.setParams({ callback = "", mode = Enums.EditProfileImageMode.Default })
	end

	entrySurface.park(p2, (entrySurface.resolve(p2)))

	if not callback(v5) then
		closeProfilePictureEditor(p2)
	end
end

return leaveEditProfileImage
