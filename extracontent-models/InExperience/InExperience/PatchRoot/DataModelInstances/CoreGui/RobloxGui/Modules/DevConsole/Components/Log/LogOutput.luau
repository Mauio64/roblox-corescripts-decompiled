local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)

local defineFastFlag = game:DefineFastFlag("DevConsoleFixMultilineContext", false)

local Components = script.Parent.Parent.Parent.Components
local BannerButton = require(Components.BannerButton)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainWindow = Constants.DefaultFontSize.MainWindow
local Log = Constants.Font.Log
local IconHeight = Constants.LogFormatting.IconHeight
local TextFrameHeight = Constants.LogFormatting.TextFrameHeight
local TextFramePadding = Constants.LogFormatting.TextFramePadding
local MaxStringSize = Constants.LogFormatting.MaxStringSize

local function countTextLinesInKeyValuePair(p: string, p2: string) -- 2 equivalent calls inferred from this helper
	local _, v = string.gsub(`{p}: {p2}`, "\n", "")
	return v + 1
end

local function countContextLines(context, p: number)
	local total = 0

	for k, item in context do
		if k == "_expanded" then
			continue
		end

		local v

		if type(item) == "table" then
			v = p + 1 < 3
		else
			v = false
		end

		if defineFastFlag and not v then
			total += countTextLinesInKeyValuePair(tostring(k), tostring(item)) -- inferred equivalent call
		else
			total += 1
		end

		if v and item._expanded then
			total += countContextLines(item, p + 1)
		end
	end

	return total
end

local extended = Roact.Component:extend("LogOutput")

function extended:init(p)
	local logData = p.initLogOutput and p.initLogOutput()

	function self.onCanvasChange()
		local current = self.ref.current

		if current then
			local canvasPosition = current.CanvasPosition
			local absoluteSize = current.AbsoluteSize

			if self.state.canvasPos ~= canvasPosition or self.state.absSize ~= absoluteSize then
				self:setState({
					canvasPos = canvasPosition,
					absSize = absoluteSize,
					autoScroll = current.CanvasPosition.Y + current.AbsoluteSize.Y == current.CanvasSize.Y.Offset
				})
			end
		end
	end

	self.ref = Roact.createRef()

	self.state = {
		logData = logData,
		absSize = Vector2.new(),
		canvasPos = Vector2.new(),
		autoScroll = true,
		wordWrap = true
	}
end

function extended:willUpdate(_, _)
	self._canvasSignal:Disconnect()
	self._absSizeSignal:Disconnect()
end

function extended:didUpdate()
	self._canvasSignal = self.ref.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasChange)
	self._absSizeSignal = self.ref.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(self.onCanvasChange)

	local current = self.state.autoScroll and self.ref.current

	if current then
		current.CanvasPosition = Vector2.new(
			current.CanvasPosition.X,
			self.ref.current.CanvasSize.Y.Offset + self.ref.current.AbsoluteSize.Y
		)
	end
end

function extended:didMount()
	self.logConnector = self.props.targetSignal:Connect(function(object)
		if self.state.autoScroll or object:getSize() ~= object:getMaxSize() then
			self:setState({ logData = object })

			return
		end

		local canvasPos = self.state.canvasPos
		local v = canvasPos.Y
		local back = object:back()

		if back then
			local v2 = back.Dims.Y
			local v3 = self.state.absSize.X - TextFrameHeight

			if self.state.wordWrap and v3 > 0 then
				v2 = math.ceil(back.Dims.Y * math.ceil(back.Dims.X / v3))
			end

			v = math.max(0, v - v2 - TextFramePadding)
		end

		self:setState({ logData = object, canvasPos = Vector2.new(canvasPos.X, v) })
	end)

	self._canvasSignal = self.ref.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasChange)
	self._absSizeSignal = self.ref.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(self.onCanvasChange)

	if self.ref.current.AbsoluteSize.Magnitude > 0 then
		self:setState({ absSize = self.ref.current.AbsoluteSize })
	end
end

function extended:willUnmount()
	self.logConnector:Disconnect()
	self.logConnector = nil
end

