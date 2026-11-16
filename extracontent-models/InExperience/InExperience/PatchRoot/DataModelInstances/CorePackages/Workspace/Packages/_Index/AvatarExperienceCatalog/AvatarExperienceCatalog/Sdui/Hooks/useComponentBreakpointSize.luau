local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getBreakpointFromRowWidth = require(AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth)
local getUIScaleFromTokens = require(AvatarExperienceCatalog.Utils.getUIScaleFromTokens)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)
local GetAXMarketplaceWidgetStore = require(AvatarExperienceCatalog.Stores.GetAXMarketplaceWidgetStore)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSduiFeedPublishesBreakpoint = AvatarExperienceFlags.FFlagAXSduiFeedPublishesBreakpoint
local FFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter

local function useCatalogFeedBreakpoint(p: number?, data)
	local uiScaleFromTokens = getUIScaleFromTokens((useTokens()))

	local v = p == nil and 0.2 or p

	local v2 = not (data and data.horizontalInset) and 0 or data.horizontalInset
	local v3

	if data == nil then
		v3 = false
	else
		v3 = data.publishToStore == true
	end

	local v4 = not (data and data.measurementSource) and "" or data.measurementSource

	local getAXMarketplaceWidgetStore = GetAXMarketplaceWidgetStore(false)

	local v5 = useSignalState(getAXMarketplaceWidgetStore.getScreenSize)

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local ref2

	if FFlagAXMarketplaceBreakpointMismatchCounter then
		ref2 = React.useRef(false)
	else
		ref2 = nil
	end

	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
				ref.current = nil
			end
		end
	end, {})

	local v6 = React.useCallback(function(p2)
		local v6 = p2.AbsoluteSize.X

		if FFlagAXSduiFeedPublishesBreakpoint and v2 > 0 then
			v6 = math.max(v6 - v2, 0)
		end

		local breakpointFromRowWidth = getBreakpointFromRowWidth(v6, uiScaleFromTokens)

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(v, function()
			ref.current = nil

			if FFlagAXMarketplaceBreakpointMismatchCounter and ref2 and v4 ~= "" and not ref2.current then
				ref2.current = true
				getAXMarketplaceWidgetStore.reportMeasuredBreakpoint(breakpointFromRowWidth, v4)
			end

			if FFlagAXSduiFeedPublishesBreakpoint and v3 then
				getAXMarketplaceWidgetStore.setScreenSize(breakpointFromRowWidth)
			end

			setState(breakpointFromRowWidth)
		end)
	end, (FFlagAXSduiFeedPublishesBreakpoint or FFlagAXMarketplaceBreakpointMismatchCounter) and {
		uiScaleFromTokens,
		v,
		v2,
		v3,
		v4,
		getAXMarketplaceWidgetStore
	} or { uiScaleFromTokens, v })

	if state == nil then
		state = v5
	end

	return state, v6
end

return useCatalogFeedBreakpoint
