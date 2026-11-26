local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module = require("@luauforge/deferred/gQO")
local UIBlox = require(CorePackages.Packages.UIBlox)
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize

return (React.forwardRef(function(p2, p3)
	local v5 = useLocalization({ buttonText = "Feature.Catalog.Heading.QuickMenu" })
	local v6 = module()

	return React.createElement(button, {
		buttonRef = p3,
		NextSelectionRight = p2.NextSelectionRight,
		text = v5.buttonText,
		onActivated = v6,
		buttonType = buttonType.Secondary,
		standardSize = standardButtonSize.Small,
		fitContent = true
	})
end))
