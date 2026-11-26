local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEditProfileImageV2Enabled = SharedFlags.FFlagEditProfileImageV2Enabled
local fFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface
local widgetConstants = AvatarExperienceCatalog.WidgetConstants

return {
	getEntryButtonWidgetActivationFunc = function(p2, p3, p4)
		if p2 == widgetConstants.Types.ProfilePictureEditorWidget then
			return function()
				if fFlagEditProfileImageV2Enabled then
					p3.navigate(avatarScreen.EditProfileImage, {
						prevNavPage = avatarScreen.Catalog,
						prevNavHistory = p4,
						entryOrigin = fFlagAXPPEReturnToEntrySurface and {
							screenName = avatarScreen.Catalog
						} or nil
					})
				else
					p3.navigate(avatarScreen.ProfilePictureEditorEmotes, {
						prevNavPage = avatarScreen.Catalog,
						prevNavHistory = p4
					})
				end
			end
		end

		return nil
	end
}
