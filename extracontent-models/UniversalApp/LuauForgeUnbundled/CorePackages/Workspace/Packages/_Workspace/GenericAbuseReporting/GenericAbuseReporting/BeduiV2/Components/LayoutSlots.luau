local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local SlideTransitionContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/SlideTransitionContext")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Subtitle")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")

local sheet = Foundation.Sheet
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local useIsSlideAnimating = SlideTransitionContext.useIsSlideAnimating

local context = React.createContext(false)

local forwardRef = React.forwardRef(function(p2, p3)
	return React.createElement(TextWithTranslation, {
		input = p2.input,
		tag = "size-full-0 auto-y text-heading-medium",
		layoutOrder = p2.layoutOrder
	})
end)

local forwardRef2 = React.forwardRef(function(props, p2)
	return React.createElement(
		view,
		{ tag = "col gap-xsmall size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		{
			Title = React.createElement(TextWithTranslation, {
				input = props.input,
				tag = "size-full-0 auto-y text-title-large",
				layoutOrder = props.layoutOrder
			}),
			Subtitle = props.subtitle and React.createElement(module4, {
				subtitle = props.subtitle,
				layoutOrder = not props.layoutOrder and 2 or props.layoutOrder + 1
			})
		}
	)
end)

local v5 = {
	Title = forwardRef,
	Layout = React.forwardRef(function(props, p2)
		local createElement = React.createElement
		local fragment = React.Fragment
		local v7 = {
			Content = React.createElement(
				sheet.Content,
				{ ref = p2, isContentFullBleed = props.isContentFullBleed },
				props.body
			),
			Actions = 0
		}

		local v8 = if props.actions ~= nil then React.createElement(sheet.Actions, nil, props.actions) else nil
		v7.Actions = v8
		return createElement(fragment, nil, v7)
	end),
	ContentInset = React.forwardRef(function(p2, p3)
		return React.createElement(
			view,
			{
				tag = "col gap-medium size-full-0 auto-y padding-x-xlarge",
				LayoutOrder = p2.layoutOrder
			},
			p2.children
		)
	end)
}

local v6 = {
	Title = forwardRef2,
	Layout = React.forwardRef(function(p2, p3)
		local v7 = React.useContext(context)

		local v8 = useTokens()
		local mapped = useIsSlideAnimating():map(function(p4): number
			if p4 then
				return 1
			end

			return 0
		end)

		local createElement = React.createElement
		local createElement2 = React.createElement

		local createElement3 = React.createElement

		local v15 = {
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

		local v20 = if v7 then UDim2.new(0, 468 * v8.Config.UI.Scale, 0, 0) else nil

		local v21 = { Body = p2.body, LandscapeActions = 0 }

		local v22 = if v7 and p2.actions ~= nil then React.createElement(
			view,
			{
				tag = "auto-xy padding-bottom-small padding-top-small",
				LayoutOrder = 1000
			},
			p2.actions
		) else nil
		v21.LandscapeActions = v22
		local v11 = {
			BodyWrapper = createElement2(
				view,
				{ tag = "fill size-full-0", LayoutOrder = 1 },
				createElement3("ScrollingFrame", v15, createElement4(view, {
					tag = {
						["align-x-center size-full-0 auto-y margin-bottom-medium"] = true,
						["padding-top-large"] = v7
					}
				}, createElement5(view, {
					Size = v20,
					tag = {
						["col gap-medium auto-y"] = true,
						["size-full-0"] = not v7
					}
				}, v21)))
			),
			PortraitActionsWrapper = 0
		}

		local v23 = if not v7 and p2.actions ~= nil then React.createElement(
			view,
			{
				tag = "align-x-center size-full-0 auto-y padding-bottom-small",
				LayoutOrder = 2
			},
			React.createElement(
				view,
				{
					tag = "row gap-medium position-bottom-center size-full-0 auto-y",
					ZIndex = 2
				},
				p2.actions
			)
		) else nil
		v11.PortraitActionsWrapper = v23
		return createElement(view, { tag = "col size-full", ref = p3 }, v11)
	end),
	ContentInset = React.forwardRef(function(p2, p3)
		return React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = p2.layoutOrder },
			p2.children
		)
	end)
}

local context2 = React.createContext(v5)
return {
	sheetSlots = v5,
	inlineSlots = v6,
	LayoutSlotsProvider = function(p2)
		return React.createElement(context2.Provider, { value = p2.slots }, p2.children)
	end,
	useLayoutSlots = function()
		return React.useContext(context2)
	end,
	OverlaidControlsProvider = function(p2)
		return React.createElement(context.Provider, { value = p2.value }, p2.children)
	end,
	useShouldUseOverlaidControls = function()
		return React.useContext(context)
	end,
	INLINE_LANDSCAPE_WIDTH = 468
}
