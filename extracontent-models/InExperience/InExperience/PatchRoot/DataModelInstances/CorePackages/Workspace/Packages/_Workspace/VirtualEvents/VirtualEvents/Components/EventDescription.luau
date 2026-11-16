local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Foundation = require(VirtualEvents.Parent.Foundation)
local Skeleton = Foundation.Skeleton

local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ExperienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local udim = UDim2.new(0, 150, 0, 210)

local function EventDescription(props)
	local v = useStyle()
	local v2 = useLocalization({ header = "Feature.VirtualEvents.DescriptionLabel" })

	local v3 = useTextSizeOffset()
	local size = udim + UDim2.fromOffset(0, v3 * 2)

	local createElement = React.createElement
	local v4 = { AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 }

	local v5 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 32)
		}),
		DescriptionHeader = React.createElement(StyledTextLabel, {
			layoutOrder = 0,
			text = v2.header,
			automaticSize = Enum.AutomaticSize.XY,
			fontStyle = v.Font.Header1,
			colorStyle = v.Theme.TextEmphasis
		}),
		Description = 0,
		ExperienceTileWrapper = 0
	}
	local description

	if props.description then
		description = React.createElement(StyledTextLabel, {
			layoutOrder = 1,
			text = props.description,
			automaticSize = Enum.AutomaticSize.XY,
			fontStyle = v.Font.Body,
			colorStyle = v.Theme.TextDefault
		})
	else
		description = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v.Font.BaseSize)
		})
	end

	v5.Description = description

	v5.ExperienceTileWrapper = React.createElement(
		"Frame",
		{ LayoutOrder = 2, Size = size, BackgroundTransparency = 1 },
		{
			ExperienceTile = React.createElement(ExperienceTileV3, {
				experienceName = props.experienceName,
				thumbnail = props.experienceThumbnail,
				onActivated = props.onExperienceTileActivated,
				styleProps = {
					overlayColors = { Hover = v.Theme.BackgroundOnHover }
				}
			})
		}
	)
	return createElement("Frame", v4, v5)
end

return EventDescription
