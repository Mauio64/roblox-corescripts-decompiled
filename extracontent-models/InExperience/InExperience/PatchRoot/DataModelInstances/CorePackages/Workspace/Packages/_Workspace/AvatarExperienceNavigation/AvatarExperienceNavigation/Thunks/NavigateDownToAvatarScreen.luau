local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local parent = AvatarExperienceNavigation.Parent

local Cryo = require(parent.Cryo)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local AvatarScreenProperties = require(AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function NavigateDownToAvatarScreen(routeName: string, detail: string?, options)
	local avatarScreenProperty = AvatarScreenProperties[routeName]
	local isTransparent = avatarScreenProperty and avatarScreenProperty.isTransparent
	return function(object)
		local v = {
			name = isTransparent and AppPage.AvatarExperienceWrapperTransparent or AppPage.AvatarExperienceWrapper,
			detail = detail,
			extraProps = {
				routeName = routeName,
				params = Cryo.Dictionary.join(options or {}, { detail = detail })
			}
		}

		if not FFlagSignalsNavP3Dispatch then
			return object:dispatch(NavigateDown(v))
		end

		navigationCommands.down(navigationCommands.fromLegacyPage(v))
	end
end

return NavigateDownToAvatarScreen
