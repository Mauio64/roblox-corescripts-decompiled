local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local MainWindowHeader = Constants.Font.MainWindowHeader
local mainWindowHeader = Constants.DefaultFontSize.MainWindowHeader
local Text = Constants.Color.Text
local UnselectedGray = Constants.Color.UnselectedGray
local InactiveBox = Constants.Color.InactiveBox

local function BoxButton(props)
	local text = props.text
	local size = props.size
	local pos = props.pos
	local _onClicked = props.onClicked
	local v = typeof(props.enabled) ~= "boolean" or props.enabled

	local v2 = React.useCallback(function()
		props.onClicked(props.text)
	end, { props.onClicked, props.text })

	local createElement = Roact.createElement
	local v3 = {}
	v3.Text = text
	v3.TextSize = mainWindowHeader
	v3.TextColor3 = Text
	v3.Font = MainWindowHeader
	v3.Size = size
	v3.Position = pos
	v3.AutoButtonColor = v
	local backgroundColor = if v then UnselectedGray else InactiveBox
	v3.BackgroundColor3 = backgroundColor
	v3.Active = v
	v3.BackgroundTransparency = 0

	v3[Roact.Event.Activated] = v2
	return createElement("TextButton", v3)
end

return BoxButton
