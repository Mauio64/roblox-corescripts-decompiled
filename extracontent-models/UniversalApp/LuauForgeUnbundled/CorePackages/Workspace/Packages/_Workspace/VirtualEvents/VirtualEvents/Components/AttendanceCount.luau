local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local formatNumberWithShortUnits = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/formatNumberWithShortUnits")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local iconsstatusgamespeopleplaying_small = images["icons/status/games/people-playing_small"]

local udim = UDim.new(0, 6)

local function AttendanceCount(props)
	local v5 = useStyle()
	local v6 = useLocalization({
		interested = "Feature.VirtualEvents.AttendanceBeforeEvent",
		attendingNow = "Feature.VirtualEvents.AttendanceDuringEvent"
	})

	local v7 = props.eventStatus == "Ongoing"

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v10 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = udim
		}),
		Icon = React.createElement(imageSetLabel, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(18, 18),
			Image = iconsstatusgamespeopleplaying_small,
			ImageColor3 = v5.Theme.IconEmphasis.Color,
			BackgroundTransparency = 1
		}),
		Label = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		layoutOrder = 2,
		fontStyle = v5.Font.Header1,
		colorStyle = v5.Theme.TextEmphasis,
		text = 0
	}

	local v15 = if v7 then props.attending else props.interested
	local v16 = formatNumberWithShortUnits(v15)
	local v17 = if v7 then v6.attendingNow else v6.interested
	v12.text = ("%s %s"):format(v16, v17)
	v10.Label = createElement2(styledTextLabel, v12)
	return createElement("Frame", v9, v10)
end

return AttendanceCount
