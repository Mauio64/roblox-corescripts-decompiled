local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindowHeader2 = Constants.DefaultFontSize.MainWindowHeader
local ColorText = Constants.Color.Text
local UnselectedGray = Constants.Color.UnselectedGray
local InactiveBox = Constants.Color.InactiveBox

local function BoxButton(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), Roact (copy), MainWindowHeader2 (copy), ColorText (copy), MainWindowHeader (copy), UnselectedGray (copy), InactiveBox (copy)
	local text = t1.text
	local size = t1.size
	local pos = t1.pos
	local _ = t1.onClicked
	local v16 = typeof(t1.enabled) ~= "boolean" or t1.enabled
	local v17 = React.useCallback(function() -- line: 28
		-- upvalues: t1 (copy)
		t1.onClicked(t1.text)
	end, {
		t1.onClicked,
		t1.text
	})

	return Roact.createElement("TextButton", {
		Text = text,
		TextSize = MainWindowHeader2,
		TextColor3 = ColorText,
		Font = MainWindowHeader,
		Size = size,
		Position = pos,
		AutoButtonColor = v16,
		BackgroundColor3 = if not v16 then InactiveBox else UnselectedGray,
		Active = v16,
		BackgroundTransparency = 0,
		[Roact.Event.Activated] = v17
	})
end

return BoxButton
