require(script.Parent.SheetShimTypes)
require(script.Parent.getSheetStructure)

local function readSheetContentInsets(data)
	local sheet = data.sheet
	local scroller = data.scroller
	local container = data.container

	if scroller == nil or container == nil then
		if data.kind == "side" then
			return {
				bottom = 0,
				right = math.clamp(-sheet.Position.X.Offset, 0, sheet.Size.X.Offset)
			}
		end

		return { bottom = 0, right = 0 }
	else
		local v = scroller.CanvasSize.Y.Offset + container.Position.Y.Offset
		local parent = sheet.Parent
		local v2

		if parent == nil or not parent:IsA("GuiBase2d") then
			v2 = sheet.AbsoluteSize.Y
		else
			v2 = parent.AbsoluteSize.Y
		end

		return {
			bottom = math.clamp(scroller.CanvasPosition.Y - v, 0, v2),
			right = 0
		}
	end
end

return readSheetContentInsets
