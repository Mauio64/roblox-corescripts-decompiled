local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Roact = require(Parent.Roact)
local AppFonts = require(Parent.Style).AppFonts
local Colors = require(Parent.Style).Colors
local White = Colors.White
local Gray2 = Colors.Gray2
local v7 = Roact.PureComponent:extend("CountryCodeSelectorButton")
local Text = require(Parent.AppCommonLib).Text

function v7.init(p1) -- line: 14
	function p1.selectionCallback() -- line: 15
		-- upvalues: p1 (copy)
		if p1.props.ListButtonProps.SelectionCallback then
			p1.props.ListButtonProps.SelectionCallback(p1.props.Data)
		end
	end
end
function v7.render(p2) -- line: 22
	-- upvalues: Text (copy), AppFonts (copy), Roact (copy), White (copy), Gray2 (copy)
	local v11 = p2.props.Data.localizedName or ""
	local v12 = "+" .. (p2.props.Data.prefix or "")
	local ListButtonPropsTextSize = p2.props.ListButtonProps.TextSize
	local v14 = Text.GetTextWidth(v12, AppFonts.default:getDefault(), ListButtonPropsTextSize)

	return Roact.createElement("TextButton", {
		Size = p2.props.Size,
		BackgroundTransparency = 1,
		LayoutOrder = p2.props.LayoutOrder,
		Text = "",
		[Roact.Event.Activated] = p2.selectionCallback
	}, {
		CountryName = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -v14, 1, 0),
			Text = v11,
			Font = AppFonts.default:getDefault(),
			TextColor3 = White,
			TextSize = ListButtonPropsTextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		CountryPrefix = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = v12,
			Font = AppFonts.default:getDefault(),
			TextColor3 = Gray2,
			TextSize = ListButtonPropsTextSize,
			TextXAlignment = Enum.TextXAlignment.Right
		})
	})
end

return v7
