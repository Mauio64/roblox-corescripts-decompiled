local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useTokens = Foundation.Hooks.useTokens
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local PhotoboothCategories = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth).Enums.PhotoboothCategories
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)

require(Modules.AvatarExperience.Photobooth.Components.Scenes.PhotoboothSceneData)

local FFlagAXPhotoboothBugBashFixes = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXPhotoboothBugBashFixes

local function usePhotoboothAnimationsProps(uDim2: UDim2, p1: ((...any) -> ...any)?) -- line: 30
	-- upvalues: useTokens (copy), useSelector (copy), selectIsPortrait (copy), React (copy), PhotoboothCategories (copy), FFlagAXPhotoboothBugBashFixes (copy)
	local v14 = useTokens()
	local v15 = useSelector(selectIsPortrait)
	local v16, v17 = React.useState(PhotoboothCategories.All)
	local v18 = React.useCallback(function(s1: string) -- line: 36
		-- upvalues: v16 (copy), v17 (copy), PhotoboothCategories (copy)
		if s1 == v16 then
			v17(PhotoboothCategories.All)

			return
		end

		v17(s1)
	end, { v16 })

	return {
		tokens = v14,
		isPortrait = v15,
		position = uDim2,
		animationFilter = v16,
		onAnimationFilterChanged = v18,
		onTileClicked = if not FFlagAXPhotoboothBugBashFixes then nil else p1
	}
end

return usePhotoboothAnimationsProps
