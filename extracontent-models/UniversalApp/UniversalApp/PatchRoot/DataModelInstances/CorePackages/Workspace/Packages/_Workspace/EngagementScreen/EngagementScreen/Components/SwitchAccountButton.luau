local Parent = script:FindFirstAncestor("EngagementScreen").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: useLocalization (copy), React (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v9 = useLocalization({
		switchAccounts = {
			"CommonUI.Features.Label.EngagementScreen.SwitchAccounts",
			platform = "Console"
		}
	})

	return React.createElement(Button, {
		fitContent = true,
		buttonType = ButtonType.Secondary,
		text = v9.switchAccounts,
		fontStyle = t1.fontStyle,
		standardSize = StandardButtonSize.Regular,
		layoutOrder = t1.layoutOrder,
		onActivated = t1.onActivated
	})
end
