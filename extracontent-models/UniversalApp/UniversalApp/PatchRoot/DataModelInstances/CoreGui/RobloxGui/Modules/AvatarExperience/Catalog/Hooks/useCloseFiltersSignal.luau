local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NamedRefsContext = require(Modules.AvatarExperience.Common.Context.NamedRefsContext)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal

local function useCloseFiltersSignal() -- line: 20
	-- upvalues: React (copy), NamedRefsContext (copy), AvatarScreen (copy), Signal (copy)
	local v8 = React.useContext(NamedRefsContext)[AvatarScreen.SortAndFilters .. "-closeSignal"]

	if v8.current == nil then
		v8.current = Signal.new()
	end

	return v8.current
end

return useCloseFiltersSignal
