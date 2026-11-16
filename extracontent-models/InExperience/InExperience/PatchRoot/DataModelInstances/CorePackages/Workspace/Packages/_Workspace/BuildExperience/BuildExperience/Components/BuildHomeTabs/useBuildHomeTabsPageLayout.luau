local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)

local FIntBuildExperienceHomeTabsSlideMilliseconds = require(BuildExperience.Flags.FIntBuildExperienceHomeTabsSlideMilliseconds)

local function useBuildHomeTabsPageLayout(data)
	local v = math.max(0, FIntBuildExperienceHomeTabsSlideMilliseconds) / 1000

	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion

	local tabOrder = React.useMemo(function()
		local result = {}

		for k, tab in data.tabs do
			result[tostring(tab.id)] = k - 1
		end

		return result
	end, { data.tabs })

	local page = tabOrder[data.activeTab] or 0
	local v2, v3 = Motion.useMotion({ page = page })

	local ref = React.useRef(data.showTabs)
	local showTabs = data.showTabs
	React.useLayoutEffect(function()
		local v4 = showTabs and ref.current and not reducedMotion
		ref.current = showTabs
		v3(Motion.createState({ page = page }, {
			default = Motion.transition({
				duration = not v4 and 0 or v,
				easingStyle = Enum.EasingStyle.Quad
			})
		}))
	end, { page, v3, reducedMotion, showTabs, v })

	return { pageOffset = v2.page, tabOrder = tabOrder }
end

return useBuildHomeTabsPageLayout
