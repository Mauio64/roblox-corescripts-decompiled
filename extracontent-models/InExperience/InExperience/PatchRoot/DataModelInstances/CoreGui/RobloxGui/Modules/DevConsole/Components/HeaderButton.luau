local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local MainWindowHeader = Constants.Font.MainWindowHeader
local mainWindowHeader = Constants.DefaultFontSize.MainWindowHeader
local Text = Constants.Color.Text

local function HeaderButton(props)
	local text = props.text
	local size = props.size
	local pos = props.pos
	local sortfunction = props.sortfunction

	return Roact.createElement("TextButton", {
		Text = text,
		TextSize = mainWindowHeader,
		TextColor3 = Text,
		Font = MainWindowHeader,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = size,
		Position = pos,
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = function()
			if sortfunction then
				sortfunction(text)
			end
		end
	})
end

return HeaderButton
