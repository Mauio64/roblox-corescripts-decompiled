local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local DiscoveryRouting = require(parent.DiscoveryRouting)
local OpenInfoPeekView = DiscoveryRouting.OpenInfoPeekView
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial

local function useOpenInformationPopover(titleText: string?, value: string?)
	local v = useDispatch()
	local v2 = useNavigation()
	local v3 = useIsSpatial()

	local v4 = useLocalization({ gotIt = "Feature.Avatar.Action.GotIt" })

	local v5 = React.useCallback(function()
		if v3 then
			v2.navigate(AvatarScreen.GenericPrompt, {
				titleText = titleText,
				bodyText = value,
				buttonText = v4.gotIt
			})
		else
			v(OpenInfoPeekView(titleText or "", value or ""))
		end
	end, { titleText, value, v4.gotIt, v, v2, v3 })

	return if not (value == nil or value == "") then v5 else nil
end

return useOpenInformationPopover
