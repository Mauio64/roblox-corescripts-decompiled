local parent = script.Parent.Parent.Parent

local Otter = require(parent.Otter)
local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)
local t = require(parent.t)
local withStyle = require(parent.UIBlox.Core.Style.withStyle)
local ModalBottomSheetButton = require(script.Parent.ModalBottomSheetButton)

local extended = Roact.PureComponent:extend("ModalBottomSheet")

local v = { frequency = 4, dampingRatio = 1 }

extended.validateProps = t.strictInterface({
	buttonModels = t.array(t.table),
	screenWidth = t.number,
	onDismiss = t.callback,
	showImages = t.optional(t.boolean),
	bottomGap = t.optional(t.number),
	sheetContentXSize = t.optional(t.UDim),
	sheetContentXPosition = t.optional(t.UDim)
})

extended.defaultProps = {
	bottomGap = 0,
	showImages = true,
	sheetContentXSize = UDim.new(1, 0),
	sheetContentXPosition = UDim.new(0, 0)
}

function extended:init()
	self.motor = Otter.createSingleMotor(0)
	self.ref = Roact.createRef()
	self.active = true
end

function extended:render()
	local sheetContentXPosition = self.props.sheetContentXPosition
	local sheetContentXSize = self.props.sheetContentXSize

	self.sheetHeight = #self.props.buttonModels * 56

	if #self.props.buttonModels >= 7 then
		self.sheetHeight = 420
	end

	local children = {}

	for i, buttonModel in ipairs(self.props.buttonModels) do
		local joined = Cryo.Dictionary.join(buttonModel, {
			hasRoundTop = i == 1,
			hasRoundBottom = i == #self.props.buttonModels,
			isFixed = self.props.screenWidth > 600,
			elementHeight = 56,
			showImage = self.props.showImages,
			LayoutOrder = i,
			onActivatedAndDismissed = function(p)
				if buttonModel.onActivated then
					buttonModel.onActivated(p)
				end

				if not buttonModel.stayOnActivated then
					self.props.onDismiss()
				end
			end
		})

		children["button " .. i] = Roact.createElement(ModalBottomSheetButton, joined)
	end

	children.layout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return withStyle(function(p)
		return Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0 },
			{
				Background = Roact.createElement("TextButton", {
					ZIndex = 0,
					AutoButtonColor = false,
					BackgroundColor3 = p.Theme.Overlay.Color,
					BackgroundTransparency = p.Theme.Overlay.Transparency,
					BorderSizePixel = 0,
					Selectable = false,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "",
					[Roact.Event.Activated] = function()
						self.active = false
						self.motor:setGoal(Otter.spring(0, v))
					end
				}),
				SheetContent = Roact.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(sheetContentXSize.Scale, sheetContentXSize.Offset, 0, self.sheetHeight),
					Position = UDim2.new(sheetContentXPosition.Scale, sheetContentXPosition.Offset, 1, 0),
					Selectable = false,
					ScrollBarThickness = 0,
					CanvasSize = UDim2.new(
						sheetContentXSize.Scale,
						sheetContentXSize.Offset,
						0,
						#self.props.buttonModels * 56
					),
					ClipsDescendants = true,
					[Roact.Ref] = self.ref
				}, children)
			}
		)
	end)
end

function extended.didMount(data)
	local sheetContentXPosition = data.props.sheetContentXPosition
	data.motor:onStep(function(p)
		if data.ref.current then
			data.ref.current.Position = UDim2.new(
				sheetContentXPosition.Scale,
				sheetContentXPosition.Offset,
				1,
				-(data.sheetHeight + data.props.bottomGap) * p
			)
		end
	end)
	data.motor:setGoal(Otter.spring(1, v))
	data.motor:onComplete(function()
		if not data.active then
			data.props.onDismiss()
		end
	end)
	data.motor:start()
end

function extended.willUnmount(p)
	p.motor:destroy()
end

return extended
