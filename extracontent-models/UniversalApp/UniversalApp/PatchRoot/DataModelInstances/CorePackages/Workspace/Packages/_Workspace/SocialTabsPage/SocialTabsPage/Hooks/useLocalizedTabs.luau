local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local Cryo = require(SocialTabsPageParent.Cryo)
local React = require(SocialTabsPageParent.React)
local useLocalization = require(SocialTabsPageParent.Localization).Hooks.useLocalization

require(SocialTabsPage.Common.Types)

local function useLocalizedTabs(p1) -- line: 11
	-- upvalues: React (copy), useLocalization (copy), Cryo (copy)
	local v8 = React.useMemo(function() -- line: 12
		-- upvalues: p1 (copy)
		local t1 = {}

		for _, v12 in p1 do
			t1[v12.id] = v12.tabLabelKey
		end

		return t1
	end, { p1 })
	local v9 = useLocalization(v8)

	return React.useMemo(function() -- line: 22
		-- upvalues: Cryo (copy), p1 (copy), v9 (copy)
		return Cryo.List.map(p1, function(p2) -- line: 23
			-- upvalues: v9 (copy)
			return {
				id = p2.id,
				text = v9[p2.id]
			}
		end)
	end, {
		p1,
		v9
	})
end

return useLocalizedTabs
