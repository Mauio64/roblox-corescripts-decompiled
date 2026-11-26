local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/dGJ")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local switchTab = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SwitchTab

return {
	isAvatarRoute = function(p2): boolean
		return p2 == avatarScreen.AvatarExperienceRoot or p2 == switchTab.AvatarExperienceTab
	end,
	isAvatarExperienceWrapper = function(p2): boolean
		return p2.name == module.AvatarExperienceWrapper
			or p2.name == module.AvatarExperienceWrapperTransparent
	end,
	opaquePageFromRoute = function(list)
		for i = #list, 1, -1 do
			local item = list[i]
			local v5 = module2[item.name]

			if v5 == nil or not v5.renderUnderlyingPage then
				return item
			end
		end

		return { name = avatarScreen.None }
	end
}
