require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local formatDate = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/formatDate")
local getVirtualEventDates = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getVirtualEventDates")

local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local v5 = utf8.char(8226)

local function EventTimer(p2)
	local v6 = useStyle()
	local v7 = useLocalization({
		cancelled = "Feature.VirtualEvents.EventCancelledText"
	})

	local v8 = p2.virtualEvent.eventStatus == "cancelled"

	local v9 = React.useMemo(function()
		return getVirtualEventDates(p2.virtualEvent)
	end, { p2.virtualEvent })

	local createElement = React.createElement

	local v12 = if v8 then v7.cancelled else ("%s %s %s"):format(
		formatDate(v9.startDate),
		v5,
		formatDate(v9.endDate)
	)
	local v11 = {
		text = v12,
		automaticSize = Enum.AutomaticSize.XY,
		fontStyle = v6.Font.CaptionHeader,
		colorStyle = 0
	}
	local v13 = if v8 then v6.Theme.Alert else v6.Theme.TextMuted
	v11.colorStyle = v13
	return createElement(styledTextLabel, v11)
end

return EventTimer
