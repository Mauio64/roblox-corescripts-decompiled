local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")
local Roact = require(CorePackages.Packages.Roact)
local DataConsumer = require(script.Parent.Parent.DataConsumer)
local ScrollingTextBox = require(script.Parent.Parent.ScrollingTextBox)
local Constants = require(script.Parent.Parent.Parent.Constants)
local CommandLineIndent = Constants.LogFormatting.CommandLineIndent
local CommandLine = Constants.DefaultFontSize.CommandLine
local Log = Constants.Font.Log
local v11 = Roact.PureComponent:extend("DevConsoleCommandLine")

function v11.init(p1) -- line: 17
	-- upvalues: LogService (copy), Roact (copy)
	function p1.onFocusLost(p2, p3, _) -- line: 18
		-- upvalues: LogService (copy)
		if p3 then
			LogService:ExecuteScript(p2.Text)
			p2:CaptureFocus()
		end
	end

	p1.textbox = Roact.createRef()
end
function v11.didMount(p5) -- line: 28
	-- upvalues: UserInputService (copy)
	if not p5.onFocusConnection then
		p5.onFocusConnection = UserInputService.InputBegan:Connect(function(input) -- line: 30
			-- upvalues: p5 (copy)
			if p5.textbox.current and p5.textbox.current:IsFocused() then
				local current = p5.textbox.current
				local ServerLogData = p5.props.ServerLogData
				local v26 = ServerLogData:getCommandLineHistory()
				local v27 = ServerLogData:getCommandLineIndex()

				if input.KeyCode == Enum.KeyCode.Up then
					local v28 = v27 + 1

					v27 = math.min(v26:getSize(), v28)
					current.Text = v26:reverseAt(v27) or ""
				elseif input.KeyCode == Enum.KeyCode.Down then
					v27 = math.max(0, v27 - 1)
					current.Text = v26:reverseAt(v27) or ""
				elseif input.KeyCode == Enum.KeyCode.Return then
					if #current.Text:gsub("%s+", "") > 0 and v26:reverseAt(1) ~= current.Text then
						v26:push_back(current.Text)
					end

					v27 = 0
				elseif v27 ~= 0 then
					v27 = 0
				end

				ServerLogData:setCommandLineIndex(v27)
			end
		end)
	end

	if not p5.fixUnwantedReturnCapture then
		p5.fixUnwantedReturnCapture = UserInputService.InputEnded:Connect(function(input) -- line: 70
			-- upvalues: p5 (copy)
			if p5.textbox.current and (p5.textbox.current:IsFocused() and input.KeyCode == Enum.KeyCode.Return) then
				p5.textbox.current.Text = ""
			end
		end)
	end
end
function v11.willUnmount(p6) -- line: 80
	if p6.onFocusConnection then
		p6.onFocusConnection:Disconnect()
		p6.onFocusConnection = nil
	end

	if p6.fixUnwantedReturnCapture then
		p6.fixUnwantedReturnCapture:Disconnect()
		p6.fixUnwantedReturnCapture = nil
	end
end
function v11.render(p7) -- line: 91
	-- upvalues: Roact (copy), Constants (copy), CommandLineIndent (copy), CommandLine (copy), Log (copy), ScrollingTextBox (copy)
	local height = p7.props.height
	local pos = p7.props.pos
	local s1 = ""
	local v19 = p7.props.ServerLogData:getCommandLineIndex()

	if v19 ~= 0 then
		s1 = p7.props.ServerLogData:getCommandLineHistory():reverseAt(v19) or ""
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		BorderSizePixel = 1,
		Position = pos,
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = Constants.Color.TextBoxGray,
		BorderColor3 = Constants.Color.BorderGray
	}, {
		Arrow = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = "> ",
			Size = UDim2.new(0, CommandLineIndent, 1, 0),
			TextSize = CommandLine,
			Font = Log,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Right
		}),
		InputField = Roact.createElement(ScrollingTextBox, {
			Position = UDim2.new(0, CommandLineIndent, 0, 0),
			Size = UDim2.new(1, -CommandLineIndent, 0, height),
			ShowNativeInput = true,
			ClearTextOnFocus = false,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = 0,
			TextSize = CommandLine,
			Text = s1,
			Font = Log,
			PlaceholderText = "command line",
			[Roact.Ref] = p7.textbox,
			TextBoxFocusLost = p7.onFocusLost
		})
	})
end

return DataConsumer(v11, "ServerLogData")
