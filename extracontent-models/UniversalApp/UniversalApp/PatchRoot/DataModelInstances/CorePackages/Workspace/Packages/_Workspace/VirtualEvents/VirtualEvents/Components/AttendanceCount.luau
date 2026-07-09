local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local formatNumberWithShortUnits = require(VirtualEvents.Common.formatNumberWithShortUnits)

require(VirtualEvents.Parent.VirtualEventsState)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local v10 = Images["icons/status/games/people-playing_small"]
local uDim = UDim.new(0, 6)

local function AttendanceCount(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), uDim (copy), ImageSetLabel (copy), v10 (copy), StyledTextLabel (copy), formatNumberWithShortUnits (copy)
	local v14 = useStyle()
	local v15 = useLocalization({
		interested = "Feature.VirtualEvents.AttendanceBeforeEvent",
		attendingNow = "Feature.VirtualEvents.AttendanceDuringEvent"
	})
	local v16 = t1.eventStatus == "Ongoing"

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = uDim
		}),
		Icon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(18, 18),
			Image = v10,
			ImageColor3 = v14.Theme.IconEmphasis.Color
		}),
		Label = React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			fontStyle = v14.Font.Header1,
			colorStyle = v14.Theme.TextEmphasis,
			text = ("%s %s"):format(formatNumberWithShortUnits(if not v16 then t1.interested else t1.attending), if not v16 then v15.interested else v15.attendingNow)
		})
	})
end

return AttendanceCount
