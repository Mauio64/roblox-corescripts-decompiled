local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useOpenQuickMenuCallback = require(Modules.AvatarExperience.Common.Hooks.useOpenQuickMenuCallback)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 17
	-- upvalues: useLocalization (copy), useOpenQuickMenuCallback (copy), React (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v13 = useLocalization({
		buttonText = "Feature.Catalog.Heading.QuickMenu"
	})
	local v14 = useOpenQuickMenuCallback()

	return React.createElement(Button, {
		fitContent = true,
		buttonRef = p1,
		NextSelectionRight = t1.NextSelectionRight,
		text = v13.buttonText,
		onActivated = v14,
		buttonType = ButtonType.Secondary,
		standardSize = StandardButtonSize.Small
	})
end))
