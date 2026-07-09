local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local Signal = require(DiscoveryMonolithParent.AppCommonLib).Signal
local ArgCheck = require(DiscoveryMonolithParent.ArgCheck)
local usePrevious = require(DiscoveryMonolithParent.RoactUtils).Hooks.usePrevious

require(DiscoveryMonolithParent.DiscoveryTypes)

local ScreenSizeImpressionsDetector = require(DiscoveryMonolithParent.Impressions).ScreenSizeImpressionsDetector
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(DiscoveryMonolithParent.RoactServiceTags).AppEventIngestService
local Modules = DiscoveryMonolith.Modules
local FeedItemModel = require(Modules.Personalization.OmniFeed.DataStore.FeedItemModel)

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), Signal (copy), useRoactService (copy), AppEventIngestService (copy), usePrevious (copy), FeedItemModel (copy), ScreenSizeImpressionsDetector (copy), ArgCheck (copy)
	local v13 = React.useRef({})
	local v14 = React.useRef(Signal.new())
	local v15, v16 = React.useState(nil)
	local v17 = useRoactService(AppEventIngestService)
	local v18 = usePrevious(t1.omniFeedItems)
	local eventContext = t1.eventContext

	React.useEffect(function() -- line: 32
		-- upvalues: t1 (copy), v14 (copy)
		local u21 = nil

		if t1.onItemsUpdatedSignal then
			u21 = t1.onItemsUpdatedSignal:connect(function() -- line: 35
				-- upvalues: v14 (copy)
				v14.current:fire()
			end)
		end

		return function() -- line: 39
			-- upvalues: u21 (ref)
			if u21 ~= nil then
				u21:disconnect()
			end
		end
	end, { t1.onItemsUpdatedSignal })

	local function v20(p1) -- line: 46
		-- upvalues: t1 (copy), v17 (copy), FeedItemModel (copy), eventContext (copy)
		local omniFeedItems = t1.omniFeedItems

		if not v17 then
			return
		end

		if not p1 or #p1 == 0 then
			return
		end

		local t2 = {}
		local t3 = {}
		local t4 = {}

		for i = 1, #p1 do
			local v28 = p1[i]
			local v29 = omniFeedItems[v28]
			local v30 = v29 and v29.treatmentType or ""
			local v31 = FeedItemModel.getUniqueNameForAnalytics(v29)

			table.insert(t2, v28)
			table.insert(t3, v30)
			table.insert(t4, v31)
		end

		local t5 = {
			feedItemPos = table.concat(t2, ","),
			treatmentType = table.concat(t3, ","),
			feedItemNameId = table.concat(t4, ",")
		}

		v17:sendEventDeferred(eventContext, "feedImpressions", t5)
	end

	React.useEffect(function() -- line: 79
		-- upvalues: v18 (copy), t1 (copy), v13 (copy), v14 (copy)
		local v33 = false

		if v18 == nil or (t1.omniFeedItems == nil or #v18 > #t1.omniFeedItems) then
			v33 = true
		else
			local n1 = 1

			while n1 <= #v18 do
				if v18[n1] ~= t1.omniFeedItems[n1] then
					v33 = true

					break
				end

				n1 += 1
			end
		end

		if v33 then
			v13.current = {}
			v14.current:fire()
		end
	end, {
		t1.omniFeedItems,
		v18
	})
	React.useEffect(function() -- line: 102
		-- upvalues: v15 (copy), v20 (copy), v16 (copy)
		if v15 ~= nil then
			v20(v15)
			v16(nil)
		end
	end, { v15 })

	return React.createElement(ScreenSizeImpressionsDetector, {
		skipZeroSizes = true,
		onRequestImpressionsSignal = v14.current,
		filterImpressionFunc = function(p2) -- line: 111
			-- upvalues: v13 (copy)
			if v13.current[p2] ~= nil then
				return false
			end

			v13.current[p2] = true

			return true
		end,
		onImpressionsDetected = function(t6: {[any]: any}) -- line: 119
			-- upvalues: ArgCheck (copy), v16 (copy)
			ArgCheck.assert(t6 ~= nil)
			ArgCheck.assert(#t6 ~= 0)
			v16(t6)
		end,
		impressionsTag = t1.impressionsTag
	})
end
