local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local Colors = require(Parent.Style).Colors
local DetailList = require(script.Parent.DetailList)
local White = Colors.White
local Flint = Colors.Flint
local ArialBold = Enum.Font.ArialBold

local function ReactionDetail(p1) -- line: 20
	-- upvalues: React (copy), Roact (copy), Flint (copy), White (copy), ArialBold (copy), Colors (copy), DetailList (copy)
	local v11 = React.useState("All")

	return {
		ReactionDetail = Roact.createElement("Frame", {
			Size = UDim2.new(0, 300, 0, 375),
			BackgroundColor3 = Flint
		}, {
			corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.05, 0)
			}),
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}, {
			header = Roact.createElement("TextLabel", {
				Text = "Reactions",
				TextSize = 20,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				TextColor3 = White,
				Font = ArialBold,
				Size = UDim2.new(1, 0, 0, 40)
			}),
			bar = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.fromScale(1, 0)
			}, { Roact.createElement("Frame", {
				Size = UDim2.new(0.97, 0, 0, 0),
				BackgroundColor3 = Colors.White,
				BorderColor3 = Colors.White,
				Position = UDim2.new(0.015, 0, 0, 0)
			}) }),
			padding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 10)
			}),
			detailList = Roact.createElement(DetailList, {
				LayoutOrder = 4,
				emoji = v11,
				reactionData = p1.reactionData
			})
		})
	}
end

return ReactionDetail
