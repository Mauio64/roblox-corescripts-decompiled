local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/deferred/ggG")
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal

local function useCloseFiltersSignal()
	local v5 = React.useContext(module)[avatarScreen.SortAndFilters .. "-closeSignal"]

	if v5.current == nil then
		v5.current = signal.new()
	end

	return v5.current
end

return useCloseFiltersSignal
