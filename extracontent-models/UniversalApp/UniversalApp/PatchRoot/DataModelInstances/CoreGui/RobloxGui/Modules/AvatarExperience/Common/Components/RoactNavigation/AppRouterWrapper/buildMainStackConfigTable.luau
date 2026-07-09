local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local RedirectToAppRouterScreen = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.RedirectToAppRouterScreen)
local RedirectToAvatarScreen = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.RedirectToAvatarScreen)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarPromptDescriptors = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarPromptDescriptors)
local AvatarExperienceWrapperScreens = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.AvatarExperienceWrapperScreens)
local withAppRouterParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.withAppRouterParams)

local function buildMainStackConfigTable(p1) -- line: 31
	-- upvalues: AvatarExperienceWrapperScreens (copy), withAppRouterParams (copy), AvatarScreen (copy), RedirectToAppRouterScreen (copy), RedirectToAvatarScreen (copy), AvatarPromptDescriptors (copy), Cryo (copy)
	local t1 = {}

	if not AvatarExperienceWrapperScreens[p1] then
		error("Initial route is not supported by AvatarExperienceWrapper: " .. tostring(p1))
	end

	local v13 = withAppRouterParams(AvatarExperienceWrapperScreens[p1])

	local function addScreen(p2, p3) -- line: 39
		-- upvalues: t1 (copy)
		if not t1[p2] then
			t1[p2] = p3
		end
	end
	local function removeScreen(p4) -- line: 45
		-- upvalues: t1 (copy)
		t1[p4] = nil
	end

	for _, v17 in AvatarScreen do
		local v18 = AvatarExperienceWrapperScreens[v17] ~= nil and RedirectToAppRouterScreen or RedirectToAvatarScreen

		if not t1[v17] then
			t1[v17] = v18
		end
	end

	for _, v20 in AvatarPromptDescriptors do
		for v21, _ in v20 do
			t1[v21] = nil
		end
	end

	t1[AvatarScreen.AvatarExperienceMainStackNavigator] = nil
	t1[p1] = nil

	return (Cryo.List.join({{
		[p1] = v13
	}}, Cryo.List.map(Cryo.Dictionary.keys(t1), function(p5) -- line: 75
		-- upvalues: t1 (copy)
		return {
			[p5] = t1[p5]
		}
	end)))
end

return buildMainStackConfigTable
