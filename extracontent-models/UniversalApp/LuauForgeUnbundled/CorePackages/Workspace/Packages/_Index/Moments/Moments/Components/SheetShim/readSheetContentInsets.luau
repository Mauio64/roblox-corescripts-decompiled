require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/SheetShimTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim/getSheetStructure")

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
		local v5 = scroller.CanvasSize.Y.Offset + container.Position.Y.Offset
		local parent = sheet.Parent
		local v6

		if parent == nil or not parent:IsA("GuiBase2d") then
			v6 = sheet.AbsoluteSize.Y
		else
			v6 = parent.AbsoluteSize.Y
		end

		return {
			bottom = math.clamp(scroller.CanvasPosition.Y - v5, 0, v6),
			right = 0
		}
	end
end

return readSheetContentInsets
