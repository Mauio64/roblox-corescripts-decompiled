local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local formatNumberWithShortUnits = require(VirtualEvents.Common.formatNumberWithShortUnits)
require(VirtualEvents.Parent.VirtualEventsState)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local iconsstatusgamespeopleplaying_small = Images["icons/status/games/people-playing_small"]

local udim = UDim.new(0, 6)

local function AttendanceCount(props)
	local v = useStyle()
	local v2 = useLocalization({
		interested = "Feature.VirtualEvents.AttendanceBeforeEvent",
		attendingNow = "Feature.VirtualEvents.AttendanceDuringEvent"
	})

	local v3 = props.eventStatus == "Ongoing"

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v5 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = udim
		}),
		Icon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(18, 18),
			Image = iconsstatusgamespeopleplaying_small,
			ImageColor3 = v.Theme.IconEmphasis.Color,
			BackgroundTransparency = 1
		}),
		Label = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		layoutOrder = 2,
		fontStyle = v.Font.Header1,
		colorStyle = v.Theme.TextEmphasis,
		text = 0
	}

	local v7 = if v3 then props.attending else props.interested
	local v8 = formatNumberWithShortUnits(v7)
	local v9 = if v3 then v2.attendingNow else v2.interested
	v6.text = ("%s %s"):format(v8, v9)
	v5.Label = createElement2(StyledTextLabel, v6)
	return createElement("Frame", v4, v5)
end

return AttendanceCount
