local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")

local defineFastFlag = game:DefineFastFlag("LuaAppSduiSlotOverlayZIndex", false)

local v5 = {
	topLeftSlot = { AnchorPoint = Vector2.zero, Position = UDim2.fromScale(0, 0) },
	topMiddleSlot = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0)
	},
	topRightSlot = { AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0) },
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

local function SduiSlotOverlay(data)
	local layoutOrder = data.layoutOrder
	local anchorPoint = data.anchorPoint
	local automaticSize = data.automaticSize
	local size = data.size
	local position = data.position

	local padding = data.padding or 0
	local v6 = React.useMemo(function()
		local children = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, padding),
				PaddingTop = UDim.new(0, padding),
				PaddingRight = UDim.new(0, padding),
				PaddingBottom = UDim.new(0, padding)
			})
		}

		for k, v7 in v5 do
			if data[k] ~= nil then
				children[k] = React.createElement("Frame", {
					AnchorPoint = v7.AnchorPoint,
					AutomaticSize = Enum.AutomaticSize.XY,
					Position = v7.Position,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0),
					[React.Tag] = `data-testid=--sdui-slot-{k}`
				}, { item = data[k] })
			end
		end

		return children
	end, {
		data.topLeftSlot,
		data.topMiddleSlot,
		data.topRightSlot,
		data.centerLeftSlot,
		data.centerMiddleSlot,
		data.centerRightSlot,
		data.bottomLeftSlot,
		data.bottomMiddleSlot,
		data.bottomRightSlot,
		padding
	})

	local createElement = React.createElement
	local v8 = {
		["LayoutOrder"] = layoutOrder,
		AnchorPoint = anchorPoint,
		AutomaticSize = automaticSize,
		Size = size or UDim2.new(1, 0, 1, 0),
		Position = position,
		BackgroundTransparency = 1
	}

	local v9 = if defineFastFlag then data.zIndex else nil
	v8.ZIndex = v9
	v8[React.Tag] = "data-testid=--sdui-slot-overlay"
	return createElement("Frame", v8, v6)
end

return React.memo(SduiSlotOverlay)
