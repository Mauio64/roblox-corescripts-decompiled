local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(Parent.Navigation).useNavigation
local AvatarScreen = require(Parent.AvatarExperienceNavigation).Enums.AvatarScreen
local OpenInfoPeekView = require(Parent.DiscoveryRouting).OpenInfoPeekView
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useIsSpatial = require(Parent.Responsive).useIsSpatial

local function useOpenInformationPopover(s1: string?, s2: string?) -- line: 41
	-- upvalues: useDispatch (copy), useNavigation (copy), useIsSpatial (copy), useLocalization (copy), React (copy), AvatarScreen (copy), OpenInfoPeekView (copy)
	local v12 = useDispatch()
	local v13 = useNavigation()
	local v14 = useIsSpatial()
	local v15 = useLocalization({
		gotIt = "Feature.Avatar.Action.GotIt"
	})
	local v16 = React.useCallback(function() -- line: 52
		-- upvalues: v14 (copy), v13 (copy), AvatarScreen (copy), s1 (copy), s2 (copy), v15 (copy), v12 (copy), OpenInfoPeekView (copy)
		if v14 then
			v13.navigate(AvatarScreen.GenericPrompt, {
				titleText = s1,
				bodyText = s2,
				buttonText = v15.gotIt
			})

			return
		end

		v12(OpenInfoPeekView(s1 or "", s2 or ""))
	end, {
		s1,
		s2,
		v15.gotIt,
		v12,
		v13,
		v14
	})

	if s2 == nil or s2 == "" then
		return nil
	end

	return v16
end

return useOpenInformationPopover
