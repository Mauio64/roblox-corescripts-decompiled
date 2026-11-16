local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/AppCommonLib").Text
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization

local formatDate = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/formatDate")
local getVirtualEventDates = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getVirtualEventDates")
local getEventCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getEventCategory")
local AttendanceChip = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/AttendanceChip")
local DescriptionExpander = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/DescriptionExpander")

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local useTokens = Foundation.Hooks.useTokens
local text2 = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize

local function EventDetailsBody(props)
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		if props.virtualEvent.description == nil then
			return nil
		end

		return text.Trim(props.virtualEvent.description)
	end, { props.virtualEvent.description })

	local v7 = React.useMemo(function()
		return getEventCategory(props.virtualEvent)
	end, { props.virtualEvent })

	local v8 = React.useMemo(function()
		return getVirtualEventDates(props.virtualEvent)
	end, { props.virtualEvent })

	local v9 = useLocalization({
		interested = "Feature.VirtualEvents.AttendanceBeforeEvent",
		newContent = "Feature.VirtualEvents.Label.NewContent",
		itemDrop = "Feature.VirtualEvents.Label.ItemDrop",
		newSeason = "Feature.VirtualEvents.Label.NewSeason",
		newLocation = "Feature.VirtualEvents.Label.NewLocation",
		newMap = "Feature.VirtualEvents.Label.NewMap",
		moreLevels = "Feature.VirtualEvents.Label.MoreLevels",
		newFeature = "Feature.VirtualEvents.Label.NewFeature",
		earlyAccess = "Feature.VirtualEvents.Label.EarlyAccess",
		expansion = "Feature.VirtualEvents.Label.Expansion",
		challenge = "Feature.VirtualEvents.Label.Challenge",
		quest = "Feature.VirtualEvents.Label.Quest",
		festival = "Feature.VirtualEvents.Label.Festival"
	})

	local createElement = React.createElement
	local v11 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement2 = React.createElement
	local v14 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 1 }

	local v15 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		}),
		EventAttendace = React.createElement(AttendanceChip, {
			LayoutOrder = 1,
			virtualEvent = props.virtualEvent,
			eventStatus = props.eventStatus
		}),
		EventTitle = React.createElement(text2, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Text = props.virtualEvent.title,
			TextTruncate = Enum.TextTruncate.None,
			AutomaticSize = Enum.AutomaticSize.Y,
			RichText = true,
			textStyle = v5.Color.Content.Emphasis,
			fontStyle = v5.Typography.TitleLarge,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = false
		}),
		Description = 0,
		EventCategory = 0,
		EventTime = 0
	}

	local v16 = if v6 and v6 ~= "" then React.createElement(DescriptionExpander, {
		layoutOrder = 3,
		description = v6,
		width = props.containerSize.X - 32 - 16,
		maxHeight = props.containerSize.Y * 0.3,
		isExpanded = props.isExpanded,
		setIsExpanded = props.setIsExpanded
	}) else nil
	v15.Description = v16

	local v17 = if v7 and v9[v7] then React.createElement(
		"Frame",
		{
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 6)
			}),
			Icon = React.createElement(icon, {
				LayoutOrder = 1,
				name = "icons/common/poi_small",
				size = iconSize.Small,
				style = v5.Color.Content.Emphasis
			}),
			Label = React.createElement(text2, {
				LayoutOrder = 2,
				Text = v9[v7],
				TextTruncate = Enum.TextTruncate.None,
				textStyle = v5.Color.Content.Emphasis,
				fontStyle = v5.Typography.BodyLarge,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = false
			})
		}
	) else nil
	v15.EventCategory = v17

	local v18 = if props.eventStatus == "Upcoming" then React.createElement(
		"Frame",
		{
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 6)
			}),
			Icon = React.createElement(icon, {
				LayoutOrder = 1,
				name = "icons/actions/calendar_small",
				size = iconSize.Small,
				style = v5.Color.Content.Emphasis
			}),
			Label = React.createElement(text2, {
				LayoutOrder = 2,
				Text = formatDate(v8.startDate, true),
				TextTruncate = Enum.TextTruncate.None,
				textStyle = v5.Color.Content.Emphasis,
				fontStyle = v5.Typography.BodyLarge,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = false
			})
		}
	) else nil
	v15.EventTime = v18
	return createElement("Frame", v11, {
		BodyContainer = createElement2("Frame", v14, v15)
	})
end

return EventDetailsBody
