local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local SlideTransitionContext = require(GenericAbuseReporting.BeduiV2.Components.SlideTransitionContext)
local Subtitle = require(GenericAbuseReporting.BeduiV2.Components.Subtitle)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local Sheet = Foundation.Sheet
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local useIsSlideAnimating = SlideTransitionContext.useIsSlideAnimating
local v12 = React.createContext(false)
local v13 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 75
	-- upvalues: React (copy), Sheet (copy)
	return React.createElement(Sheet.Content, {
		ref = p1
	}, t1.children)
end)
local v14 = React.forwardRef(function(t2: {[any]: any}, p2) -- line: 81
	-- upvalues: React (copy), Sheet (copy)
	return React.createElement(Sheet.Actions, {
		ref = p2
	}, t2.children)
end)
local v15 = React.forwardRef(function(t3: {[any]: any}, _) -- line: 88
	-- upvalues: React (copy), TextWithTranslation (copy)
	return React.createElement(TextWithTranslation, {
		input = t3.input,
		tag = `size-full-0 auto-y text-heading-medium { t3.tag or "" }`,
		layoutOrder = t3.layoutOrder
	})
end)
local v16 = React.forwardRef(function(t4: {[any]: any}, _) -- line: 96
	-- upvalues: React (copy), View (copy), TextWithTranslation (copy), Subtitle (copy)
	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		LayoutOrder = t4.layoutOrder
	}, {
		Title = React.createElement(TextWithTranslation, {
			input = t4.input,
			tag = `size-full-0 auto-y text-title-large { t4.tag or "" }`,
			layoutOrder = t4.layoutOrder
		}),
		Subtitle = t4.subtitle and React.createElement(Subtitle, {
			subtitle = t4.subtitle,
			layoutOrder = not t4.layoutOrder and 2 or t4.layoutOrder + 1
		})
	})
end)
local v17 = React.forwardRef(function(t5: {[any]: any}, p5) -- line: 118
	-- upvalues: React (copy), Sheet (copy)
	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Sheet.Content, {
			ref = p5
		}, t5.body),
		Actions = if t5.actions == nil then nil else React.createElement(Sheet.Actions, nil, t5.actions)
	})
end)
local t6 = {
	Body = v13,
	Actions = v14,
	Title = v15,
	Layout = v17
}
local v19 = React.forwardRef(function(t7: {[any]: any}, p6) -- line: 137
	-- upvalues: useIsSlideAnimating (copy), React (copy), View (copy)
	local v37 = useIsSlideAnimating():map(function(b1: boolean) -- line: 139
		if b1 then
			return 1
		end

		return 0
	end)

	return React.createElement(View, {
		tag = "fill size-full-0",
		ref = p6
	}, React.createElement("ScrollingFrame", {
		ZIndex = 2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Selectable = false,
		ScrollBarThickness = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarImageTransparency = v37
	}, React.createElement(View, {
		tag = "align-x-center size-full-0 auto-y margin-bottom-medium"
	}, React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y"
	}, t7.children))))
end)
local v20 = React.forwardRef(function(t8: {[any]: any}, p7) -- line: 179
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "size-full-0 auto-y align-x-center padding-bottom-small",
		ref = p7
	}, React.createElement(View, {
		tag = "row size-full-0 auto-y gap-medium position-bottom-center",
		ZIndex = 2
	}, t8.children))
end)
local v21 = React.forwardRef(function(t9: {[any]: any}, p8) -- line: 209
	-- upvalues: React (copy), v12 (copy), useTokens (copy), useIsSlideAnimating (copy), View (copy)
	local v42 = React.useContext(v12)
	local v43 = useTokens()
	local v44 = useIsSlideAnimating():map(function(b2: boolean) -- line: 213
		if b2 then
			return 1
		end

		return 0
	end)

	return React.createElement(View, {
		tag = "col size-full",
		ref = p8
	}, {
		BodyWrapper = React.createElement(View, {
			tag = "fill size-full-0",
			LayoutOrder = 1
		}, React.createElement("ScrollingFrame", {
			ZIndex = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			ScrollBarThickness = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageTransparency = v44
		}, React.createElement(View, {
			tag = {
				["align-x-center size-full-0 auto-y margin-bottom-medium"] = true,
				["padding-top-large"] = v42
			}
		}, React.createElement(View, {
			Size = if not v42 then nil else UDim2.new(0, 468 * v43.Config.UI.Scale, 0, 0),
			tag = {
				["col gap-medium auto-y"] = true,
				["size-full-0"] = not v42
			}
		}, {
			Body = t9.body,
			LandscapeActions = if not v42 or t9.actions == nil then nil else React.createElement(View, {
				tag = "auto-xy padding-bottom-small padding-top-small",
				LayoutOrder = 1000
			}, t9.actions)
		})))),
		PortraitActionsWrapper = if v42 or t9.actions == nil then nil else React.createElement(View, {
			tag = "align-x-center size-full-0 auto-y padding-bottom-small",
			LayoutOrder = 2
		}, React.createElement(View, {
			tag = "row gap-medium position-bottom-center size-full-0 auto-y",
			ZIndex = 2
		}, t9.actions))
	})
end)
local t10 = {
	Body = v19,
	Actions = v20,
	Title = v16,
	Layout = v21
}
local v23 = React.createContext(t6)

return {
	INLINE_LANDSCAPE_WIDTH = 468,
	sheetSlots = t6,
	inlineSlots = t10,
	LayoutSlotsProvider = function(t11: {[any]: any}) -- line: 302
		-- upvalues: React (copy), v23 (copy)
		return React.createElement(v23.Provider, {
			value = t11.slots
		}, t11.children)
	end,
	useLayoutSlots = function() -- line: 313
		-- upvalues: React (copy), v23 (copy)
		return React.useContext(v23)
	end,
	OverlaidControlsProvider = function(t12: {[any]: any}) -- line: 64
		-- upvalues: React (copy), v12 (copy)
		return React.createElement(v12.Provider, {
			value = t12.value
		}, t12.children)
	end,
	useShouldUseOverlaidControls = function() -- line: 71
		-- upvalues: React (copy), v12 (copy)
		return React.useContext(v12)
	end
}
