local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useSignal = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useSignal
local useThrottledCallback = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useThrottledCallback
local Dash = require(CorePackages.Packages.Dash)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local v10 = game:DefineFastInt("AXSponsoredItemsImpressionsPeriod", 1)

local function selectScreenSize(p1) -- line: 22
	return p1.ScreenSize
end
local function selectGlobalGuiInset(p2) -- line: 26
	return p2.GlobalGuiInset
end
local function getItemKey(p3) -- line: 40
	if not p3 or (not p3.id or not p3.type) then
		return ""
	end

	return tostring(p3.type) .. "-" .. tostring(p3.id)
end
local function SponsoredItemsImpressionsTracker(t1: {[any]: any}) -- line: 47
	-- upvalues: useSelector (copy), selectScreenSize (copy), getUseSelectorDeepEquals (copy), selectGlobalGuiInset (copy), React (copy), Dash (copy), useThrottledCallback (copy), v10 (copy), useSignal (copy)
	local visibleItems = t1.visibleItems
	local scrollingFrameRef = t1.scrollingFrameRef
	local sponsoredGridRef = t1.sponsoredGridRef
	local requestImpressionsSignal = t1.requestImpressionsSignal
	local v23 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v24 = useSelector(selectGlobalGuiInset, getUseSelectorDeepEquals())
	local v25 = React.useRef({})

	local function getSponsoredItemsCenterHeight() -- line: 56
		-- upvalues: sponsoredGridRef (copy)
		if not sponsoredGridRef.current then
			return nil
		end

		local current = sponsoredGridRef.current
		local AbsolutePosition = current.AbsolutePosition
		local AbsoluteSize = current.AbsoluteSize

		return AbsolutePosition.Y + AbsoluteSize.Y / 2
	end
	local function isSponsoredItemsGridVisible() -- line: 68
		-- upvalues: scrollingFrameRef (copy), v23 (copy), v24 (copy), sponsoredGridRef (copy)
		if not scrollingFrameRef or not scrollingFrameRef.current then
			return false
		end

		assert(scrollingFrameRef, "")

		local AbsolutePositionY = scrollingFrameRef.current.AbsolutePosition.Y
		local v35 = v23.Y - v24.bottom
		local v36

		if not sponsoredGridRef.current then
			v36 = nil
		else
			local current = sponsoredGridRef.current
			local AbsolutePosition = current.AbsolutePosition
			local AbsoluteSize = current.AbsoluteSize

			v36 = AbsolutePosition.Y + AbsoluteSize.Y / 2
		end

		return not not v36 and (AbsolutePositionY < v36 and (v36 < v35 or false))
	end
	local function sendImpressions() -- line: 82
		-- upvalues: v25 (copy), visibleItems (copy), Dash (copy)
		local current = v25.current

		for v41, v42 in visibleItems do
			local v43 = v42
			local v44 = if not not v43 and (not not v43.id and v43.type) then tostring(v43.type) .. "-" .. tostring(v43.id) else ""

			if not current[v44] then
				table.insert({}, (Dash.join(v43, {
					index = v41
				})))
				current[v44] = true
			end
		end
	end
	local function updateImpressions() -- line: 97
		-- upvalues: scrollingFrameRef (copy), v23 (copy), v24 (copy), sponsoredGridRef (copy), sendImpressions (copy)
		local v45

		if not scrollingFrameRef or not scrollingFrameRef.current then
			v45 = false
		else
			assert(scrollingFrameRef, "")

			local AbsolutePositionY = scrollingFrameRef.current.AbsolutePosition.Y
			local v47 = v23.Y - v24.bottom
			local v48

			if not sponsoredGridRef.current then
				v48 = nil
			else
				local current = sponsoredGridRef.current
				local AbsolutePosition = current.AbsolutePosition
				local AbsoluteSize = current.AbsoluteSize

				v48 = AbsolutePosition.Y + AbsoluteSize.Y / 2
			end

			v45 = not not v48 and (AbsolutePositionY < v48 and (v48 < v47 or false))
		end

		if v45 then
			sendImpressions()
		end
	end

	local v30 = useThrottledCallback(updateImpressions, v10)

	useSignal(requestImpressionsSignal, v30)

	return nil
end

return SponsoredItemsImpressionsTracker
