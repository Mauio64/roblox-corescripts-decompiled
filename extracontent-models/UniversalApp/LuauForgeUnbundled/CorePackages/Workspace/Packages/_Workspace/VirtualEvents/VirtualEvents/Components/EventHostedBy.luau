local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local EventHostName = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventHostName")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local useCursor = Foundation.Hooks.useCursor

local cell = UIBlox.App.Table.Cell
local cellHeadDetail = UIBlox.App.Table.CellHeadDetail
local cellTailDescription = UIBlox.App.Table.CellTailDescription
local useStyle = UIBlox.Core.Style.useStyle

local v5 = { size = UDim2.new(1, 0, 0, 52) }

local function EventHostedBy(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useStyle()
	local v7 = useLocalization({ hostedBy = "Feature.VirtualEvents.HostedByLabel" })

	local v8 = useCursor(Foundation.Enums.CursorType.RoundedRect)

	local v9 = React.useCallback(function()
		if joined.onActivated then
			joined.onActivated(joined.host)
		end
	end, { joined })

	return React.createElement(cell, {
		selectionCursor = v8,
		size = joined.size,
		userInteractionEnabled = true,
		horizontalPadding = 0,
		onActivated = v9,
		head = React.createElement(cellHeadDetail, {
			labelText = v7.hostedBy,
			labelTextColor = v6.Theme.TextDefault,
			labelTextFont = v6.Font.Body
		}),
		tail = React.createElement(cellTailDescription, {
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
