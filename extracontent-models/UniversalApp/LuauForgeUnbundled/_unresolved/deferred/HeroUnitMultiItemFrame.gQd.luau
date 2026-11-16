local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local backgroundLayers = require("@luauforge/deferred/gkN").BackgroundLayersComponents.BackgroundLayers

local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local module = require("@luauforge/deferred/gPY")

local function HeroUnitMultiItemFrame(props)
	local v5 = useTokens()
	local udim = UDim.new(0, v5.Radius.Large)

	local backgroundLayers2 = props.backgroundLayers

	local v6 = props.direction == "col" and "col size-full-0 auto-y"
		or "row items-stretch size-full-0 auto-y"

	local createElement = React.createElement

	local v10 = if backgroundLayers2 ~= nil and #backgroundLayers2 > 0 then React.createElement(backgroundLayers, {
		backgroundLayers = backgroundLayers2,
		cornerRadius = udim,
		ZIndex = 0,
		imageScaleType = Enum.ScaleType.Crop
	}) else nil
	return createElement(view, { tag = "size-full-0 auto-y radius-medium clip" }, {
		Backgrounds = v10,
		Content = React.createElement(view, { ZIndex = 2, tag = v6 }, {
			HeaderSection = React.createElement(
				view,
				{ LayoutOrder = 1, Size = props.header.size, tag = props.header.tag },
				{
					HeaderPadding = React.createElement(view, {
						tag = props.header.paddingTag
					}, {
						Header = React.createElement(module, props.header.props)
					})
				}
			),
			ItemsClipFrame = React.createElement(
				view,
				{
					LayoutOrder = 2,
					Size = props.itemsClipSize,
					tag = props.itemsClipTag
				},
				{
					ItemsContent = React.createElement(
						view,
						{
							Size = props.itemsContentSize,
							AutomaticSize = props.itemsContentAutomaticSize,
							ZIndex = 1,
							tag = props.itemsContentTag
						},
						props.children
					)
				}
			)
		})
	})
end

return HeroUnitMultiItemFrame
