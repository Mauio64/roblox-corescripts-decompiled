local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local SharedFlags = require(parent.SharedFlags)
local FFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface

local function resolveEntrySurface(data) -- 1 equivalent call inferred from this helper
	if not data.getParam then
		return nil, nil
	end

	local param = data.getParam("entryOrigin")

	if param and param.screenName then
		return param.screenName, param.screenParams
	end

	return data.getParam("prevNavPage"), nil
end

local function closeProfilePictureEditor(data)
	if not data then
		return
	end

	local entrySurface, v = resolveEntrySurface(data) -- inferred equivalent call

	if entrySurface and data.navigate then
		if FFlagAXPPEReturnToEntrySurface then
			local navigate = data.navigate
			local v2

			if entrySurface == AvatarScreen.AvatarExperienceLandingPage then
				v2 = AvatarScreen.AvatarExperienceLandingPage
			else
				v2 = AvatarScreen.Catalog
			end

			navigate(v2)
		end

		if v then
			data.navigate(entrySurface, v)
		else
			data.navigate(entrySurface)
		end
	elseif data.goBack then
		data.goBack()
	elseif data.pop then
		data.pop()
	end
end

return closeProfilePictureEditor
