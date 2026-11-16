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

local extended = Roact.PureComponent:extend("DevConsoleCommandLine")

function extended:init()
	function self.onFocusLost(object, p, _)
		if p then
			LogService:ExecuteScript(object.Text)
			object:CaptureFocus()
		end
	end

	self.textbox = Roact.createRef()
end

function extended:didMount()
	if not self.onFocusConnection then
		self.onFocusConnection = UserInputService.InputBegan:Connect(function(input)
			if self.textbox.current and self.textbox.current:IsFocused() then
				local current = self.textbox.current
				local serverLogData = self.props.ServerLogData
				local commandLineHistory = serverLogData:getCommandLineHistory()
				local commandLineIndex = serverLogData:getCommandLineIndex()
				local v

				if input.KeyCode == Enum.KeyCode.Up then
					local v2 = commandLineIndex + 1
					v = math.min(commandLineHistory:getSize(), v2)

					current.Text = commandLineHistory:reverseAt(v) or ""
				elseif input.KeyCode == Enum.KeyCode.Down then
					v = math.max(0, commandLineIndex - 1)

					current.Text = commandLineHistory:reverseAt(v) or ""
				elseif input.KeyCode == Enum.KeyCode.Return then
					if #current.Text:gsub("%s+", "") > 0 and commandLineHistory:reverseAt(1) ~= current.Text then
						commandLineHistory:push_back(current.Text)
					end

					v = 0
				else
					v = commandLineIndex ~= 0 and 0 or commandLineIndex
				end

				serverLogData:setCommandLineIndex(v)
			end
		end)
	end

	if not self.fixUnwantedReturnCapture then
		self.fixUnwantedReturnCapture = UserInputService.InputEnded:Connect(function(input)
			if self.textbox.current and self.textbox.current:IsFocused() and input.KeyCode == Enum.KeyCode.Return then
				self.textbox.current.Text = ""
			end
		end)
	end
end

function extended:willUnmount()
	if self.onFocusConnection then
		self.onFocusConnection:Disconnect()
		self.onFocusConnection = nil
	end

	if self.fixUnwantedReturnCapture then
		self.fixUnwantedReturnCapture:Disconnect()
		self.fixUnwantedReturnCapture = nil
	end
end

function extended.render(props)
	local height = props.props.height
	local pos = props.props.pos

	local commandLineIndex = props.props.ServerLogData:getCommandLineIndex()
	local text = commandLineIndex == 0 and ""
		or props.props.ServerLogData:getCommandLineHistory():reverseAt(commandLineIndex)
		or ""

	return Roact.createElement("Frame", {
		Position = pos,
		Size = UDim2.new(1, 0, 0, height),
		BackgroundTransparency = 0,
		BackgroundColor3 = Constants.Color.TextBoxGray,
		BorderColor3 = Constants.Color.BorderGray,
		BorderSizePixel = 1
	}, {
		Arrow = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, CommandLineIndent, 1, 0),
			BackgroundTransparency = 1,
			TextSize = CommandLine,
			Font = Log,
			Text = "> ",
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
			Text = text,
			Font = Log,
			PlaceholderText = "command line",
			[Roact.Ref] = props.textbox,
			TextBoxFocusLost = props.onFocusLost
		})
	})
end

return DataConsumer(extended, "ServerLogData")
