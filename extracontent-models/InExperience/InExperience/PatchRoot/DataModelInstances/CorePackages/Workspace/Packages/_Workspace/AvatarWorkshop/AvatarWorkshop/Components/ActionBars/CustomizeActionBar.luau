local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ActionBar = require(script.Parent.ActionBar)

local function CustomizeActionBar()
	local v = useLocalization({ continue = "Feature.AvatarSwitcher.Action.Continue" })

	return React.createElement(ActionBar, {
		actions = {
			{
				key = "ContinueButton",
				text = v.continue,
				onActivated = function() end,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				testId = "avatar-workshop-continue-button"
			}
		}
	})
end

return CustomizeActionBar
