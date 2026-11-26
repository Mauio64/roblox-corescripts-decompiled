local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/bundled/fHC")
local module2 = require("@luauforge/bundled/fBQ")

local appIcon = module.AppIcon

return {
	useAppIconStrings = function()
		local v7 = useLocalization({
			heading = "Feature.Accessibility.Heading.AppIcon",
			description = "Feature.Accessibility.Description.AppIcon",
			[appIcon.Default] = module2.Labels[module2.Default],
			[appIcon.Classic] = module2.Labels[module2.Classic],
			[appIcon.Halloween2026] = module2.Labels[module2.Halloween2026]
		})

		local v8 = v7[appIcon.Default]
		local v9 = v7[appIcon.Classic]
		local v10 = v7[appIcon.Halloween2026]

		local v11 = React.useMemo(function()
			return {
				[appIcon.Default] = v8,
				[appIcon.Classic] = v9,
				[appIcon.Halloween2026] = v10
			}
		end, { v8, v9, v10 })

		return {
			heading = v7.heading,
			description = v7.description,
			optionLabels = v11
		}
	end
}
