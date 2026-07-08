local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local BannerButton = require(Components.BannerButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainWindow = Constants.DefaultFontSize.MainWindow
local Log = Constants.Font.Log
local IconHeight = Constants.LogFormatting.IconHeight
local TextFrameHeight = Constants.LogFormatting.TextFrameHeight
local TextFramePadding = Constants.LogFormatting.TextFramePadding
local MaxStringSize = Constants.LogFormatting.MaxStringSize

local function countContextLines(t1: {[any]: any}, n1: number) -- line: 23
	-- upvalues: countContextLines (copy)
	local n2 = 0

	for v18, v19 in t1 do
		if v18 ~= "_expanded" then
			n2 += 1

			if type(v19) == "table" and n1 + 1 < 3 and v19._expanded then
				n2 += countContextLines(v19, n1 + 1)
			end
		end
	end

	return n2
end

local v14 = Roact.Component:extend("LogOutput")

function v14.init(p1, p2) -- line: 38
	-- upvalues: Roact (copy)
	local v22 = p2.initLogOutput and p2.initLogOutput()

	function p1.onCanvasChange() -- line: 41
		-- upvalues: p1 (copy)
		local current = p1.ref.current

		if current then
			local CanvasPosition = current.CanvasPosition
			local AbsoluteSize = current.AbsoluteSize

			if CanvasPosition ~= p1.state.canvasPos or AbsoluteSize ~= p1.state.absSize then
				local v61 = current.CanvasPosition.Y + current.AbsoluteSize.Y == current.CanvasSize.Y.Offset

				p1:setState({
					canvasPos = CanvasPosition,
					absSize = AbsoluteSize,
					autoScroll = v61
				})
			end
		end
	end

	p1.ref = Roact.createRef()
	p1.state = {
		autoScroll = true,
		wordWrap = true,
		logData = v22,
		absSize = Vector2.new(),
		canvasPos = Vector2.new()
	}
end
function v14.willUpdate(p3, _, _) -- line: 71
	p3._canvasSignal:Disconnect()
	p3._absSizeSignal:Disconnect()
end
function v14.didUpdate(p6) -- line: 76
	p6._canvasSignal = p6.ref.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p6.onCanvasChange)
	p6._absSizeSignal = p6.ref.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(p6.onCanvasChange)

	if p6.state.autoScroll then
		local current = p6.ref.current

		if current then
			current.CanvasPosition = Vector2.new(current.CanvasPosition.X, p6.ref.current.CanvasSize.Y.Offset + p6.ref.current.AbsoluteSize.Y)
		end
	end
end
function v14.didMount(p7) -- line: 92
	-- upvalues: TextFrameHeight (copy), TextFramePadding (copy)
	p7.logConnector = p7.props.targetSignal:Connect(function(p8) -- line: 93
		-- upvalues: p7 (copy), TextFrameHeight (copy), TextFramePadding (copy)
		if not p7.state.autoScroll and p8:getSize() == p8:getMaxSize() then
			local canvasPos = p7.state.canvasPos
			local canvasPosY = canvasPos.Y
			local v65 = p8:back()

			if v65 then
				local DimsY = v65.Dims.Y
				local v67 = p7.state.absSize.X - TextFrameHeight

				if p7.state.wordWrap and v67 > 0 then
					DimsY = math.ceil(v65.Dims.Y * math.ceil(v65.Dims.X / v67))
				end

				canvasPosY = math.max(0, canvasPosY - DimsY - TextFramePadding)
			end

			p7:setState({
				logData = p8,
				canvasPos = Vector2.new(canvasPos.X, canvasPosY)
			})

			return
		end

		p7:setState({
			logData = p8
		})
	end)
	p7._canvasSignal = p7.ref.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p7.onCanvasChange)
	p7._absSizeSignal = p7.ref.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(p7.onCanvasChange)

	if p7.ref.current.AbsoluteSize.Magnitude > 0 then
		p7:setState({
			absSize = p7.ref.current.AbsoluteSize
		})
	end
