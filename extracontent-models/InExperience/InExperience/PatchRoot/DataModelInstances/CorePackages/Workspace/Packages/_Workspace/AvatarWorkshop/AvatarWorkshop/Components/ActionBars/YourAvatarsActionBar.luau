local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Screens = require(AvatarWorkshop.Navigation.Screens)
local useNavigation = require(AvatarWorkshop.Hooks.useNavigation)
local ActionBar = require(script.Parent.ActionBar)

local function YourAvatarsActionBar()
	local v = useNavigation()
	local v2 = useLocalization({
		continue = "Feature.AvatarSwitcher.Action.Continue",
		editAvatar = "Feature.AvatarWorkshop.Action.EditAvatar"
	})

	local onActivated = React.useCallback(function()
		v.navigate(Screens.Workshop.Customize)
	end, { v })

	return React.createElement(ActionBar, {
		actions = {
			{
				key = "ContinueButton",
				text = v2.continue,
				onActivated = function() end,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				testId = "avatar-workshop-continue-button"
			},
			{
				key = "EditAvatarButton",
				text = v2.editAvatar,
				onActivated = onActivated,
				variant = Foundation.Enums.ButtonVariant.Standard,
				testId = "avatar-workshop-edit-avatar-button"
			}
		}
	})
end

return YourAvatarsActionBar
