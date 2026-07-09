local TenFootUiGlobalNav = script:FindFirstAncestor("TenFootUiGlobalNav")
local TenFootUiGlobalNavParent = TenFootUiGlobalNav.Parent
local React = require(TenFootUiGlobalNavParent.React)
local Cryo = require(TenFootUiGlobalNavParent.Cryo)
local GlobalNavOption = require(script.Parent.GlobalNavOption)
local GlobalNavOptionTooltip = require(script.Parent.GlobalNavOptionTooltip)
local eraseKeys = require(TenFootUiGlobalNav.Components.utils.eraseKeys)

local function makeButtonTooltipMap(p1, t1: {[any]: any}) -- line: 17
	-- upvalues: Cryo (copy)
	local v13 = Cryo.List.filter(p1:GetDescendants(), function(p2, _) -- line: 21
		return p2:IsA("ImageButton")
	end)

	return Cryo.List.foldLeft(v13, function(p4, p5, p6) -- line: 25
		-- upvalues: t1 (copy)
		p4[p5] = if not t1[p6] then nil else t1[p6].label

		return p4
	end, {})
end
local function makeToolTipProps(p7, p8, t2: {[any]: any}) -- line: 31
	local v17 = t2[p7]

	if v17 then
		return {
			label = v17,
			xOffset = p7.AbsolutePosition.X - p8.AbsolutePosition.X + p7.Size.X.Offset / 2,
			yOffset = p7.Position.Y.Offset + p7.Size.Y.Offset - 10
		}
	end

	return nil
end
local function GlobalNavOptionGroup(t3: {[any]: any}) -- line: 54
	-- upvalues: React (copy), eraseKeys (copy), Cryo (copy), GlobalNavOption (copy), makeButtonTooltipMap (copy), makeToolTipProps (copy), GlobalNavOptionTooltip (copy)
	local v19, v20 = React.useState(nil)
	local v21 = eraseKeys({
		"items",
		"spacing"
	}, t3)
	local v22 = Cryo.List.map(t3.items, function(t4: {[any]: any}, n1: number) -- line: 58
		-- upvalues: React (copy), GlobalNavOption (copy)
		return React.createElement(GlobalNavOption, {
			key = t4.label .. "-" .. n1,
			icon = t4.icon,
			onActivated = t4.onActivated
		})
	end)

	return React.createElement("Frame", Cryo.Dictionary.join({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, v21), React.createElement("Frame", {
		Name = "Options",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[React.Event.SelectionChanged] = function(p9, _, _, p12) -- line: 79
			-- upvalues: makeButtonTooltipMap (copy), t3 (copy), v20 (copy), makeToolTipProps (copy)
			local v34 = makeButtonTooltipMap(p9, t3.items)

			v20((makeToolTipProps(p12, p9, v34)))
		end
	}, React.createElement("UIListLayout", {
		key = "globalNavOptionGroupLayout",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, t3.spacing or 0)
	}), table.unpack(v22)), if not v19 then nil else React.createElement(GlobalNavOptionTooltip, v19))
end

return GlobalNavOptionGroup
