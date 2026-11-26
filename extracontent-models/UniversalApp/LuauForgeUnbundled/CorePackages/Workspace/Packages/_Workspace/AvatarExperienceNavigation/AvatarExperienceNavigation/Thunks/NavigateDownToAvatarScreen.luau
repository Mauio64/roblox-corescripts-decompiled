local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/Cryo")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/RobloxAppEnums").AppPage
local AvatarScreenProperties = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/AvatarScreenProperties")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/RobloxAppNavigation").NavigationCommands else nil

local function NavigateDownToAvatarScreen(p2, p3, options)
	local v5 = AvatarScreenProperties[p2]
	local isTransparent = v5 and v5.isTransparent
	return function(object)
		local v6 = {
			name = isTransparent and appPage.AvatarExperienceWrapperTransparent or appPage.AvatarExperienceWrapper,
			detail = p3,
			extraProps = {
				routeName = p2,
				params = Cryo.Dictionary.join(options or {}, { detail = p3 })
			}
		}

		if not fFlagSignalsNavP3Dispatch then
			return object:dispatch(navigateDown(v6))
		end

		navigationCommands.down(navigationCommands.fromLegacyPage(v6))
	end
end

return NavigateDownToAvatarScreen
