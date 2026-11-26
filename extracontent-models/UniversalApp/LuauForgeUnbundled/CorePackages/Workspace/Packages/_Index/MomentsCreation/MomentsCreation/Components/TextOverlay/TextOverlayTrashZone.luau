local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local view = Foundation.View
local icon = Foundation.Icon
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local FFlagMomentsTextOverlayDragToDeleteRefinement = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayDragToDeleteRefinement")

local color = Color3.fromHex("121215")

local v5 = { Color3 = Color3.new(1, 1, 1), Transparency = 0.2 }

local function TextOverlayTrashZone(props, p2)
	if not FFlagMomentsTextOverlayDragToDeleteRefinement then
		return React.createElement(view, {
			Active = false,
			ref = p2,
			tag = "position-bottom-center anchor-bottom-center auto-xy padding-large",
			testId = "moments-text-overlay-trash-zone",
			Visible = props.visible == nil or props.visible,
			ZIndex = props.ZIndex or 20
		}, {
			ButtonScale = React.createElement(view, {
				Active = false,
				backgroundStyle = { Color3 = color, Transparency = 0.35 },
				scale = props.highlightScale or 1,
				Size = UDim2.fromOffset(40, 40),
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				tag = "row align-x-center align-y-center radius-circle",
				testId = "moments-text-overlay-trash"
			}, {
				Icon = React.createElement(icon, {
					name = BuilderIcons.Icon.TrashCan,
					size = Foundation.Enums.IconSize.Small,
					style = v5
				})
			})
		})
	end

	local v6 = useTokens()
	local createElement = React.createElement
	local v8 = {
		Active = false,
		ref = p2,
		tag = "position-bottom-center anchor-bottom-center auto-xy padding-large",
		testId = "moments-text-overlay-trash-zone",
		Visible = props.visible == nil or props.visible,
		ZIndex = props.ZIndex or 20
	}

	local createElement2 = React.createElement
	local v11 = {
		Active = false,
		scale = props.highlightScale or 1,
		tag = "col align-x-center gap-small auto-xy"
	}

	local v13 = if props.label then React.createElement(text, {
		LayoutOrder = 1,
		tag = "auto-xy text-title-small",
		Text = props.label,
		textStyle = v6.Color.ActionEmphasis.Foreground
	}) else nil
	return createElement(view, v8, {
		ButtonScale = createElement2(view, v11, {
			Label = v13,
			Circle = React.createElement(view, {
				Active = false,
				LayoutOrder = 2,
				ref = props.circleRef,
				Size = UDim2.fromOffset(40, 40),
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				tag = "row align-x-center align-y-center radius-circle bg-over-media-0",
				testId = "moments-text-overlay-trash"
			}, {
				Icon = React.createElement(icon, {
					name = BuilderIcons.Icon.TrashCan,
					size = Foundation.Enums.IconSize.Small,
					style = v6.Color.ActionEmphasis.Foreground
				})
			})
		})
	})
end

return React.forwardRef(TextOverlayTrashZone)
