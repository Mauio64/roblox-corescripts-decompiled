local DevStore = script:FindFirstAncestor("DevStore")
local DevStoreParent = DevStore.Parent

require(DevStoreParent.Navigation)

local React = require(DevStoreParent.React)
local SduiSharedUtilities = require(DevStoreParent.SduiSharedUtilities)
local useLocalization = require(DevStoreParent.Localization).Hooks.useLocalization
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local CompositionTags = require(DevStoreParent.AppComposition).CompositionTags
local fetchDevStoreSeeAllPageIfNeeded = require(DevStore.DevStoreSeeAllPage.fetchDevStoreSeeAllPageIfNeeded)
local getDevStoreSeeAllPageKey = require(DevStore.DevStoreSeeAllPage.getDevStoreSeeAllPageKey)

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 32
	return t1[s1] or t1.navigation and t1.navigation.getParam(s1)
end
local function DevStoreSeeAllPage(t2: {[any]: any}) -- line: 36
	-- upvalues: getDevStoreSeeAllPageKey (copy), useLocalization (copy), React (copy), SduiLoadTimer (copy), fetchDevStoreSeeAllPageIfNeeded (copy), SduiPageEntryPoint (copy), CompositionTags (copy)
	local v16 = t2.universeId or t2.navigation and t2.navigation.getParam("universeId")
	local v17 = getDevStoreSeeAllPageKey(v16)
	local v18 = useLocalization({
		pageTitle = "Feature.GameDetails.Label.Store"
	})
	local v19 = t2.pageTimer or t2.navigation and t2.navigation.getParam("pageTimer")
	local v20 = React.useMemo(function() -- line: 44
		-- upvalues: v19 (copy), SduiLoadTimer (copy)
		return v19 or SduiLoadTimer.createLoadTimer("DevStoreSeeAll")
	end, {
		v17,
		v19
	})

	React.useEffect(function() -- line: 48
		-- upvalues: v16 (copy), fetchDevStoreSeeAllPageIfNeeded (copy), v20 (copy)
		if v16 then
			fetchDevStoreSeeAllPageIfNeeded(v16, v20)
		end
	end, {
		v16,
		v20
	})

	local v21 = React.useCallback(function() -- line: 54
		-- upvalues: v16 (copy), SduiLoadTimer (copy), fetchDevStoreSeeAllPageIfNeeded (copy)
		if v16 then
			local v22 = SduiLoadTimer.createLoadTimer("DevStoreSeeAll")

			v22.start("refresh")
			fetchDevStoreSeeAllPageIfNeeded(v16, v22, true)
		end
	end, { v16 })

	if v16 == nil then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		appPage = "DevStoreSeeAll",
		includeNavigationHeaderBar = true,
		configKey = v17,
		pageTimer = v20,
		pageTitle = v18.pageTitle,
		refresh = v21,
		contentTag = CompositionTags.ContentRegion.Body,
		layoutTag = CompositionTags.Layout.Detail
	})
end

return React.memo(DevStoreSeeAllPage)
