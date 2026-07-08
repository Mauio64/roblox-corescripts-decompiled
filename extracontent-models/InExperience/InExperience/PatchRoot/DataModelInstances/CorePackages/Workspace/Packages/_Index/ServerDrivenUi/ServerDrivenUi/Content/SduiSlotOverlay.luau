local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local t1 = {
	topLeftSlot = {
		AnchorPoint = Vector2.zero,
		Position = UDim2.fromScale(0, 0)
	},
	topMiddleSlot = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0)
	},
	topRightSlot = {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0)
	},
	centerLeftSlot = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5)
	},
	centerMiddleSlot = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	},
	centerRightSlot = {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5)
	},
	bottomLeftSlot = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1)
	},
	bottomMiddleSlot = {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1)
	},
	bottomRightSlot = {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1)
	}
}

local function SduiSlotOverlay(t2: {[any]: any}) -- line: 68
	-- upvalues: React (copy), t1 (copy)
	local layoutOrder = t2.layoutOrder
	local anchorPoint = t2.anchorPoint
	local automaticSize = t2.automaticSize
	local size = t2.size
	local position = t2.position
	local v11 = t2.padding or 0
	local v12 = React.useMemo(function() -- line: 77
		-- upvalues: React (copy), v11 (copy), t1 (copy), t2 (copy)
		local t3 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v11),
				PaddingTop = UDim.new(0, v11),
				PaddingRight = UDim.new(0, v11),
				PaddingBottom = UDim.new(0, v11)
			})
		}

		for v14, v15 in t1 do
			if t2[v14] ~= nil then
				t3[v14] = React.createElement("Frame", {
					AnchorPoint = v15.AnchorPoint,
					AutomaticSize = Enum.AutomaticSize.XY,
					Position = v15.Position,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0),
					[React.Tag] = `data-testid=--sdui-slot-{ v14 }`
				}, {
					item = t2[v14]
				})
			end
		end

		return t3
	end, {
		t2.topLeftSlot,
		t2.topMiddleSlot,
		t2.topRightSlot,
		t2.centerLeftSlot,
		t2.centerMiddleSlot,
		t2.centerRightSlot,
		t2.bottomLeftSlot,
		t2.bottomMiddleSlot,
		t2.bottomRightSlot,
		v11
	})

	return React.createElement("Frame", {
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		AutomaticSize = automaticSize,
		Size = size or UDim2.new(1, 0, 1, 0),
		Position = position,
		BackgroundTransparency = 1,
		[React.Tag] = "data-testid=--sdui-slot-overlay"
	}, v12)
end

return React.memo(SduiSlotOverlay)
