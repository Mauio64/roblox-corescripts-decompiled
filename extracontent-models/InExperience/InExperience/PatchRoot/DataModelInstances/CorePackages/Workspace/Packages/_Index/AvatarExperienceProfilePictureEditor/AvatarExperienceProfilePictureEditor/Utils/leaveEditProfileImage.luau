local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")

local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)
local closeProfilePictureEditor = require(script.Parent.closeProfilePictureEditor)
local entrySurface = require(script.Parent.entrySurface)

local function readCallback(p) -- 1 equivalent call inferred from this helper
	if p.getParam == nil then
		return nil
	end

	local param = p.getParam("callback")

	if typeof(param) == "string" and param ~= "" then
		return param
	end

	return nil
end

local function leaveEditProfileImage(p, callback)
	local param = readCallback(p) -- inferred equivalent call

	if callback == nil or param == nil then
		closeProfilePictureEditor(p)
		return
	end

	if p.setParams ~= nil then
		p.setParams({ callback = "", mode = Enums.EditProfileImageMode.Default })
	end

	entrySurface.park(p, (entrySurface.resolve(p)))

	if not callback(param) then
		closeProfilePictureEditor(p)
	end
end

return leaveEditProfileImage
