local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindowHeader2 = Constants.DefaultFontSize.MainWindowHeader
local ColorText = Constants.Color.Text

local function HeaderButton(t1: {[any]: any}) -- line: 18
	-- upvalues: Roact (copy), MainWindowHeader2 (copy), ColorText (copy), MainWindowHeader (copy)
	local text = t1.text
	local size = t1.size
	local pos = t1.pos
	local sortfunction = t1.sortfunction

	return Roact.createElement("TextButton", {
		Text = text,
		TextSize = MainWindowHeader2,
		TextColor3 = ColorText,
		Font = MainWindowHeader,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = size,
		Position = pos,
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = function() -- line: 35
			-- upvalues: sortfunction (copy), text (copy)
			if sortfunction then
				sortfunction(text)
			end
		end
	})
end

return HeaderButton
