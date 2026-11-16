local module = require("@luauforge/bundled/drY")
local signal = require("@luauforge/bundled/dqY").Signal
local module2 = require("@luauforge/bundled/dqE")
local usePrevious = require("@luauforge/bundled/dsv").Hooks.usePrevious
require("@luauforge/bundled/dqn")
local screenSizeImpressionsDetector = require("@luauforge/bundled/dsb").ScreenSizeImpressionsDetector
local useRoactService = require("@luauforge/bundled/dsp").useRoactService
local appEventIngestService = require("@luauforge/bundled/drk").AppEventIngestService

local module3 = require("@luauforge/bundled/dvm")

return function(props)
	local ref = module.useRef({})
	local ref2 = module.useRef(signal.new())
	local state, setState = module.useState(nil)
	local v5 = useRoactService(appEventIngestService)
	local v6 = usePrevious(props.omniFeedItems)
	local eventContext = props.eventContext

	module.useEffect(function()
		local onItemsUpdatedSignalConnection

		if props.onItemsUpdatedSignal then
			onItemsUpdatedSignalConnection = props.onItemsUpdatedSignal:connect(function()
				ref2.current:fire()
			end)
		else
			onItemsUpdatedSignalConnection = nil
		end

		return function()
			if onItemsUpdatedSignalConnection ~= nil then
				onItemsUpdatedSignalConnection:disconnect()
			end
		end
	end, { props.onItemsUpdatedSignal })

	local function fn(state2)
		local omniFeedItems = props.omniFeedItems

		if not v5 or (not state2 or #state2 == 0) then
			return
		end

		local v7 = {}
		local treatmentTypes = {}
		local uniqueNameForAnalytics = {}

		for i = 1, #state2 do
			local item = state2[i]
			local omniFeedItem = omniFeedItems[item]
			local treatmentType = omniFeedItem and omniFeedItem.treatmentType or ""
			local uniqueNameForAnalytics2 = module3.getUniqueNameForAnalytics(omniFeedItem)

			table.insert(v7, item)
			table.insert(treatmentTypes, treatmentType)
			table.insert(uniqueNameForAnalytics, uniqueNameForAnalytics2)
		end

		v5:sendEventDeferred(eventContext, "feedImpressions", {
			feedItemPos = table.concat(v7, ","),
			treatmentType = table.concat(treatmentTypes, ","),
			feedItemNameId = table.concat(uniqueNameForAnalytics, ",")
		})
	end

	module.useEffect(function()
		local flag

		if v6 == nil or props.omniFeedItems == nil or #v6 > #props.omniFeedItems then
			flag = true
		else
			local v7 = 1
			flag = false

			while v7 <= #v6 do
				if v6[v7] == props.omniFeedItems[v7] then
					v7 += 1
				else
					flag = true
					break
				end
			end
		end

		if flag then
			ref.current = {}
			ref2.current:fire()
		end
	end, { props.omniFeedItems, v6 })

	module.useEffect(function()
		if state ~= nil then
			fn(state)
			setState(nil)
		end
	end, { state })

	return module.createElement(screenSizeImpressionsDetector, {
		onRequestImpressionsSignal = ref2.current,
		filterImpressionFunc = function(p2): boolean
			if ref.current[p2] ~= nil then
				return false
			end

			ref.current[p2] = true
			return true
		end,
		onImpressionsDetected = function(list)
			module2.assert(list ~= nil)
			module2.assert(#list ~= 0)

			setState(list)
		end,
		impressionsTag = props.impressionsTag,
		skipZeroSizes = true
	})
end
