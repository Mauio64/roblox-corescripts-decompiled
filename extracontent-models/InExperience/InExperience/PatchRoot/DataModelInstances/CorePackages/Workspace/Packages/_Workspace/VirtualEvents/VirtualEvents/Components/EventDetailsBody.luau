local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)

require(VirtualEvents.Parent.GraphQLServer)

local Text = require(VirtualEvents.Parent.AppCommonLib).Text
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local formatDate = require(VirtualEvents.Common.formatDate)
local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)
local getEventCategory = require(VirtualEvents.Common.getEventCategory)
local AttendanceChip = require(VirtualEvents.Components.AttendanceChip)
local DescriptionExpander = require(VirtualEvents.Components.DescriptionExpander)

require(VirtualEvents.Parent.VirtualEventsState)

local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function EventDetailsBody(t1: {[any]: any}) -- line: 36
	-- upvalues: useTokens (copy), React (copy), Text (copy), getEventCategory (copy), getVirtualEventDates (copy), useLocalization (copy), AttendanceChip (copy), FoundationText (copy), DescriptionExpander (copy), Icon (copy), IconSize (copy), formatDate (copy)
	local v17 = useTokens()
	local v18 = React.useMemo(function() -- line: 39
		-- upvalues: t1 (copy), Text (copy)
		if t1.virtualEvent.description == nil then
			return nil
		end

		return Text.Trim(t1.virtualEvent.description)
	end, { t1.virtualEvent.description })
	local v19 = React.useMemo(function() -- line: 46
		-- upvalues: getEventCategory (copy), t1 (copy)
		return getEventCategory(t1.virtualEvent)
	end, { t1.virtualEvent })
	local v20 = React.useMemo(function() -- line: 50
		-- upvalues: getVirtualEventDates (copy), t1 (copy)
		return getVirtualEventDates(t1.virtualEvent)
	end, { t1.virtualEvent })
	local v21 = useLocalization({
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

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		BodyContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			EventAttendace = React.createElement(AttendanceChip, {
				LayoutOrder = 1,
				virtualEvent = t1.virtualEvent,
				eventStatus = t1.eventStatus
			}),
			EventTitle = React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				TextWrapped = false,
				Size = UDim2.new(1, 0, 0, 0),
				Text = t1.virtualEvent.title,
				TextTruncate = Enum.TextTruncate.None,
				AutomaticSize = Enum.AutomaticSize.Y,
				textStyle = v17.Color.Content.Emphasis,
				fontStyle = v17.Typography.TitleLarge,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Description = if not v18 or v18 == "" then nil else React.createElement(DescriptionExpander, {
				layoutOrder = 3,
				description = v18,
				width = t1.containerSize.X - 32 - 16,
				maxHeight = t1.containerSize.Y * 0.3,
				isExpanded = t1.isExpanded,
				setIsExpanded = t1.setIsExpanded
			}),
			EventCategory = if not v19 or not v21[v19] then nil else React.createElement("Frame", {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
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
					style = v17.Color.Content.Emphasis
				}),
				Label = React.createElement(FoundationText, {
					LayoutOrder = 2,
					TextWrapped = false,
					Text = v21[v19],
					TextTruncate = Enum.TextTruncate.None,
					textStyle = v17.Color.Content.Emphasis,
					fontStyle = v17.Typography.BodyLarge,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			EventTime = if t1.eventStatus ~= "Upcoming" then nil else React.createElement("Frame", {
				LayoutOrder = 5,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
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
					style = v17.Color.Content.Emphasis
				}),
				Label = React.createElement(FoundationText, {
					LayoutOrder = 2,
					TextWrapped = false,
					Text = formatDate(v20.startDate, true),
					TextTruncate = Enum.TextTruncate.None,
					textStyle = v17.Color.Content.Emphasis,
					fontStyle = v17.Typography.BodyLarge,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})
		})
	})
end

return EventDetailsBody
