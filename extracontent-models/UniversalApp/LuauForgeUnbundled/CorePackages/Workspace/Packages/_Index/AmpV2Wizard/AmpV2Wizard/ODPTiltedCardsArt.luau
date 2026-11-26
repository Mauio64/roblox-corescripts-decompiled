local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local view = Foundation.View
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName

local vector2 = Vector2.new(50, -16)
local vector2_2 = Vector2.new(-50, 16)

local function renderCard(props)
	return React.createElement(view, {
		tag = "col align-x-center align-y-center anchor-center-center stroke-standard stroke-default radius-large bg-surface-0",
		Size = UDim2.fromOffset(112, 112),
		Position = UDim2.new(0.5, props.offset.X, 0.5, props.offset.Y),
		Rotation = props.rotation,
		ZIndex = props.zIndex
	}, { Glyph = props.glyph })
end

local function ODPTiltedCardsArt(p2)
	return React.createElement(
		view,
		{
			tag = "size-full-0",
			Size = UDim2.new(1, 0, 0, 200),
			LayoutOrder = p2.LayoutOrder,
			testId = "amp-v2-wizard-tilted-cards-art"
		},
		{
			ShieldCard = renderCard({
				offset = vector2,
				rotation = 15,
				zIndex = 1,
				glyph = React.createElement(icon, {
					name = iconName.ShieldCheck,
					size = 64,
					tag = "content-emphasis"
				})
			}),
			PeopleCard = renderCard({
				offset = vector2_2,
				rotation = -15,
				zIndex = 2,
				glyph = React.createElement(icon, {
					name = iconName.PersonWithSmallerPerson,
					size = 64,
					tag = "content-emphasis"
				})
			})
		}
	)
end

return ODPTiltedCardsArt
