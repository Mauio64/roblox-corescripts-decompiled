local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)
require(VirtualEvents.Parent.GraphQLServer)
local AppCommonLib = require(VirtualEvents.Parent.AppCommonLib)
local Text = AppCommonLib.Text
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local formatDate = require(VirtualEvents.Common.formatDate)
local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)
local getEventCategory = require(VirtualEvents.Common.getEventCategory)
local AttendanceChip = require(VirtualEvents.Components.AttendanceChip)
local DescriptionExpander = require(VirtualEvents.Components.DescriptionExpander)

require(VirtualEvents.Parent.VirtualEventsState)

local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function EventDetailsBody(props)
	local v = useTokens()

	local description = React.useMemo(function()
		if props.virtualEvent.description == nil then
			return nil
		end

		return Text.Trim(props.virtualEvent.description)
	end, { props.virtualEvent.description })

	local v2 = React.useMemo(function()
		return getEventCategory(props.virtualEvent)
	end, { props.virtualEvent })

	local v3 = React.useMemo(function()
		return getVirtualEventDates(props.virtualEvent)
	end, { props.virtualEvent })

	local v4 = useLocalization({
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
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement2 = React.createElement
	local v6 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 1 }

	local v7 = {
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
		EventTitle = React.createElement(text, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Text = props.virtualEvent.title,
			TextTruncate = Enum.TextTruncate.None,
			AutomaticSize = Enum.AutomaticSize.Y,
			RichText = true,
			textStyle = v.Color.Content.Emphasis,
			fontStyle = v.Typography.TitleLarge,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = false
		}),
		Description = 0,
		EventCategory = 0,
		EventTime = 0
	}
	local description2

	if description and description ~= "" then
		description2 = React.createElement(DescriptionExpander, {
			layoutOrder = 3,
			description = description,
			width = props.containerSize.X - 32 - 16,
			maxHeight = props.containerSize.Y * 0.3,
			isExpanded = props.isExpanded,
			setIsExpanded = props.setIsExpanded
		})
	end

	v7.Description = description2
	local eventCategory

	if v2 and v4[v2] then
		eventCategory = React.createElement(
			"Frame",
			{ LayoutOrder = 4, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y },
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 6)
				}),
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = "icons/common/poi_small",
					size = IconSize.Small,
					style = v.Color.Content.Emphasis
				}),
				Label = React.createElement(text, {
					LayoutOrder = 2,
					Text = v4[v2],
					TextTruncate = Enum.TextTruncate.None,
					textStyle = v.Color.Content.Emphasis,
					fontStyle = v.Typography.BodyLarge,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = false
				})
			}
		)
	end

	v7.EventCategory = eventCategory
	local eventTime

	if props.eventStatus == "Upcoming" then
		eventTime = React.createElement(
			"Frame",
			{ LayoutOrder = 5, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y },
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 6)
				}),
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = "icons/actions/calendar_small",
					size = IconSize.Small,
					style = v.Color.Content.Emphasis
				}),
				Label = React.createElement(text, {
					LayoutOrder = 2,
					Text = formatDate(v3.startDate, true),
					TextTruncate = Enum.TextTruncate.None,
					textStyle = v.Color.Content.Emphasis,
					fontStyle = v.Typography.BodyLarge,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = false
				})
			}
		)
	end

	v7.EventTime = eventTime
	return createElement("Frame", v5, {
		BodyContainer = createElement2("Frame", v6, v7)
	})
end

return EventDetailsBody
