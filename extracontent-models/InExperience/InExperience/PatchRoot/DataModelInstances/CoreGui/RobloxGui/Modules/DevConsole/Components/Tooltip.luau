local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindowHeader2 = Constants.DefaultFontSize.MainWindowHeader
local ColorText = Constants.Color.Text
local UnselectedGray = Constants.Color.UnselectedGray
local TooltipPadding = Constants.Tooltip.Padding
local TooltipOffset = Constants.Tooltip.Offset
local MaxWidth = Constants.Tooltip.MaxWidth
local Delay = Constants.Tooltip.Delay

local function Tooltip(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), Delay (copy), Roact (copy), CoreGui (copy), MainWindowHeader2 (copy), ColorText (copy), MainWindowHeader (copy), TooltipOffset (copy), UnselectedGray (copy), TooltipPadding (copy), MaxWidth (copy)
	local v16, v17 = React.useState(false)
	local text = t1.text
	local pos = t1.pos

	React.useEffect(function() -- line: 26
		-- upvalues: v17 (copy), Delay (copy)
		v17(false)

		local u20 = false

		task.delay(Delay, function() -- line: 29
			-- upvalues: u20 (ref), v17 (copy)
			if u20 then
				return
			end

			v17(true)
		end)

		return function() -- line: 35
			-- upvalues: u20 (ref)
			u20 = true
		end
	end, {
		text,
		pos
	})

	return Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		TooltipContainer = Roact.createElement("ScreenGui", {
			DisplayOrder = 20,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			Enabled = v16
		}, {
			Tooltip = Roact.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Text = text,
				TextSize = MainWindowHeader2,
				TextColor3 = ColorText,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = MainWindowHeader,
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = pos + TooltipOffset,
				BackgroundColor3 = UnselectedGray
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = TooltipPadding,
					PaddingBottom = TooltipPadding,
					PaddingLeft = TooltipPadding,
					PaddingRight = TooltipPadding
				}),
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(MaxWidth, 1e999)
				})
			})
		})
	})
end

return Tooltip
