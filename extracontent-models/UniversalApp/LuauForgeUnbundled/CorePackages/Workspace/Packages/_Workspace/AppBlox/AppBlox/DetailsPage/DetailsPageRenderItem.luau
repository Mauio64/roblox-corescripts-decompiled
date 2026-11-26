local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local GuiService = game:GetService("GuiService")
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/Types")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local function onSelectionGained(p2)
	GuiService:Select(p2)
end

local function DetailsPageRenderItem(props)
	local item = props.item
	local safeArea = props.safeArea
	local itemPadding = props.itemPadding

	local v5 = React.useMemo(function()
		return item.renderComponent()
	end, { item.renderComponent })

	local v6, v7 = React.useBinding(0)

	local ref = React.useRef(nil)
	local v8 = React.useCallback(function(instance): nil
		local scrollingFrame = instance:FindFirstAncestorOfClass("ScrollingFrame")

		if scrollingFrame == nil then
			return nil
		end

		local v9 = instance.AbsolutePosition.Y - scrollingFrame.AbsolutePosition.Y - safeArea.Y
		local v10 = -(instance.AbsoluteSize.Y + itemPadding)

		if v9 < 1 and v10 < v9 + safeArea.Y + 1 then
			v7(v9 / v10)
		else
			v7(0)
		end

		return nil
	end, { safeArea, itemPadding })

	local v9 = useSelectionCursor(cursorKind.Invisible)

	return React.createElement("CanvasGroup", {
		key = item.key,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = ref,
		[React.Change.AbsolutePosition] = v8,
		GroupTransparency = v6,
		BackgroundTransparency = 1,
		Selectable = item.useSelectionBumper,
		SelectionImageObject = v9,
		[React.Event.SelectionGained] = onSelectionGained
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, safeArea.X),
			PaddingRight = UDim.new(0, safeArea.X)
		}),
		View = v5
	})
end

return DetailsPageRenderItem
