local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local HeroUnitSpotlightCardView = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitSpotlightCardView)
local useHeroUnitSpotlightCardViewModel = require(Modules.AvatarExperience.Common.Components.Widgets.useHeroUnitSpotlightCardViewModel)

local function HeroUnitSpotlightCard(p1) -- line: 14
	-- upvalues: useHeroUnitSpotlightCardViewModel (copy), React (copy), HeroUnitSpotlightCardView (copy)
	local v8 = useHeroUnitSpotlightCardViewModel(p1)

	return React.createElement(HeroUnitSpotlightCardView, v8)
end

return HeroUnitSpotlightCard
