local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local backgroundLayers = require("@luauforge/deferred/gPt").BackgroundLayersComponents.BackgroundLayers

local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local module2 = require("@luauforge/deferred/hcb")

local fFlagAXHeroUnitActionButton = AvatarExperienceFlags.FFlagAXHeroUnitActionButton

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

	local createElement2 = React.createElement

	local v13 = {
		HeaderSection = React.createElement(
			view,
			{ LayoutOrder = 1, Size = props.header.size, tag = props.header.tag },
			{
				HeaderPadding = React.createElement(view, {
					tag = props.header.paddingTag
				}, {
					Header = React.createElement(module2, props.header.props)
				})
			}
		),
		ItemsClipFrame = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		LayoutOrder = 2,
		Size = props.itemsClipSize,
		tag = props.itemsClipTag
	}

	local createElement4 = React.createElement
	local v18 = {
		Size = props.itemsContentSize,
		AutomaticSize = props.itemsContentAutomaticSize,
		ZIndex = 1,
		tag = props.itemsContentTag,
		layout = 0
	}
	local v19 = if fFlagAXHeroUnitActionButton then props.itemsContentLayout else nil
	v18.layout = v19
	v13.ItemsClipFrame = createElement3(view, v15, {
		ItemsContent = createElement4(view, v18, props.children)
	})
	return createElement(view, { tag = "size-full-0 auto-y radius-medium clip" }, {
		Backgrounds = v10,
		Content = createElement2(view, { ZIndex = 2, tag = v6 }, v13)
	})
end

return HeroUnitMultiItemFrame
