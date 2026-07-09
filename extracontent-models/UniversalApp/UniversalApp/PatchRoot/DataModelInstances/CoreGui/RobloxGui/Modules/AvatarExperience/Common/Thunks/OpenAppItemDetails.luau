local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = script:FindFirstAncestor("Modules")
local NavigateDownToAvatarScreen = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.NavigateDownToAvatarScreen)
local FFlagAXFixPurchaseSurfaceLogging = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXFixPurchaseSurfaceLogging

return function(s1: string, s2: string, _: boolean?, b2: boolean?, n1: number?) -- line: 15
	-- upvalues: FFlagAXFixPurchaseSurfaceLogging (copy), NavigateDownToAvatarScreen (copy), AvatarScreen (copy)
	return function(p1) -- line: 16
		-- upvalues: s2 (copy), s1 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), b2 (copy), n1 (copy), NavigateDownToAvatarScreen (copy), AvatarScreen (copy)
		local v12 = s2 .. s1
		local t1 = {
			mountAsFullView = true,
			mountAnimation = false,
			itemId = s1,
			itemType = s2,
			fromProfile = not FFlagAXFixPurchaseSurfaceLogging or b2,
			fromSurface = if not FFlagAXFixPurchaseSurfaceLogging then nil else n1,
			itemDetailsPeekViewRefs = {}
		}

		p1:dispatch(NavigateDownToAvatarScreen(AvatarScreen.ItemDetails, v12, t1))
	end
end
