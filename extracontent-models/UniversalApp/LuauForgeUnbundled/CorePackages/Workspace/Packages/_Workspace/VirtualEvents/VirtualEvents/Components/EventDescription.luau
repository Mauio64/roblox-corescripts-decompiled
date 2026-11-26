local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local skeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation").Skeleton

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization

local experienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local udim = UDim2.new(0, 150, 0, 210)

local function EventDescription(props)
	local v5 = useStyle()
	local v6 = useLocalization({ header = "Feature.VirtualEvents.DescriptionLabel" })

	local v7 = useTextSizeOffset()
	local v8 = udim + UDim2.fromOffset(0, v7 * 2)

	local createElement = React.createElement
	local v10 = { AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 }

	local v11 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 32)
		}),
		DescriptionHeader = React.createElement(styledTextLabel, {
			layoutOrder = 0,
			text = v6.header,
			automaticSize = Enum.AutomaticSize.XY,
			fontStyle = v5.Font.Header1,
			colorStyle = v5.Theme.TextEmphasis
		}),
		Description = 0,
		ExperienceTileWrapper = 0
	}

	local v12 = if props.description then React.createElement(styledTextLabel, {
		layoutOrder = 1,
		text = props.description,
		automaticSize = Enum.AutomaticSize.XY,
		fontStyle = v5.Font.Body,
		colorStyle = v5.Theme.TextDefault
	}) else React.createElement(skeleton, {
		Size = UDim2.new(1, 0, 0, v5.Font.BaseSize)
	})
	v11.Description = v12

	v11.ExperienceTileWrapper = React.createElement(
		"Frame",
		{ LayoutOrder = 2, Size = v8, BackgroundTransparency = 1 },
		{
			ExperienceTile = React.createElement(experienceTileV3, {
				experienceName = props.experienceName,
				thumbnail = props.experienceThumbnail,
				onActivated = props.onExperienceTileActivated,
				styleProps = {
					overlayColors = { Hover = v5.Theme.BackgroundOnHover }
				}
			})
		}
	)
	return createElement("Frame", v10, v11)
end

return EventDescription
