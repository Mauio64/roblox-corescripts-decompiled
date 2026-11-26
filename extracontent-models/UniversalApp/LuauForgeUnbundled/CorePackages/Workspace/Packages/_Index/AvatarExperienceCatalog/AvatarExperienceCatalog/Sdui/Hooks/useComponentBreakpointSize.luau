local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState

local getBreakpointFromRowWidth = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getBreakpointFromRowWidth")
local getUIScaleFromTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getUIScaleFromTokens")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation").Hooks.useTokens
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")
local GetAXMarketplaceWidgetStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/GetAXMarketplaceWidgetStore")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXSduiFeedPublishesBreakpoint = AvatarExperienceFlags.FFlagAXSduiFeedPublishesBreakpoint
local fFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter

local function useCatalogFeedBreakpoint(p2, data)
	local v6 = getUIScaleFromTokens((useTokens()))

	local v7 = p2 == nil and 0.2 or p2

	local v8 = not (data and data.horizontalInset) and 0 or data.horizontalInset
	local v9 = not (data == nil) and data.publishToStore == true
	local v10 = not (data and data.measurementSource) and "" or data.measurementSource

	local v11 = GetAXMarketplaceWidgetStore(false)

	local v12 = useSignalState(v11.getScreenSize)

	local state, setState = React.useState(nil)

	local ref = React.useRef(nil)
	local ref2 = if fFlagAXMarketplaceBreakpointMismatchCounter then React.useRef(false) else nil

	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
				ref.current = nil
			end
		end
	end, {})

	local v13 = React.useCallback(function(p3)
		local v14 = p3.AbsoluteSize.X

		if fFlagAXSduiFeedPublishesBreakpoint and v8 > 0 then
			v14 = math.max(v14 - v8, 0)
		end

		local v15 = getBreakpointFromRowWidth(v14, v6)

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(v7, function()
			ref.current = nil

			if fFlagAXMarketplaceBreakpointMismatchCounter and ref2 and v10 ~= "" and not ref2.current then
				ref2.current = true
				v11.reportMeasuredBreakpoint(v15, v10)
			end

			if fFlagAXSduiFeedPublishesBreakpoint and v9 then
				v11.setScreenSize(v15)
			end

			setState(v15)
		end)
	end, (fFlagAXSduiFeedPublishesBreakpoint or fFlagAXMarketplaceBreakpointMismatchCounter) and {
		v6,
		v7,
		v8,
		v9,
		v10,
		v11
	} or { v6, v7 })

	if state == nil then
		state = v12
	end

	return state, v13
end

return useCatalogFeedBreakpoint
