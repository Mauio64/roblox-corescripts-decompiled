local ParentParent = script.Parent.Parent.Parent
local Otter = require(ParentParent.Otter)
local Roact = require(ParentParent.Roact)
local Cryo = require(ParentParent.Cryo)
local t = require(ParentParent.t)
local withStyle = require(ParentParent.UIBlox.Core.Style.withStyle)
local ModalBottomSheetButton = require(script.Parent.ModalBottomSheetButton)
local v8 = Roact.PureComponent:extend("ModalBottomSheet")
local t1 = {
	frequency = 4,
	dampingRatio = 1
}

v8.validateProps = t.strictInterface({
	buttonModels = t.array(t.table),
	screenWidth = t.number,
	onDismiss = t.callback,
	showImages = t.optional(t.boolean),
	bottomGap = t.optional(t.number),
	sheetContentXSize = t.optional(t.UDim),
	sheetContentXPosition = t.optional(t.UDim)
})
v8.defaultProps = {
	bottomGap = 0,
	showImages = true,
	sheetContentXSize = UDim.new(1, 0),
	sheetContentXPosition = UDim.new(0, 0)
}

function v8.init(p1) -- line: 49
	-- upvalues: Otter (copy), Roact (copy)
	p1.motor = Otter.createSingleMotor(0)
	p1.ref = Roact.createRef()
	p1.active = true
end
function v8.render(p2) -- line: 55
	-- upvalues: Cryo (copy), Roact (copy), ModalBottomSheetButton (copy), withStyle (copy), Otter (copy), t1 (copy)
	local sheetContentXPosition = p2.props.sheetContentXPosition
	local sheetContentXSize = p2.props.sheetContentXSize

	p2.sheetHeight = #p2.props.buttonModels * 56

	if #p2.props.buttonModels >= 7 then
		p2.sheetHeight = 420
	end

	local t2 = {}

	for i, v in ipairs(p2.props.buttonModels) do
		local v17 = Cryo.Dictionary.join(v, {
			elementHeight = 56,
			hasRoundTop = i == 1,
			hasRoundBottom = i == #p2.props.buttonModels,
			isFixed = p2.props.screenWidth > 600,
			showImage = p2.props.showImages,
			LayoutOrder = i,
			onActivatedAndDismissed = function(p3) -- line: 72
				-- upvalues: v (copy), p2 (copy)
				if v.onActivated then
					v.onActivated(p3)
				end

				if not v.stayOnActivated then
					p2.props.onDismiss()
				end
			end
		})

		t2["button " .. i] = Roact.createElement(ModalBottomSheetButton, v17)
	end

	t2.layout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return withStyle(function(p4) -- line: 91
		-- upvalues: Roact (copy), p2 (copy), Otter (copy), t1 (copy), sheetContentXSize (copy), sheetContentXPosition (copy), t2 (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Background = Roact.createElement("TextButton", {
				ZIndex = 0,
				AutoButtonColor = false,
				BackgroundColor3 = p4.Theme.Overlay.Color,
				BackgroundTransparency = p4.Theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Selectable = false,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				[Roact.Event.Activated] = function() -- line: 106
					-- upvalues: p2 (copy), Otter (copy), t1 (copy)
					p2.active = false
					p2.motor:setGoal(Otter.spring(0, t1))
				end
			}),
			SheetContent = Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(sheetContentXSize.Scale, sheetContentXSize.Offset, 0, p2.sheetHeight),
				Position = UDim2.new(sheetContentXPosition.Scale, sheetContentXPosition.Offset, 1, 0),
				Selectable = false,
				ScrollBarThickness = 0,
				CanvasSize = UDim2.new(sheetContentXSize.Scale, sheetContentXSize.Offset, 0, #p2.props.buttonModels * 56),
				ClipsDescendants = true,
				[Roact.Ref] = p2.ref
			}, t2)
		})
	end)
end
function v8.didMount(p5) -- line: 130
	-- upvalues: Otter (copy), t1 (copy)
	local sheetContentXPosition = p5.props.sheetContentXPosition

	p5.motor:onStep(function(p6) -- line: 132
		-- upvalues: p5 (copy), sheetContentXPosition (copy)
		if p5.ref.current then
			p5.ref.current.Position = UDim2.new(sheetContentXPosition.Scale, sheetContentXPosition.Offset, 1, -(p5.sheetHeight + p5.props.bottomGap) * p6)
		end
	end)
	p5.motor:setGoal(Otter.spring(1, t1))
	p5.motor:onComplete(function() -- line: 143
		-- upvalues: p5 (copy)
		if not p5.active then
			p5.props.onDismiss()
		end
	end)
	p5.motor:start()
end
function v8.willUnmount(p7) -- line: 151
	p7.motor:destroy()
end

return v8
