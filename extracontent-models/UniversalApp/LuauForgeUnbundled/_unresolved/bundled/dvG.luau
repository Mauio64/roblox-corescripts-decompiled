local module = require("@luauforge/bundled/dvH")

local module2 = require("@luauforge/bundled/drY")
local useSelector = require("@luauforge/bundled/dsv").Hooks.RoactRodux.useSelector
local module3 = require("@luauforge/bundled/dvA")
local module4 = require("@luauforge/bundled/dsr")
local collectionItemSize = module4.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = module4.usePageSideMargin

local module5 = require("@luauforge/bundled/dvt")

local fFlagLuaAppLayoutParamsInContext = require("@luauforge/bundled/dqB").FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dqB").FFlagLuaAppCompositionAlways
local fFlagSafetyResourceBannerTelemetry = require("@luauforge/bundled/dqB").FFlagSafetyResourceBannerTelemetry

return function(p2)
	local v5 = fFlagLuaAppCompositionAlways and true or p2[module5.key].appCompositionEnabled
	local v6

	if not fFlagLuaAppCompositionAlways then
		if fFlagLuaAppLayoutParamsInContext then
			local sduiContext = p2[module5.key].sduiContext

			local small = collectionItemSize.Small
			local v7 = module2.useCallback(function(p3)
				return sduiContext.getPageLayoutConfig(small)(p3).sideMargin
			end, { small, sduiContext.getPageLayoutConfig })
			v6 = module3.useSignalState(v7)
		else
			v6 = usePageSideMargin(p2[module5.key].verticalScrollingFrameRef.current)
		end
	end

	if v5 then
		v6 = nil
	end

	local v7 = nil
	local v8

	if fFlagSafetyResourceBannerTelemetry then
		local v9 = useSelector(function(p3)
			return p3.TextSearchResults[p2.searchUuid]
				and p3.TextSearchResults[p2.searchUuid][p2.topicId]
				or nil
		end)

		local v10 = useSelector(function(p3)
			return p3.SearchesTypes and p3.SearchesTypes[p2.searchUuid]
		end)

		if v9 then
			v8 = v9.text
		end

		local safetyResource = if v9 then v9.safetyResource else nil

		if safetyResource and v10 then
			v7 = {
				moderationCategory = safetyResource.moderationCategory,
				textFilterRequestId = safetyResource.textFilterRequestId,
				surface = v10
			}
		end
	else
		v8 = useSelector(function(p3)
			local v9 = p3.TextSearchResults[p2.searchUuid]
				and p3.TextSearchResults[p2.searchUuid][p2.topicId]
				or nil

			if v9 then
				return v9.text
			end

			return nil
		end)
	end

	local createElement = module2.createElement

	if not fFlagSafetyResourceBannerTelemetry then
		v7 = nil
	end

	return createElement(module, {
		text = v8,
		sidePadding = v6,
		safetyResourceTelemetry = v7
	})
end
