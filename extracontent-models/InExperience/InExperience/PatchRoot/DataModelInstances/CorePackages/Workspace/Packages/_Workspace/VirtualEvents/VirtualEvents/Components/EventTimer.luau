local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local formatDate = require(VirtualEvents.Common.formatDate)
local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local v = utf8.char(8226)

local function EventTimer(p)
	local v2 = useStyle()
	local v3 = useLocalization({ cancelled = "Feature.VirtualEvents.EventCancelledText" })

	local v4 = p.virtualEvent.eventStatus == "cancelled"

	local v5 = React.useMemo(function()
		return getVirtualEventDates(p.virtualEvent)
	end, { p.virtualEvent })

	local createElement = React.createElement
	local text

	if v4 then
		text = v3.cancelled
	else
		text = ("%s %s %s"):format(formatDate(v5.startDate), v, formatDate(v5.endDate))
	end

	local v6 = {
		text = text,
		automaticSize = Enum.AutomaticSize.XY,
		fontStyle = v2.Font.CaptionHeader,
		colorStyle = 0
	}
	local colorStyle = if v4 then v2.Theme.Alert else v2.Theme.TextMuted
	v6.colorStyle = colorStyle
	return createElement(StyledTextLabel, v6)
end

return EventTimer
