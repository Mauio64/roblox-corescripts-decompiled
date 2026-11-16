local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local orientation = Foundation.Enums.Orientation

local module = require("@luauforge/deferred/gnk")

local module2 = require("@luauforge/bundled/fuM")
local outfitDetailsActionBar = module2.Components.OutfitDetailsActionBar
local outfitDetailsTopBar = module2.Components.OutfitDetailsTopBar

local function OutfitDetailsScreenView(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "bg-surface-0",
		Position = props.framePosition,
		Size = props.frameSize,
		ref = props.panelRef
	}

	local v7 = if not (props.isPortrait or props.isSpatial) then React.createElement(Foundation.Divider, {
		orientation = orientation.Vertical,
		tag = "size-0-full"
	}) else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v9 = {
		TopBar = React.createElement(outfitDetailsTopBar, {
			LayoutOrder = 1,
			onClose = props.onGoBack
		}),
		ContentContainer = React.createElement(
			Foundation.View,
			{ tag = "col fill size-full-0 bg-surface-0", LayoutOrder = 2 },
			{
				Content = React.createElement(module, { outfitId = props.outfitId })
			}
		),
		ActionBar = 0
	}

	local v10 = if props.showActionBar then React.createElement(outfitDetailsActionBar, {
		outfitId = props.outfitId,
		LayoutOrder = 3
	}) else nil
	v9.ActionBar = v10
	return createElement(view, v5, {
		LeftBorder = v7,
		ContentStack = createElement2(view2, { tag = "col size-full bg-surface-0" }, v9)
	})
end

return OutfitDetailsScreenView
