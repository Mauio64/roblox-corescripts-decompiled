local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

require(script.Parent.FeedTypes)
local NavigationDestinationType = require(Moments.Enums.NavigationDestinationType)

local FFlagMomentsFixRecommendationImpressionLifecycle = require(Moments.Flags.FFlagMomentsFixRecommendationImpressionLifecycle)
local FFlagMomentsNavigationEvent = require(Moments.Flags.FFlagMomentsNavigationEvent)

local HttpService = game:GetService("HttpService")

local function mintViewId() -- 2 equivalent calls inferred from this helper
	return HttpService:GenerateGUID(false)
end

local function resolvePagerDestination(current, p: string?, p2: number) -- 1 equivalent call inferred from this helper
	if current == nil or p == nil or current.leftItemId ~= p or current.toIndex ~= p2 then
		return NavigationDestinationType.Unknown
	end

	return current.destination
end

local function useFeedTelemetry(p, data)
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

	local flushView = React.useCallback(function(p2)
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
				destination = p2 or NavigationDestinationType.Unknown
			})
		end

		return current3
	end, {})

	React.useEffect(function()
		local effect = Signals.createEffect(function(p2)
			local currentItem = p.getCurrentItem(p2)
			local v

			if FFlagMomentsNavigationEvent then
				local current = ref.current

				local current2 = ref6.current
				local v2

				if current ~= nil then
					v2 = current.itemId
				end

				v = resolvePagerDestination(current2, v2, p.getCurrentIndex(false)) -- inferred equivalent call

				ref6.current = nil
			end

			flushView(v)

			if currentItem == nil then
				return
			end

			if
				(currentItem.kind == "endState" or currentItem.kind == "caughtUp")
				and ref14.current
				and ref11.current
			then
				ref11.current(p.getCurrentIndex(false))
			end

			local current = ref9.current(currentItem)

			if current == nil then
				return
			end

			ref.current = current

			ref2.current = p.getCurrentIndex(false)
			ref3.current = 0
			local current2

			if FFlagMomentsNavigationEvent then
				current2 = mintViewId() -- inferred equivalent call
			end

			ref5.current = current2
			local current3

			if ref14.current then
				current3 = os.clock()
			end

			ref4.current = current3

			if ref14.current and ref10.current then
				ref10.current(currentItem)
			end
		end)
		return function()
			effect()
			flushView()
		end
	end, { p, flushView })

	React.useEffect(function()
		if active then
			if FFlagMomentsFixRecommendationImpressionLifecycle and ref.current == nil then
				local currentItem = p.getCurrentItem(false)

				if currentItem == nil then
					return
				end

				local current = ref9.current(currentItem)

				if current == nil then
					return
				end

				ref.current = current
				ref2.current = p.getCurrentIndex(false)
				ref3.current = 0
				ref4.current = os.clock()
				local current2

				if FFlagMomentsNavigationEvent then
					current2 = mintViewId() -- inferred equivalent call
				end

				ref5.current = current2
			elseif ref.current ~= nil and ref4.current == nil then
				ref4.current = os.clock()
			end
		elseif FFlagMomentsFixRecommendationImpressionLifecycle then
			flushView(ref13.current)
		elseif ref4.current ~= nil then
			ref3.current += os.clock() - ref4.current
			ref4.current = nil
		end
	end, { active, p, flushView })

	return {
		flushView = flushView,
		getViewId = function()
			return ref5.current
		end,
		noteUserStep = function(p2: number, toIndex: number)
			local v = toIndex - p2

			if v ~= 1 and v ~= -1 then
				ref6.current = nil
				return
			end

			local current = ref.current
			local leftItemId

			if current ~= nil then
				leftItemId = current.itemId
			end

			local destination

			if v == 1 then
				destination = NavigationDestinationType.NextMoment
			else
				destination = NavigationDestinationType.PreviousMoment
			end

			ref6.current = { leftItemId = leftItemId, toIndex = toIndex, destination = destination }
		end
	}
end

return useFeedTelemetry
