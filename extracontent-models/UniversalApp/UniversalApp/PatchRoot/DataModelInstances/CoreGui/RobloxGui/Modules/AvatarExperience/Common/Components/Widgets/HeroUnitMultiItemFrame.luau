local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local BackgroundLayers = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).BackgroundLayersComponents.BackgroundLayers
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local HeroUnitHeader = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitHeader)

local function HeroUnitMultiItemFrame(t1: {[any]: any}) -- line: 49
	-- upvalues: useTokens (copy), React (copy), View (copy), BackgroundLayers (copy), HeroUnitHeader (copy)
	local v11 = useTokens()
	local uDim = UDim.new(0, v11.Radius.Large)
	local backgroundLayers = t1.backgroundLayers
	local v14 = t1.direction ~= "col" and "row items-stretch size-full-0 auto-y" or "col size-full-0 auto-y"

	return React.createElement(View, {
		tag = "size-full-0 auto-y radius-medium clip"
	}, {
		Backgrounds = if backgroundLayers == nil or not (#backgroundLayers > 0) then nil else React.createElement(BackgroundLayers, {
			ZIndex = 0,
			backgroundLayers = backgroundLayers,
			cornerRadius = uDim,
			imageScaleType = Enum.ScaleType.Crop
		}),
		Content = React.createElement(View, {
			ZIndex = 2,
			tag = v14
		}, {
			HeaderSection = React.createElement(View, {
				LayoutOrder = 1,
				Size = t1.header.size,
				tag = t1.header.tag
			}, {
				HeaderPadding = React.createElement(View, {
					tag = t1.header.paddingTag
				}, {
					Header = React.createElement(HeroUnitHeader, t1.header.props)
				})
			}),
			ItemsClipFrame = React.createElement(View, {
				LayoutOrder = 2,
				Size = t1.itemsClipSize,
				tag = t1.itemsClipTag
			}, {
				ItemsContent = React.createElement(View, {
					ZIndex = 1,
					Size = t1.itemsContentSize,
					AutomaticSize = t1.itemsContentAutomaticSize,
					tag = t1.itemsContentTag
				}, t1.children)
			})
		})
	})
end

return HeroUnitMultiItemFrame