function extended.render(props)
	local layoutOrder = props.props.layoutOrder
	local size = props.props.size

	local logData = props.state.logData
	local absSize = props.state.absSize
	local canvasPos = props.state.canvasPos
	local wordWrap = props.state.wordWrap

	local children = {}

	local layoutOrder2 = 1
	local v = 0

	if props.ref.current and logData then
		local v2 = absSize.X - TextFrameHeight

		local function createOnButtonPress(p) -- 1 equivalent call inferred from this helper
			return function()
				p.Expanded = not p.Expanded
				props:setState({})
			end
		end

		local function addContextEntries(children2, context, textColor: Color3, p: number, p2)
			if p >= 3 then
				return
			end

			local v3 = {}

			for k in context do
				if k ~= "_expanded" then
					table.insert(v3, k)
				end
			end

			table.sort(v3, function(a, b): boolean
				return tostring(a) < tostring(b)
			end)

			local v4 = p * 20 + 20

			for _, v5 in v3 do
				local item = context[v5]
				p2.i += 1
				local i = p2.i
				local formatted = `Ctx_{p}_{tostring(v5)}`

				if type(item) == "table" and p + 1 < 3 then
					children2[formatted] = Roact.createElement(BannerButton, {
						size = UDim2.new(1, 0, 0, MainWindow),
						isExpanded = item._expanded,
						isExpandable = true,
						layoutOrder = i,
						hideLines = true,
						onButtonPress = function()
							item._expanded = not item._expanded
							props:setState({})
						end
					}, {
						Label = Roact.createElement("TextLabel", {
							Text = `{tostring(v5)}: \{...}`,
							TextSize = MainWindow,
							Font = Log,
							TextColor3 = textColor,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -(v4 + 20), 1, 0),
							Position = UDim2.fromOffset(v4 + 20, 0),
							TextXAlignment = Enum.TextXAlignment.Left
						})
					})

					if item._expanded then
						addContextEntries(children2, item, textColor, p + 1, p2)
					end
				elseif defineFastFlag then
					local v6 = countTextLinesInKeyValuePair(tostring(v5), tostring(item)) -- inferred equivalent call
					children2[formatted] = Roact.createElement("TextLabel", {
						Text = `{tostring(v5)}: {tostring(item)}`,
						TextSize = MainWindow,
						Font = Log,
						TextColor3 = textColor,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v6 * MainWindow + (v6 - 1) * TextFramePadding),
						LayoutOrder = i,
						TextXAlignment = Enum.TextXAlignment.Left
					}, {
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, v4 + 20)
						})
					})
				else
					children2[formatted] = Roact.createElement("TextLabel", {
						Text = `{tostring(v5)}: {tostring(item)}`,
						TextSize = MainWindow,
						Font = Log,
						TextColor3 = textColor,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, MainWindow),
						LayoutOrder = i,
						TextXAlignment = Enum.TextXAlignment.Left
					}, {
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, v4 + 20)
						})
					})
				end
			end
		end

		local iterator = logData:iterator()
		local v3 = iterator:next()
		local v4 = 0
		local v5 = -1

		while v3 do
			local message = v3.Message
			local charCount = v3.CharCount

			local v6 = v3.Dims.Y

			if wordWrap and v2 > 0 then
				v6 = math.ceil(v3.Dims.Y * math.ceil(v3.Dims.X / v2))
			end

			local v7

			if v3.Context then
				v7 = MainWindow + TextFramePadding

				if v3.Expanded then
					v7 += countContextLines(v3.Context, 0) * (MainWindow + TextFramePadding)
				end
			else
				v7 = 0
			end

			local v8 = v6 + v7

			layoutOrder2 += 1

			if v + v8 >= canvasPos.Y then
				if v4 < absSize.Y then
					local textColor = Constants.Color.Text
					local image = ""

					if v3.Type == Enum.MessageType.MessageOutput.Value then
						textColor = Constants.Color.Text
					elseif v3.Type == Enum.MessageType.MessageInfo.Value then
						textColor = Constants.Color.HighlightBlue
						image = Constants.Image.Info
					elseif v3.Type == Enum.MessageType.MessageWarning.Value then
						textColor = Constants.Color.WarningYellow
						image = Constants.Image.Warning
					elseif v3.Type == Enum.MessageType.MessageError.Value then
						textColor = Constants.Color.ErrorRed
						image = Constants.Image.Error
					end

					local children2 = {}

					if v3.Context then
						children2.Layout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, TextFramePadding)
						})

						children2.Header = Roact.createElement(BannerButton, {
							size = UDim2.new(1, 0, 0, MainWindow),
							isExpanded = v3.Expanded,
							isExpandable = true,
							layoutOrder = 0,
							hideLines = true,
							onButtonPress = createOnButtonPress(v3) -- inferred equivalent call
						}, {
							Label = Roact.createElement("TextLabel", {
								Text = "Context: {...}",
								TextSize = MainWindow,
								Font = Log,
								TextColor3 = textColor,
								BackgroundTransparency = 1,
								Size = UDim2.new(1, -20, 1, 0),
								Position = UDim2.fromOffset(20, 0),
								TextXAlignment = Enum.TextXAlignment.Left
							})
						})

						if v3.Expanded then
							addContextEntries(children2, v3.Context, textColor, 0, { i = 0 })
						end
					end

					children[layoutOrder2] = Roact.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, v8),
							BackgroundTransparency = 1,
							LayoutOrder = layoutOrder2
						},
						{
							image = Roact.createElement("ImageLabel", {
								Image = image,
								Size = UDim2.new(0, IconHeight, 0, IconHeight),
								Position = UDim2.new(0, IconHeight / 4, 0, (MainWindow - IconHeight) / 2),
								BackgroundTransparency = 1
							}),
							msg = Roact.createElement("TextLabel", {
								Text = message,
								TextColor3 = textColor,
								TextSize = MainWindow,
								Font = Log,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = wordWrap,
								Size = UDim2.new(1, 0, 0, v6),
								Position = UDim2.new(0, TextFrameHeight, 0, 0),
								BackgroundTransparency = 1
							}),
							context = v3.Context and Roact.createElement("Frame", {
								Size = UDim2.new(1, -TextFrameHeight, 0, v7),
								Position = UDim2.new(0, TextFrameHeight, 0, v6 + TextFramePadding),
								BackgroundTransparency = 1
							}, children2)
						}
					)
				end

				if v5 < 0 then
					v5 = v
				else
					v4 = v4 + v8 + TextFramePadding
				end
			end

			v = v + v8 + TextFramePadding

			if charCount < MaxStringSize then
				v3 = iterator:next()
			else
				local message2 = string.format(
					" -- Could not display entire %d character message because message exceeds max displayable length of %d",
					charCount,
					MaxStringSize
				)
				v3 = {
					Message = message2,
					CharCount = #message2,
					Type = v3.Type,
					Dims = TextService:GetTextSize(message2, MainWindow, Log, Vector2.new())
				}
			end
		end

		children.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, TextFramePadding)
		})

		children.WindowingPadding = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v5),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		})
	end

	return Roact.createElement("ScrollingFrame", {
		Size = size,
		BackgroundTransparency = 1,
		VerticalScrollBarInset = 1,
		ScrollBarThickness = 6,
		CanvasSize = UDim2.new(0, 0, 0, v),
		CanvasPosition = canvasPos,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = props.ref
	}, children)
end

return extended
