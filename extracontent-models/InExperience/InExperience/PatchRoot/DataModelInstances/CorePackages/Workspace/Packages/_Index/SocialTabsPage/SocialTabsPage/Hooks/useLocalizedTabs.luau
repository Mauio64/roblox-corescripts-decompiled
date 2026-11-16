local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(SocialTabsPage.Common.Types)

local function useLocalizedTabs(items)
	local v = useLocalization((React.useMemo(function()
		local tabLabelKeysById = {}

		for _, item in items do
			tabLabelKeysById[item.id] = item.tabLabelKey
		end

		return tabLabelKeysById
	end, { items })))

	return React.useMemo(function()
		return Cryo.List.map(items, function(p)
			return { id = p.id, text = v[p.id] }
		end)
	end, { items, v })
end

return useLocalizedTabs
