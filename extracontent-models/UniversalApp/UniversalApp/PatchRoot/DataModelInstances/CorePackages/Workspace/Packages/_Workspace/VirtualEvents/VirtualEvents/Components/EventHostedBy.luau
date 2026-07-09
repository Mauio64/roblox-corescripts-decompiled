local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local EventHostName = require(VirtualEvents.Components.EventHostName)

require(VirtualEvents.Parent.VirtualEventsState)

local Foundation = require(VirtualEvents.Parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local Cell = UIBlox.App.Table.Cell
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail
local CellTailDescription = UIBlox.App.Table.CellTailDescription
local useStyle = UIBlox.Core.Style.useStyle
local t1 = {
	size = UDim2.new(1, 0, 0, 52)
}

local function EventHostedBy(t2: {[any]: any}) -- line: 29
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useLocalization (copy), useCursor (copy), Foundation (copy), React (copy), Cell (copy), CellHeadDetail (copy), CellTailDescription (copy), EventHostName (copy)
	local u16 = Cryo.Dictionary.join(t1, t2)
	local v17 = useStyle()
	local v18 = useLocalization({
		hostedBy = "Feature.VirtualEvents.HostedByLabel"
	})
	local v19 = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local v20 = React.useCallback(function() -- line: 38
		-- upvalues: u16 (ref)
		if u16.onActivated then
			u16.onActivated(u16.host)
		end
	end, { u16 })

	return React.createElement(Cell, {
		userInteractionEnabled = true,
		horizontalPadding = 0,
		layoutWraps = true,
		selectionCursor = v19,
		size = u16.size,
		onActivated = v20,
		head = React.createElement(CellHeadDetail, {
			labelText = v18.hostedBy,
			labelTextColor = v17.Theme.TextDefault,
			labelTextFont = v17.Font.Body
		}),
		tail = React.createElement(CellTailDescription, {
			text = "",
			showArrow = true,
			renderTextOverride = function() -- line: 57
				-- upvalues: React (copy), EventHostName (copy), u16 (ref)
				return React.createElement(EventHostName, {
					host = u16.host
				})
			end
		})
	})
end

return EventHostedBy
