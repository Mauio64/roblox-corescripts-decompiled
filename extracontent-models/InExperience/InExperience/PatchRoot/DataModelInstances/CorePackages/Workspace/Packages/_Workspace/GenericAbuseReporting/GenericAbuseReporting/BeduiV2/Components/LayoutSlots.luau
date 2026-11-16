local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local SlideTransitionContext = require(GenericAbuseReporting.BeduiV2.Components.SlideTransitionContext)
local Subtitle = require(GenericAbuseReporting.BeduiV2.Components.Subtitle)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local Sheet = Foundation.Sheet
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local useIsSlideAnimating = SlideTransitionContext.useIsSlideAnimating

local context = React.createContext(false)

local forwardRef = React.forwardRef(function(p, _)
	return React.createElement(TextWithTranslation, {
		input = p.input,
		tag = "size-full-0 auto-y text-heading-medium",
		layoutOrder = p.layoutOrder
	})
end)

local forwardRef2 = React.forwardRef(function(props, _)
	return React.createElement(View, {
		tag = "col gap-xsmall size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}, {
		Title = React.createElement(TextWithTranslation, {
			input = props.input,
			tag = "size-full-0 auto-y text-title-large",
			layoutOrder = props.layoutOrder
		}),
		Subtitle = props.subtitle and React.createElement(Subtitle, {
			subtitle = props.subtitle,
			layoutOrder = not props.layoutOrder and 2 or props.layoutOrder + 1
		})
	})
end)

local sheetSlots = {
	Title = forwardRef,
	Layout = React.forwardRef(function(props, ref)
		local createElement = React.createElement
		local fragment = React.Fragment
		local v = {
			Content = React.createElement(
				Sheet.Content,
				{ ref = ref, isContentFullBleed = props.isContentFullBleed },
				props.body
			),
			Actions = 0
		}
		local actions

		if props.actions ~= nil then
			actions = React.createElement(Sheet.Actions, nil, props.actions)
		end

		v.Actions = actions
		return createElement(fragment, nil, v)
	end),
	ContentInset = React.forwardRef(function(p, _)
		return React.createElement(
			View,
			{
				tag = "col gap-medium size-full-0 auto-y padding-x-xlarge",
				LayoutOrder = p.layoutOrder
			},
			p.children
		)
	end)
}

local inlineSlots = {
	Title = forwardRef2,
	Layout = React.forwardRef(function(p, ref)
		local paddingtoplarge = React.useContext(context)

		local v = useTokens()
		local mapped = useIsSlideAnimating():map(function(flag: boolean): number
			return if flag then 1 else 0
		end)

		local createElement = React.createElement
		local createElement2 = React.createElement

		local createElement3 = React.createElement

		local v2 = {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ZIndex = 2,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			ScrollBarThickness = 1,
			ScrollBarImageTransparency = mapped
		}

		local createElement4 = React.createElement

		local createElement5 = React.createElement
		local size

		if paddingtoplarge then
			size = UDim2.new(0, 468 * v.Config.UI.Scale, 0, 0)
		end

		local v3 = { Body = p.body, LandscapeActions = 0 }
		local landscapeActions

		if paddingtoplarge and p.actions ~= nil then
			landscapeActions = React.createElement(
				View,
				{ tag = "auto-xy padding-bottom-small padding-top-small", LayoutOrder = 1000 },
				p.actions
			)
		end

		v3.LandscapeActions = landscapeActions
		local v4 = {
			BodyWrapper = createElement2(
				View,
				{ tag = "fill size-full-0", LayoutOrder = 1 },
				createElement3("ScrollingFrame", v2, createElement4(View, {
					tag = {
						["align-x-center size-full-0 auto-y margin-bottom-medium"] = true,
						["padding-top-large"] = paddingtoplarge
					}
				}, createElement5(View, {
					Size = size,
					tag = {
						["col gap-medium auto-y"] = true,
						["size-full-0"] = not paddingtoplarge
					}
				}, v3)))
			),
			PortraitActionsWrapper = 0
		}
		local portraitActionsWrapper

		if not (paddingtoplarge or p.actions == nil) then
			portraitActionsWrapper = React.createElement(
				View,
				{ tag = "align-x-center size-full-0 auto-y padding-bottom-small", LayoutOrder = 2 },
				React.createElement(
					View,
					{ tag = "row gap-medium position-bottom-center size-full-0 auto-y", ZIndex = 2 },
					p.actions
				)
			)
		end

		v4.PortraitActionsWrapper = portraitActionsWrapper
		return createElement(View, { tag = "col size-full", ref = ref }, v4)
	end),
	ContentInset = React.forwardRef(function(p, _)
		return React.createElement(
			View,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = p.layoutOrder },
			p.children
		)
	end)
}

local context2 = React.createContext(sheetSlots)
local LayoutSlots = {}
LayoutSlots.sheetSlots = sheetSlots
LayoutSlots.inlineSlots = inlineSlots

function LayoutSlots.LayoutSlotsProvider(p)
	return React.createElement(context2.Provider, { value = p.slots }, p.children)
end

function LayoutSlots.useLayoutSlots()
	return React.useContext(context2)
end

function LayoutSlots.OverlaidControlsProvider(p)
	return React.createElement(context.Provider, { value = p.value }, p.children)
end

function LayoutSlots.useShouldUseOverlaidControls()
	return React.useContext(context)
end

LayoutSlots.INLINE_LANDSCAPE_WIDTH = 468
return LayoutSlots
