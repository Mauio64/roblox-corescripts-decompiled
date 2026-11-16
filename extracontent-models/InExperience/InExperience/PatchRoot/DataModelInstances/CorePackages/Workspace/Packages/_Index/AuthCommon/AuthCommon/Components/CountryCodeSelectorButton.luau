local parent = script:FindFirstAncestor("AuthCommon").Parent

local Roact = require(parent.Roact)
local Style = require(parent.Style)
local AppFonts = Style.AppFonts

local Style2 = require(parent.Style)
local Colors = Style2.Colors
local White = Colors.White
local Gray2 = Colors.Gray2

local extended = Roact.PureComponent:extend("CountryCodeSelectorButton")
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text

function extended:init()
	function self.selectionCallback()
		if self.props.ListButtonProps.SelectionCallback then
			self.props.ListButtonProps.SelectionCallback(self.props.Data)
		end
	end
end

function extended.render(p)
	local localizedName = p.props.Data.localizedName or ""
	local text = "+" .. (p.props.Data.prefix or "")
	local textSize = p.props.ListButtonProps.TextSize

	local textWidth = Text.GetTextWidth(text, AppFonts.default:getDefault(), textSize)

	return Roact.createElement("TextButton", {
		Size = p.props.Size,
		BackgroundTransparency = 1,
		LayoutOrder = p.props.LayoutOrder,
		Text = "",
		[Roact.Event.Activated] = p.selectionCallback
	}, {
		CountryName = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, -textWidth, 1, 0),
			Text = localizedName,
			BackgroundTransparency = 1,
			Font = AppFonts.default:getDefault(),
			TextColor3 = White,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		CountryPrefix = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Text = text,
			BackgroundTransparency = 1,
			Font = AppFonts.default:getDefault(),
			TextColor3 = Gray2,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Right
		})
	})
end

return extended
