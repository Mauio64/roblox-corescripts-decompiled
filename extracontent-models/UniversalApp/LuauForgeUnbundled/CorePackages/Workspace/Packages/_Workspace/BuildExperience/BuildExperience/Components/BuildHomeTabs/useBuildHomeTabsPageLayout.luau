local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local FIntBuildExperienceHomeTabsSlideMilliseconds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntBuildExperienceHomeTabsSlideMilliseconds")

local function useBuildHomeTabsPageLayout(data)
	local v5 = math.max(0, FIntBuildExperienceHomeTabsSlideMilliseconds) / 1000

	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion

	local v6 = React.useMemo(function()
		local result = {}

		for k, tab in data.tabs do
			result[tostring(tab.id)] = k - 1
		end

		return result
	end, { data.tabs })

	local v7 = v6[data.activeTab] or 0
	local v8, v9 = Motion.useMotion({ page = v7 })

	local ref = React.useRef(data.showTabs)
	local showTabs = data.showTabs
	React.useLayoutEffect(function()
		local v10 = showTabs and ref.current and not reducedMotion
		ref.current = showTabs
		v9(Motion.createState({ page = v7 }, {
			default = Motion.transition({
				duration = not v10 and 0 or v5,
				easingStyle = Enum.EasingStyle.Quad
			})
		}))
	end, { v7, v9, reducedMotion, showTabs, v5 })

	return { pageOffset = v8.page, tabOrder = v6 }
end

return useBuildHomeTabsPageLayout
