local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local SearchTextBanner = require(DiscoveryMonolith.Modules.Personalization.Search.SearchTextBanner)
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local useSelector = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useSelector
local SignalsReact = require(DiscoveryMonolithParent.SignalsReact)
local CollectionViews = require(DiscoveryMonolithParent.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = CollectionViews.usePageSideMargin
local Modules = DiscoveryMonolith.Modules
local OmniFeedProps = require(Modules.Personalization.OmniFeed.OmniFeedProps)
local FFlagLuaAppLayoutParamsInContext = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppCompositionAlways = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCompositionAlways

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: FFlagLuaAppCompositionAlways (copy), OmniFeedProps (copy), FFlagLuaAppLayoutParamsInContext (copy), CollectionItemSize (copy), React (copy), SignalsReact (copy), usePageSideMargin (copy), useSelector (copy), SearchTextBanner (copy)
	local v15 = not not FFlagLuaAppCompositionAlways or t1[OmniFeedProps.key].appCompositionEnabled
	local v16 = nil

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppLayoutParamsInContext then
			local sduiContext = t1[OmniFeedProps.key].sduiContext
			local Small = CollectionItemSize.Small
			local v19 = React.useCallback(function(p1) -- line: 37
				-- upvalues: sduiContext (copy), Small (copy)
				return sduiContext.getPageLayoutConfig(Small)(p1).sideMargin
			end, {
				Small,
				sduiContext.getPageLayoutConfig
			})

			v16 = SignalsReact.useSignalState(v19)
		else
			v16 = usePageSideMargin(t1[OmniFeedProps.key].verticalScrollingFrameRef.current)
		end
	end

	local v20 = useSelector(function(p2) -- line: 47
		-- upvalues: t1 (copy)
		local v23 = p2.TextSearchResults[t1.searchUuid] and p2.TextSearchResults[t1.searchUuid][t1.topicId] or nil

		if v23 then
			return v23.text
		end

		return nil
	end)

	return React.createElement(SearchTextBanner, {
		text = v20,
		sidePadding = if not v15 then v16 else nil
	})
end
