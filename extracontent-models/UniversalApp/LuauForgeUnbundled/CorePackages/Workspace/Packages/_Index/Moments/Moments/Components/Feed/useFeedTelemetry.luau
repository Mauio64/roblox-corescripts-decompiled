local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local NavigationDestinationType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/NavigationDestinationType")

local FFlagMomentsFixRecommendationImpressionLifecycle = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixRecommendationImpressionLifecycle")
local FFlagMomentsNavigationEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsNavigationEvent")

local HttpService = game:GetService("HttpService")

local function mintViewId()
	return HttpService:GenerateGUID(false)
end

local function resolvePagerDestination(data, p2, p3)
	if data == nil or p2 == nil or data.leftItemId ~= p2 or data.toIndex ~= p3 then
		return NavigationDestinationType.Unknown
	end

	return data.destination
end

local function useFeedTelemetry(p2, data)
	local active = data.active

	local ref = React.useRef(nil)
	local ref2 = React.useRef(1)
	local ref3 = React.useRef(0)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)

	local ref7 = React.useRef(data.telemetry)
	ref7.current = data.telemetry
	local ref8 = React.useRef(data.recommendationSource)
	ref8.current = data.recommendationSource
	local ref9 = React.useRef(data.getAttribution)
	ref9.current = data.getAttribution
	local ref10 = React.useRef(data.onItemBecameActive)
	ref10.current = data.onItemBecameActive
	local ref11 = React.useRef(data.onEndStateReached)
	ref11.current = data.onEndStateReached
	local ref12 = React.useRef(data.onViewEnded)
	ref12.current = data.onViewEnded
	local ref13 = React.useRef(data.inactiveDestination)
	ref13.current = data.inactiveDestination

	local ref14 = React.useRef(active)
	ref14.current = active

	local v5 = React.useCallback(function(p3)
		local current = ref.current

		if current == nil then
			return nil
		end

		local current2 = ref3.current

		if ref4.current ~= nil then
			current2 += os.clock() - ref4.current
		end

		local current3 = ref5.current
		ref.current = nil
		ref4.current = nil
		ref3.current = 0
		ref5.current = nil

		if current2 <= 0 then
			return current3
		end

		ref7.current.logView(current, {
			durationSeconds = current2,
			itemPosition = ref2.current,
			recommendationSource = ref8.current
		})

		local current4 = ref12.current

		if FFlagMomentsNavigationEvent and current3 ~= nil and current4 ~= nil then
			current4(current, {
				viewId = current3,
				durationSeconds = current2,
				itemPosition = ref2.current,
				destination = p3 or NavigationDestinationType.Unknown
			})
		end

		return current3
	end, {})

	React.useEffect(function()
		local effect = Signals.createEffect(function(p3)
			local currentItem = p2.getCurrentItem(p3)
			local v6

			if FFlagMomentsNavigationEvent then
				local current = ref.current

				local current2 = ref6.current
				local itemId = if current ~= nil then current.itemId else nil
				local currentIndex = p2.getCurrentIndex(false)

				if
					current2 == nil
					or itemId == nil
					or current2.leftItemId ~= itemId
					or current2.toIndex ~= currentIndex
				then
					v6 = NavigationDestinationType.Unknown
				else
					v6 = current2.destination
				end

				ref6.current = nil
			end

			v5(v6)

			if currentItem == nil then
				return
			end

			if
				(currentItem.kind == "endState" or currentItem.kind == "caughtUp")
				and ref14.current
				and ref11.current
			then
				ref11.current(p2.getCurrentIndex(false))
			end

			local current = ref9.current(currentItem)

			if current == nil then
				return
			end

			ref.current = current

			ref2.current = p2.getCurrentIndex(false)
			ref3.current = 0
			local v7 = ref5
			local v8 = if FFlagMomentsNavigationEvent then HttpService:GenerateGUID(false) else nil

			v7.current = v8

			local v9 = ref4
			local v10 = if ref14.current then os.clock() else nil
			v9.current = v10

			if ref14.current and ref10.current then
				ref10.current(currentItem)
			end
		end)
		return function()
			effect()
			v5()
		end
	end, { p2, v5 })

	React.useEffect(function()
		if active then
			if FFlagMomentsFixRecommendationImpressionLifecycle and ref.current == nil then
				local currentItem = p2.getCurrentItem(false)

				if currentItem == nil then
					return
				end

				local current = ref9.current(currentItem)

				if current == nil then
					return
				end

				ref.current = current
				ref2.current = p2.getCurrentIndex(false)
				ref3.current = 0
				ref4.current = os.clock()
				local v6 = ref5
				local v7 = if FFlagMomentsNavigationEvent then HttpService:GenerateGUID(false) else nil

				v6.current = v7
			elseif ref.current ~= nil and ref4.current == nil then
				ref4.current = os.clock()
			end
		elseif FFlagMomentsFixRecommendationImpressionLifecycle then
			v5(ref13.current)
		elseif ref4.current ~= nil then
			ref3.current += os.clock() - ref4.current
			ref4.current = nil
		end
	end, { active, p2, v5 })

	return {
		flushView = v5,
		getViewId = function()
			return ref5.current
		end,
		noteUserStep = function(p3, toIndex)
			local v6 = toIndex - p3

			if v6 ~= 1 and v6 ~= -1 then
				ref6.current = nil
				return
			end

			local current = ref.current
			local v7 = ref6
			local v9 = if current ~= nil then current.itemId else nil

			local v10 = if v6 == 1 then NavigationDestinationType.NextMoment else NavigationDestinationType.PreviousMoment
			v7.current = { leftItemId = v9, toIndex = toIndex, destination = v10 }
		end
	}
end

return useFeedTelemetry