end
function v14.willUnmount(p9) -- line: 137
	p9.logConnector:Disconnect()
	p9.logConnector = nil
end
function v14.render(p10) -- line: 142
	-- upvalues: TextFrameHeight (copy), Roact (copy), BannerButton (copy), MainWindow (copy), Log (copy), TextFramePadding (copy), countContextLines (copy), Constants (copy), IconHeight (copy), MaxStringSize (copy), TextService (copy)
	local layoutOrder = p10.props.layoutOrder
	local size = p10.props.size
	local logData = p10.state.logData
	local absSize = p10.state.absSize
	local canvasPos = p10.state.canvasPos
	local wordWrap = p10.state.wordWrap
	local t2 = {}
	local n3 = 1
	local n4 = 0

	if p10.ref.current and logData then
		local v40 = absSize.X - TextFrameHeight
		local n5 = -1
		local n6 = 0

		local function createOnButtonPress(t3: {[any]: any}) -- line: 161
			-- upvalues: p10 (copy)
			return function() -- line: 162
				-- upvalues: t3 (copy), p10 (copy)
				t3.Expanded = not t3.Expanded
				p10:setState({})
			end
		end
		local function addContextEntries(t4: {[any]: any}, t5: {[any]: any}, color3: Color3, n7: number, t6: {[any]: any}) -- line: 168
			-- upvalues: Roact (copy), BannerButton (copy), MainWindow (copy), p10 (copy), Log (copy), addContextEntries (copy)
			if n7 >= 3 then
				return
			end

			local t7 = {}

			for v75 in t5 do
				if v75 ~= "_expanded" then
					table.insert(t7, v75)
				end
			end

			table.sort(t7, function(p11, p12) -- line: 176
				return tostring(p11) < tostring(p12)
			end)

			local v76 = n7 * 20 + 20

			for _, v78 in t7 do
				local v79 = t5[v78]

				t6.i = t6.i + 1

				local i = t6.i
				local v81 = `Ctx_{ n7 }_{ tostring(v78) }`

				if type(v79) == "table" and n7 + 1 < 3 then
					t4[v81] = Roact.createElement(BannerButton, {
						isExpandable = true,
						hideLines = true,
						size = UDim2.new(1, 0, 0, MainWindow),
						isExpanded = v79._expanded,
						layoutOrder = i,
						onButtonPress = function() -- line: 194
							-- upvalues: v79 (copy), p10 (copy)
							v79._expanded = not v79._expanded
							p10:setState({})
						end
					}, {
						Label = Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Text = `{ tostring(v78) }: \{...}`,
							TextSize = MainWindow,
							Font = Log,
							TextColor3 = color3,
							Size = UDim2.new(1, -(v76 + 20), 1, 0),
							Position = UDim2.fromOffset(v76 + 20, 0),
							TextXAlignment = Enum.TextXAlignment.Left
						})
					})

					if v79._expanded then
						addContextEntries(t4, v79, color3, n7 + 1, t6)
					end
				else
					t4[v81] = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = `{ tostring(v78) }: { tostring(v79) }`,
						TextSize = MainWindow,
						Font = Log,
						TextColor3 = color3,
						Size = UDim2.new(1, 0, 0, MainWindow),
						LayoutOrder = i,
						TextXAlignment = Enum.TextXAlignment.Left
					}, {
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, v76 + 20)
						})
					})
				end
			end
		end

		local v45 = logData:iterator()
		local v46 = v45:next()

		while v46 do
			local v47 = v46
			local Message = v47.Message
			local CharCount = v47.CharCount
			local DimsY = v47.Dims.Y

			if wordWrap and v40 > 0 then
				DimsY = math.ceil(v47.Dims.Y * math.ceil(v47.Dims.X / v40))
			end

			local n8 = 0

			if v47.Context then
				n8 = MainWindow + TextFramePadding

				if v47.Expanded then
					n8 += countContextLines(v47.Context, 0) * (MainWindow + TextFramePadding)
				end
			end

			local v52 = DimsY + n8

			n3 += 1

			if n4 + v52 >= canvasPos.Y then
				if n6 < absSize.Y then
					local ColorText = Constants.Color.Text
					local s1 = ""

					if v47.Type == Enum.MessageType.MessageOutput.Value then
						ColorText = Constants.Color.Text
					elseif v47.Type == Enum.MessageType.MessageInfo.Value then
						ColorText = Constants.Color.HighlightBlue
						s1 = Constants.Image.Info
					elseif v47.Type == Enum.MessageType.MessageWarning.Value then
						ColorText = Constants.Color.WarningYellow
						s1 = Constants.Image.Warning
					elseif v47.Type == Enum.MessageType.MessageError.Value then
						ColorText = Constants.Color.ErrorRed
						s1 = Constants.Image.Error
					end

					local t8 = {}

					if v47.Context then
						t8.Layout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, TextFramePadding)
						})
						t8.Header = Roact.createElement(BannerButton, {
							isExpandable = true,
							layoutOrder = 0,
							hideLines = true,
							size = UDim2.new(1, 0, 0, MainWindow),
							isExpanded = v47.Expanded,
							onButtonPress = function() -- line: 162
								-- upvalues: v47 (copy), p10 (copy)
								v47.Expanded = not v47.Expanded
								p10:setState({})
							end
						}, {
							Label = Roact.createElement("TextLabel", {
								Text = "Context: {...}",
								BackgroundTransparency = 1,
								TextSize = MainWindow,
								Font = Log,
								TextColor3 = ColorText,
								Size = UDim2.new(1, -20, 1, 0),
								Position = UDim2.fromOffset(20, 0),
								TextXAlignment = Enum.TextXAlignment.Left
							})
						})

						if v47.Expanded then
							local t9 = {
								i = 0
							}

							addContextEntries(t8, v47.Context, ColorText, 0, t9)
						end
					end

					t2[n3] = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v52),
						LayoutOrder = n3
					}, {
						image = Roact.createElement("ImageLabel", {
							BackgroundTransparency = 1,
							Image = s1,
							Size = UDim2.new(0, IconHeight, 0, IconHeight),
							Position = UDim2.new(0, IconHeight / 4, 0, (MainWindow - IconHeight) / 2)
						}),
						msg = Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Text = Message,
							TextColor3 = ColorText,
							TextSize = MainWindow,
							Font = Log,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextWrapped = wordWrap,
							Size = UDim2.new(1, 0, 0, DimsY),
							Position = UDim2.new(0, TextFrameHeight, 0, 0)
						}),
						context = v47.Context and Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -TextFrameHeight, 0, n8),
							Position = UDim2.new(0, TextFrameHeight, 0, DimsY + TextFramePadding)
						}, t8)
					})
				end

				if n5 < 0 then
					n5 = n4
				else
					n6 = n6 + v52 + TextFramePadding
				end
			end

			n4 = n4 + v52 + TextFramePadding

			if CharCount < MaxStringSize then
				v46 = v45:next()
			else
				local v57 = string.format(" -- Could not display entire %d character message because message exceeds max displayable length of %d", CharCount, MaxStringSize)

				v46 = {
					Message = v57,
					CharCount = #v57,
					Type = v47.Type,
					Dims = TextService:GetTextSize(v57, MainWindow, Log, Vector2.new())
				}
			end
		end

		t2.UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, TextFramePadding)
		})
		t2.WindowingPadding = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, n5)
		})
	end

	return Roact.createElement("ScrollingFrame", {
		Size = size,
		BackgroundTransparency = 1,
		VerticalScrollBarInset = 1,
		ScrollBarThickness = 6,
		CanvasSize = UDim2.new(0, 0, 0, n4),
		CanvasPosition = canvasPos,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = p10.ref
	}, t2)
end

return v14
