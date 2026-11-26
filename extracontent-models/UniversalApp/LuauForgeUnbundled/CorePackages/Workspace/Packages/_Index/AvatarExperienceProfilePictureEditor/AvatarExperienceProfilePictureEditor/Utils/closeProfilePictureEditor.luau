local fFlagAXPPEReturnToEntrySurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagAXPPEReturnToEntrySurface
local entrySurface = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/entrySurface")

local function closeProfilePictureEditor(data)
	if not data then
		return
	end

	local resolved, v5 = entrySurface.resolve(data)

	if resolved and data.navigate then
		if fFlagAXPPEReturnToEntrySurface then
			entrySurface.park(data, resolved)
		end

		if v5 then
			data.navigate(resolved, v5)
		else
			data.navigate(resolved)
		end
	elseif data.goBack then
		data.goBack()
	elseif data.pop then
		data.pop()
	end
end

return closeProfilePictureEditor
