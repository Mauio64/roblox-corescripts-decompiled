local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Skeleton = require(VirtualEvents.Parent.Foundation).Skeleton
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local ExperienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local uDim2 = UDim2.new(0, 150, 0, 210)

local function EventDescription(t1: {[any]: any}) -- line: 28
	-- upvalues: useStyle (copy), useLocalization (copy), useTextSizeOffset (copy), uDim2 (copy), React (copy), StyledTextLabel (copy), Skeleton (copy), ExperienceTileV3 (copy)
	local v13 = useStyle()
	local v14 = useLocalization({
		header = "Feature.VirtualEvents.DescriptionLabel"
	})
	local v15 = useTextSizeOffset()
	local v16 = uDim2 + UDim2.fromOffset(0, v15 * 2)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 32)
		}),
		DescriptionHeader = React.createElement(StyledTextLabel, {
			layoutOrder = 0,
			text = v14.header,
			automaticSize = Enum.AutomaticSize.XY,
			fontStyle = v13.Font.Header1,
			colorStyle = v13.Theme.TextEmphasis
		}),
		Description = if not t1.description then React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v13.Font.BaseSize)
		}) else React.createElement(StyledTextLabel, {
			layoutOrder = 1,
			text = t1.description,
			automaticSize = Enum.AutomaticSize.XY,
			fontStyle = v13.Font.Body,
			colorStyle = v13.Theme.TextDefault
		}),
		ExperienceTileWrapper = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = v16
		}, {
			ExperienceTile = React.createElement(ExperienceTileV3, {
				experienceName = t1.experienceName,
				thumbnail = t1.experienceThumbnail,
				onActivated = t1.onExperienceTileActivated,
				styleProps = {
					overlayColors = {
						Hover = v13.Theme.BackgroundOnHover
					}
				}
			})
		})
	})
end

return EventDescription
