local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local appFonts = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").AppFonts

local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").Colors
local white = colors.White
local gray2 = colors.Gray2

local extended = Roact.PureComponent:extend("CountryCodeSelectorButton")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Text

function extended:init()
	function self.selectionCallback()
		if self.props.ListButtonProps.SelectionCallback then
			self.props.ListButtonProps.SelectionCallback(self.props.Data)
		end
	end
end

function extended.render(p2)
	local localizedName = p2.props.Data.localizedName or ""
	local v5 = "+" .. (p2.props.Data.prefix or "")
	local textSize = p2.props.ListButtonProps.TextSize

	local textWidth = text.GetTextWidth(v5, appFonts.default:getDefault(), textSize)

	return Roact.createElement("TextButton", {
		Size = p2.props.Size,
		BackgroundTransparency = 1,
		LayoutOrder = p2.props.LayoutOrder,
		Text = "",
		[Roact.Event.Activated] = p2.selectionCallback
	}, {
		CountryName = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, -textWidth, 1, 0),
			Text = localizedName,
			BackgroundTransparency = 1,
			Font = appFonts.default:getDefault(),
			TextColor3 = white,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		CountryPrefix = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Text = v5,
			BackgroundTransparency = 1,
			Font = appFonts.default:getDefault(),
			TextColor3 = gray2,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Right
		})
	})
end

return extended
