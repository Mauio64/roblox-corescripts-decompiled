local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)

return function(s1: string, s2: string) -- line: 4
	-- upvalues: Constants (copy)
	local PROFILE_THUMBNAIL_DATAType = nil
	local PROFILE_THUMBNAIL_DATASize = nil

	if s2 == "Profile" or s2 == "Chat" then
		PROFILE_THUMBNAIL_DATAType = Constants.PROFILE_THUMBNAIL_DATA.Type
		PROFILE_THUMBNAIL_DATASize = Constants.PROFILE_THUMBNAIL_DATA.Size
	elseif s2 == "ExperienceDetails" then
		PROFILE_THUMBNAIL_DATAType = Constants.EXP_THUMBNAIL_DATA.Type
		PROFILE_THUMBNAIL_DATASize = Constants.EXP_THUMBNAIL_DATA.Size
	elseif s2 == "Item" then
		PROFILE_THUMBNAIL_DATAType = Constants.ITEM_THUMBNAIL_DATA.Type
		PROFILE_THUMBNAIL_DATASize = Constants.ITEM_THUMBNAIL_DATA.Size
	end

	if PROFILE_THUMBNAIL_DATAType then
		return string.format("rbxthumb://type=%s&id=%s&w=%d&h=%d", PROFILE_THUMBNAIL_DATAType, s1, PROFILE_THUMBNAIL_DATASize, PROFILE_THUMBNAIL_DATASize)
	end

	return nil
end
