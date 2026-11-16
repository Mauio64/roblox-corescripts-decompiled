local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local EventHostName = require(VirtualEvents.Components.EventHostName)
require(VirtualEvents.Parent.VirtualEventsState)
local Foundation = require(VirtualEvents.Parent.Foundation)
local useCursor = Foundation.Hooks.useCursor

local Cell = UIBlox.App.Table.Cell
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail
local CellTailDescription = UIBlox.App.Table.CellTailDescription
local useStyle = UIBlox.Core.Style.useStyle

local v = { size = UDim2.new(1, 0, 0, 52) }

local function EventHostedBy(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useStyle()
	local v3 = useLocalization({ hostedBy = "Feature.VirtualEvents.HostedByLabel" })

	local selectionCursor = useCursor(Foundation.Enums.CursorType.RoundedRect)

	local onActivated = React.useCallback(function()
		if joined.onActivated then
			joined.onActivated(joined.host)
		end
	end, { joined })

	return React.createElement(Cell, {
		selectionCursor = selectionCursor,
		size = joined.size,
		userInteractionEnabled = true,
		horizontalPadding = 0,
		onActivated = onActivated,
		head = React.createElement(CellHeadDetail, {
			labelText = v3.hostedBy,
			labelTextColor = v2.Theme.TextDefault,
			labelTextFont = v2.Font.Body
		}),
		tail = React.createElement(CellTailDescription, {
			text = "",
			renderTextOverride = function()
				return React.createElement(EventHostName, { host = joined.host })
			end,
			showArrow = true
		}),
		layoutWraps = true
	})
end

return EventHostedBy
