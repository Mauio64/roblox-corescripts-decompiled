local parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(parent.UIBlox)
local GuiService = game:GetService("GuiService")
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind

require(script.Parent.Types)

local React = require(parent.React)

local function onSelectionGained(p)
	GuiService:Select(p)
end

local function DetailsPageRenderItem(props)
	local item = props.item
	local safeArea = props.safeArea
	local itemPadding = props.itemPadding

	local view = React.useMemo(function()
		return item.renderComponent()
	end, { item.renderComponent })

	local groupTransparency, v = React.useBinding(0)

	local ref = React.useRef(nil)
	local v2 = React.useCallback(function(instance): nil
		local scrollingFrame = instance:FindFirstAncestorOfClass("ScrollingFrame")

		if scrollingFrame == nil then
			return nil
		end

		local v2 = instance.AbsolutePosition.Y - scrollingFrame.AbsolutePosition.Y - safeArea.Y
		local v3 = -(instance.AbsoluteSize.Y + itemPadding)

		if v2 < 1 and v3 < v2 + safeArea.Y + 1 then
			v(v2 / v3)
		else
			v(0)
		end

		return nil
	end, { safeArea, itemPadding })

	local selectionImageObject = useSelectionCursor(CursorKind.Invisible)

	return React.createElement("CanvasGroup", {
		key = item.key,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = ref,
		[React.Change.AbsolutePosition] = v2,
		GroupTransparency = groupTransparency,
		BackgroundTransparency = 1,
		Selectable = item.useSelectionBumper,
		SelectionImageObject = selectionImageObject,
		[React.Event.SelectionGained] = onSelectionGained
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, safeArea.X),
			PaddingRight = UDim.new(0, safeArea.X)
		}),
		View = view
	})
end

return DetailsPageRenderItem
