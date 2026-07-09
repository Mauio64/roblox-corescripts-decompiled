local Parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(Parent.UIBlox)
local GuiService = game:GetService("GuiService")
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind

require(script.Parent.Types)

local React = require(Parent.React)

local function onSelectionGained(p1) -- line: 21
	-- upvalues: GuiService (copy)
	GuiService:Select(p1)
end
local function DetailsPageRenderItem(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), useSelectionCursor (copy), CursorKind (copy), onSelectionGained (copy)
	local item = t1.item
	local safeArea = t1.safeArea
	local itemPadding = t1.itemPadding
	local v14 = React.useMemo(function() -- line: 30
		-- upvalues: item (copy)
		return item.renderComponent()
	end, { item.renderComponent })
	local v15, v16 = React.useBinding(0)
	local v17 = React.useRef(nil)
	local v18 = React.useCallback(function(p2) -- line: 37
		-- upvalues: safeArea (copy), itemPadding (copy), v16 (copy)
		local ScrollingFrame = p2:FindFirstAncestorOfClass("ScrollingFrame")

		if ScrollingFrame == nil then
			return nil
		end

		local v22 = p2.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y - safeArea.Y
		local v23 = -(p2.AbsoluteSize.Y + itemPadding)

		if v22 < 1 and v23 < v22 + safeArea.Y + 1 then
			local v24 = v22 / v23

			v16(v24)
		else
			v16(0)
		end

		return nil
	end, {
		safeArea,
		itemPadding
	})
	local v19 = useSelectionCursor(CursorKind.Invisible)

	return React.createElement("CanvasGroup", {
		key = item.key,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = v17,
		[React.Change.AbsolutePosition] = v18,
		GroupTransparency = v15,
		BackgroundTransparency = 1,
		Selectable = item.useSelectionBumper,
		SelectionImageObject = v19,
		[React.Event.SelectionGained] = onSelectionGained
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, safeArea.X),
			PaddingRight = UDim.new(0, safeArea.X)
		}),
		View = v14
	})
end

return DetailsPageRenderItem
