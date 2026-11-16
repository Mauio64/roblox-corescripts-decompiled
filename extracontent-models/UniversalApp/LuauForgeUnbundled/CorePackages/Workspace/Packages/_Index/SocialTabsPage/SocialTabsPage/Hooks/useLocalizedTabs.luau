local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/Types")

local function useLocalizedTabs(items)
	local v6 = useLocalization((React.useMemo(function()
		local tabLabelKeysById = {}

		for k, item in items do
			tabLabelKeysById[item.id] = item.tabLabelKey
		end

		return tabLabelKeysById
	end, { items })))

	return React.useMemo(function()
		return Cryo.List.map(items, function(p2)
			return { id = p2.id, text = v6[p2.id] }
		end)
	end, { items, v6 })
end

return useLocalizedTabs
