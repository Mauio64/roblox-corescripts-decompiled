local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/bundled/fzM")
local module2 = require("@luauforge/bundled/fup")

local appIcon = module.AppIcon

local v5 = {
	Heading = "App icon",
	Description = "Customize your app icon with Plus exclusive styles. Changes only affect this device"
}

return {
	ENGLISH = v5,
	useAppIconStrings = function()
		local v8 = useLocalization({
			[appIcon.Default] = module2.Labels[module2.Default],
			[appIcon.Classic] = module2.Labels[module2.Classic],
			[appIcon.Halloween2026] = module2.Labels[module2.Halloween2026]
		})

		local v9 = v8[appIcon.Default]
		local v10 = v8[appIcon.Classic]
		local v11 = v8[appIcon.Halloween2026]

		local v12 = React.useMemo(function()
			return {
				[appIcon.Default] = v9,
				[appIcon.Classic] = v10,
				[appIcon.Halloween2026] = v11
			}
		end, { v9, v10, v11 })

		return {
			heading = v5.Heading,
			description = v5.Description,
			optionLabels = v12
		}
	end
}
