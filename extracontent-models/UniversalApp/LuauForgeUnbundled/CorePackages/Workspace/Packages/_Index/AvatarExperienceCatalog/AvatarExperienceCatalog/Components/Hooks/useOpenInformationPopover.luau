local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").useNavigation
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").Enums.AvatarScreen
local openInfoPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/DiscoveryRouting").OpenInfoPeekView
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Responsive").useIsSpatial

local function useOpenInformationPopover(value, value2)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = useIsSpatial()

	local v8 = useLocalization({ gotIt = "Feature.Avatar.Action.GotIt" })

	local v9 = React.useCallback(function()
		if v7 then
			v6.navigate(avatarScreen.GenericPrompt, {
				titleText = value,
				bodyText = value2,
				buttonText = v8.gotIt
			})
		else
			v5(openInfoPeekView(value or "", value2 or ""))
		end
	end, { value, value2, v8.gotIt, v5, v6, v7 })

	if value2 == nil or value2 == "" then
		return nil
	end

	return v9
end

return useOpenInformationPopover
