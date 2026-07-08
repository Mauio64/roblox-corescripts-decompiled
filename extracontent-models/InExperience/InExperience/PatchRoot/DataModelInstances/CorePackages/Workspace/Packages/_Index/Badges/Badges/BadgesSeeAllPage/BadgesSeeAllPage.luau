local Badges = script:FindFirstAncestor("Badges")
local BadgesParent = Badges.Parent

require(BadgesParent.Navigation)

local React = require(BadgesParent.React)
local SduiSharedUtilities = require(BadgesParent.SduiSharedUtilities)
local useLocalization = require(BadgesParent.Localization).Hooks.useLocalization
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local CompositionTags = require(BadgesParent.AppComposition).CompositionTags
local fetchBadgesSeeAllPageIfNeeded = require(Badges.BadgesSeeAllPage.fetchBadgesSeeAllPageIfNeeded)
local getBadgesSeeAllPageKey = require(Badges.BadgesSeeAllPage.getBadgesSeeAllPageKey)

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 32
	return t1[s1] or t1.navigation and t1.navigation.getParam(s1)
end
local function BadgesSeeAllPage(t2: {[any]: any}) -- line: 36
	-- upvalues: getBadgesSeeAllPageKey (copy), useLocalization (copy), React (copy), SduiLoadTimer (copy), fetchBadgesSeeAllPageIfNeeded (copy), SduiPageEntryPoint (copy), CompositionTags (copy)
	local v16 = t2.universeId or t2.navigation and t2.navigation.getParam("universeId")
	local v17 = getBadgesSeeAllPageKey(v16)
	local v18 = useLocalization({
		pageTitle = "CommonUI.Features.Label.Badges"
	})
	local v19 = React.useMemo(function() -- line: 43
		-- upvalues: t2 (copy), SduiLoadTimer (copy)
		local v21 = t2

		return v21.pageTimer or v21.navigation and v21.navigation.getParam("pageTimer") or SduiLoadTimer.createLoadTimer("BadgesSeeAll")
	end, { v17 })

	React.useEffect(function() -- line: 48
		-- upvalues: v16 (copy), fetchBadgesSeeAllPageIfNeeded (copy), v19 (copy)
		if v16 then
			fetchBadgesSeeAllPageIfNeeded(v16, v19)
		end
	end, {
		v16,
		v19
	})

	local v20 = React.useCallback(function() -- line: 54
		-- upvalues: v16 (copy), SduiLoadTimer (copy), fetchBadgesSeeAllPageIfNeeded (copy)
		if v16 then
			local v22 = SduiLoadTimer.createLoadTimer("BadgesSeeAll")

			v22.start("refresh")
			fetchBadgesSeeAllPageIfNeeded(v16, v22, true)
		end
	end, { v16 })

	if v16 == nil then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		appPage = "BadgesSeeAll",
		includeNavigationHeaderBar = true,
		configKey = v17,
		pageTimer = v19,
		pageTitle = v18.pageTitle,
		refresh = v20,
		contentTag = CompositionTags.ContentRegion.Body
	})
end

return React.memo(BadgesSeeAllPage)
