local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.Foundation)

local ItemCardAnimationStateIndicator = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardAnimationStateIndicator

require(Modules.AvatarExperience.Common.Types)

local useCatalogItemCardAnimationIndicatorViewModel = require(script.Parent.useCatalogItemCardAnimationIndicatorViewModel)

local function CatalogItemCardAnimationIndicatorContainer(t1: {[any]: any}) -- line: 25
	-- upvalues: useCatalogItemCardAnimationIndicatorViewModel (copy), React (copy), ItemCardAnimationStateIndicator (copy)
	local v8 = useCatalogItemCardAnimationIndicatorViewModel(t1.bundleInfo)

	return React.createElement(ItemCardAnimationStateIndicator, {
		states = v8.states,
		ZIndex = t1.ZIndex,
		paddingTop = t1.paddingTop,
		paddingBottom = t1.paddingBottom,
		paddingLeft = t1.paddingLeft,
		paddingRight = t1.paddingRight
	})
end

return React.memo(CatalogItemCardAnimationIndicatorContainer)
