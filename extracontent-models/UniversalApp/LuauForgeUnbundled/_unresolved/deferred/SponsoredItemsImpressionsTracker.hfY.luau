local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useSignal = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useSignal
local useThrottledCallback = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useThrottledCallback
local Dash = require(CorePackages.Packages.Dash)

require("@luauforge/bundled/dKT")

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local defineFastInt = game:DefineFastInt("AXSponsoredItemsImpressionsPeriod", 1)

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function selectGlobalGuiInset(p2)
	return p2.GlobalGuiInset
end

local function getItemKey(p2)
	if p2 and p2.id and p2.type then
		return tostring(p2.type) .. "-" .. tostring(p2.id)
	end

	return ""
end

local function SponsoredItemsImpressionsTracker(data): nil
	local visibleItems = data.visibleItems
	local scrollingFrameRef = data.scrollingFrameRef
	local sponsoredGridRef = data.sponsoredGridRef
	local requestImpressionsSignal = data.requestImpressionsSignal
	local v5 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v6 = useSelector(selectGlobalGuiInset, getUseSelectorDeepEquals())
	local ref = React.useRef({})

	local function getSponsoredItemsCenterHeight()
		if not sponsoredGridRef.current then
			return nil
		end

		local current = sponsoredGridRef.current
		local absolutePosition = current.AbsolutePosition
		local absoluteSize = current.AbsoluteSize

		return absolutePosition.Y + absoluteSize.Y / 2
	end

	local function isSponsoredItemsGridVisible()
		if not (scrollingFrameRef and scrollingFrameRef.current) then
			return false
		end

		assert(scrollingFrameRef, "")

		local y = scrollingFrameRef.current.AbsolutePosition.Y
		local v7 = v5.Y - v6.bottom
		local v8

		if sponsoredGridRef.current then
			local current = sponsoredGridRef.current
			local absolutePosition = current.AbsolutePosition
			local absoluteSize = current.AbsoluteSize

			v8 = absolutePosition.Y + absoluteSize.Y / 2
		end

		return v8 and y < v8 and v8 < v7 and true or false
	end

	local function sendImpressions()
		local current = ref.current
		local v7 = {}

		for k, visibleItem in visibleItems do
			local v8 = not (visibleItem and visibleItem.id and visibleItem.type) and ""
				or tostring(visibleItem.type) .. "-" .. tostring(visibleItem.id)

			if current[v8] then
				continue
			end

			table.insert(v7, (Dash.join(visibleItem, { index = k })))
			current[v8] = true
		end
	end

	local function updateImpressions()
		local v7

		if scrollingFrameRef and scrollingFrameRef.current then
			assert(scrollingFrameRef, "")

			local y = scrollingFrameRef.current.AbsolutePosition.Y
			local v8 = v5.Y - v6.bottom
			local v9

			if sponsoredGridRef.current then
				local current = sponsoredGridRef.current
				local absolutePosition = current.AbsolutePosition
				local absoluteSize = current.AbsoluteSize

				v9 = absolutePosition.Y + absoluteSize.Y / 2
			end

			v7 = v9 and y < v9 and v9 < v8 and true or false
		else
			v7 = false
		end

		if v7 then
			sendImpressions()
		end
	end

	useSignal(requestImpressionsSignal, (useThrottledCallback(updateImpressions, defineFastInt)))

	return nil
end

return SponsoredItemsImpressionsTracker
