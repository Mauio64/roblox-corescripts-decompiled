local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Tooltip = Foundation.Tooltip
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local t1 = {
	Top = PopoverSide.Top,
	Bottom = PopoverSide.Bottom,
	Left = PopoverSide.Left,
	Right = PopoverSide.Right
}
local t2 = {
	Start = PopoverAlign.Start,
	Center = PopoverAlign.Center,
	End = PopoverAlign.End
}

local function SduiTooltip(t3: {[any]: any}) -- line: 40
	-- upvalues: React (copy), Tooltip (copy), t1 (copy), t2 (copy)
	if t3.anchor == nil then
		return nil
	end

	local v11 = if not t3.shortcut or not (#t3.shortcut > 0) then nil else t3.shortcut

	return React.createElement(Tooltip, {
		title = t3.title or "",
		text = t3.text,
		shortcut = v11,
		side = t1[t3.side or ""],
		align = t2[t3.align or ""],
		LayoutOrder = t3.layoutOrder
	}, t3.anchor)
end

return React.memo(SduiTooltip)
