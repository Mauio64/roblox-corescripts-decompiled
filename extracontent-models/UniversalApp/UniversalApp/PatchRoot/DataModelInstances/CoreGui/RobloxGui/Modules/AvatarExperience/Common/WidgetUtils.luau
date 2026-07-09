local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants

return {
	getEntryButtonWidgetActivationFunc = function(p1, p2, p3) -- line: 8
		-- upvalues: WidgetConstants (copy), AvatarScreen (copy)
		if p1 == WidgetConstants.Types.ProfilePictureEditorWidget then
			return function() -- line: 10
				-- upvalues: p2 (copy), AvatarScreen (copy), p3 (copy)
				p2.navigate(AvatarScreen.ProfilePictureEditorEmotes, {
					prevNavPage = AvatarScreen.Catalog,
					prevNavHistory = p3
				})
			end
		end

		return nil
	end
}
