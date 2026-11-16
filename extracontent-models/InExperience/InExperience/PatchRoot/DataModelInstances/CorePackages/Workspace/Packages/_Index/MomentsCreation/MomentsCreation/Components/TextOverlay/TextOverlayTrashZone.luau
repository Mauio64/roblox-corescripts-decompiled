local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View
local Icon = Foundation.Icon
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local FFlagMomentsTextOverlayDragToDeleteRefinement = require(MomentsCreation.Flags.FFlagMomentsTextOverlayDragToDeleteRefinement)

local color = Color3.fromHex("121215")

local style = { Color3 = Color3.new(1, 1, 1), Transparency = 0.2 }

local function TextOverlayTrashZone(props, ref)
	if not FFlagMomentsTextOverlayDragToDeleteRefinement then
		return React.createElement(View, {
			Active = false,
			ref = ref,
			tag = "position-bottom-center anchor-bottom-center auto-xy padding-large",
			testId = "moments-text-overlay-trash-zone",
			Visible = props.visible == nil or props.visible,
			ZIndex = props.ZIndex or 20
		}, {
			ButtonScale = React.createElement(View, {
				Active = false,
				backgroundStyle = { Color3 = color, Transparency = 0.35 },
				scale = props.highlightScale or 1,
				Size = UDim2.fromOffset(40, 40),
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				tag = "row align-x-center align-y-center radius-circle",
				testId = "moments-text-overlay-trash"
			}, {
				Icon = React.createElement(Icon, {
					name = BuilderIcons.Icon.TrashCan,
					size = Foundation.Enums.IconSize.Small,
					style = style
				})
			})
		})
	end

	local v = useTokens()
	local createElement = React.createElement
	local v2 = {
		Active = false,
		ref = ref,
		tag = "position-bottom-center anchor-bottom-center auto-xy padding-large",
		testId = "moments-text-overlay-trash-zone",
		Visible = props.visible == nil or props.visible,
		ZIndex = props.ZIndex or 20
	}

	local createElement2 = React.createElement
	local v3 = {
		Active = false,
		scale = props.highlightScale or 1,
		tag = "col align-x-center gap-small auto-xy"
	}
	local label

	if props.label then
		label = React.createElement(Text, {
			LayoutOrder = 1,
			tag = "auto-xy text-title-small",
			Text = props.label,
			textStyle = v.Color.ActionEmphasis.Foreground
		})
	end

	return createElement(View, v2, {
		ButtonScale = createElement2(View, v3, {
			Label = label,
			Circle = React.createElement(View, {
				Active = false,
				LayoutOrder = 2,
				ref = props.circleRef,
				Size = UDim2.fromOffset(40, 40),
				stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
				tag = "row align-x-center align-y-center radius-circle bg-over-media-0",
				testId = "moments-text-overlay-trash"
			}, {
				Icon = React.createElement(Icon, {
					name = BuilderIcons.Icon.TrashCan,
					size = Foundation.Enums.IconSize.Small,
					style = v.Color.ActionEmphasis.Foreground
				})
			})
		})
	})
end

return React.forwardRef(TextOverlayTrashZone)
