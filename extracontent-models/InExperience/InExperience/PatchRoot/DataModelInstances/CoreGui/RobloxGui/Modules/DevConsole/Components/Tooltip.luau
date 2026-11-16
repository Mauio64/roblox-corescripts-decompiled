local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local MainWindowHeader = Constants.Font.MainWindowHeader
local mainWindowHeader = Constants.DefaultFontSize.MainWindowHeader
local Text = Constants.Color.Text
local UnselectedGray = Constants.Color.UnselectedGray
local Padding = Constants.Tooltip.Padding
local Offset = Constants.Tooltip.Offset
local MaxWidth = Constants.Tooltip.MaxWidth
local Delay = Constants.Tooltip.Delay

local function Tooltip(p)
	local state, setState = React.useState(false)
	local text = p.text
	local pos = p.pos

	React.useEffect(function()
		setState(false)
		local flag = false
		task.delay(Delay, function()
			if flag then
				return
			end

			setState(true)
		end)
		return function()
			flag = true
		end
	end, { text, pos })

	return Roact.createElement(Roact.Portal, { target = CoreGui }, {
		TooltipContainer = Roact.createElement(
			"ScreenGui",
			{ DisplayOrder = 20, IgnoreGuiInset = true, OnTopOfCoreBlur = true, Enabled = state },
			{
				Tooltip = Roact.createElement("TextLabel", {
					Text = text,
					TextSize = mainWindowHeader,
					TextColor3 = Text,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					Font = MainWindowHeader,
					AutomaticSize = Enum.AutomaticSize.XY,
					Position = pos + Offset,
					BackgroundColor3 = UnselectedGray,
					BackgroundTransparency = 0,
					BorderSizePixel = 0
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = Padding,
						PaddingBottom = Padding,
						PaddingLeft = Padding,
						PaddingRight = Padding
					}),
					SizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(MaxWidth, 1e999)
					})
				})
			}
		)
	})
end

return Tooltip
