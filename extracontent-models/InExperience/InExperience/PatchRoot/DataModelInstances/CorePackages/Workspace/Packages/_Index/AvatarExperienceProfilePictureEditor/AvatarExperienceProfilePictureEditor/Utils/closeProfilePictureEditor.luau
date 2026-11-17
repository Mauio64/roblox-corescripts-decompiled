local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface
local entrySurface = require(script.Parent.entrySurface)

local function closeProfilePictureEditor(data)
	if not data then
		return
	end

	local resolved, v = entrySurface.resolve(data)

	if resolved and data.navigate then
		if FFlagAXPPEReturnToEntrySurface then
			entrySurface.park(data, resolved)
		end

		if v then
			data.navigate(resolved, v)
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
