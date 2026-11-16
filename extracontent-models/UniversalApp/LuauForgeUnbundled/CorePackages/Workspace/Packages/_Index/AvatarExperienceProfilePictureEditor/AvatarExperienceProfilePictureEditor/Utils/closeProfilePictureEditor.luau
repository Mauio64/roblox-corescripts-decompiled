local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceNavigation").Enums.AvatarScreen
local fFlagAXPPEReturnToEntrySurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagAXPPEReturnToEntrySurface

local function resolveEntrySurface(p2)
	if not p2.getParam then
		return nil, nil
	end

	local param = p2.getParam("entryOrigin")

	if param and param.screenName then
		return param.screenName, param.screenParams
	end

	return p2.getParam("prevNavPage"), nil
end

local function closeProfilePictureEditor(data)
	if not data then
		return
	end

	local v5, screenParams

	if data.getParam then
		local param = data.getParam("entryOrigin")

		if param and param.screenName then
			v5 = param.screenName
			screenParams = param.screenParams
		else
			v5 = data.getParam("prevNavPage")
		end
	end

	if v5 and data.navigate then
		if fFlagAXPPEReturnToEntrySurface then
			local navigate = data.navigate
			local v6 = if v5 == avatarScreen.AvatarExperienceLandingPage then avatarScreen.AvatarExperienceLandingPage else avatarScreen.Catalog
			navigate(v6)
		end

		if screenParams then
			data.navigate(v5, screenParams)
		else
			data.navigate(v5)
		end
	elseif data.goBack then
		data.goBack()
	elseif data.pop then
		data.pop()
	end
end

return closeProfilePictureEditor
