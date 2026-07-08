local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Colors = require(Parent.Style).Colors
local ReactionMap = require(script.Parent.ReactionMap)
local ReactionList = require(script.Parent.ReactionList)
local DetailList = require(script.Parent.DetailList)
local White = Colors.White
local Flint = Colors.Flint
local ArialBold = Enum.Font.ArialBold

local function Navigator(p1) -- line: 25
	-- upvalues: ReactionList (copy), React (copy), Cryo (copy), Roact (copy), Flint (copy), ReactionMap (copy), ArialBold (copy), White (copy)
	local t1 = {}
	local n1 = 0
	local n2 = 1

	for _, v19 in p1.reactionData do
		n1 += #v19
	end

	for v20 in ReactionList do
		if p1.reactionData[ReactionList[v20]] ~= nil then
			t1[n2] = ReactionList[v20]
			n2 += 1
		end
	end

	local v21 = React.useMemo(function() -- line: 38
		-- upvalues: Cryo (copy), t1 (copy), Roact (copy), Flint (copy), React (copy), p1 (copy), ReactionMap (copy), ArialBold (copy), White (copy)
		return Cryo.List.map(t1, function(s1: string, n3: number) -- line: 39
			-- upvalues: Roact (copy), Flint (copy), React (copy), p1 (copy), ReactionMap (copy), ArialBold (copy), White (copy)
			return Roact.createElement("TextButton", {
				Size = UDim2.new(0, 54, 0, 28),
				BackgroundColor3 = Flint,
				BorderSizePixel = 0,
				Text = "",
				LayoutOrder = n3 + 2,
				[React.Event.Activated] = function() -- line: 46
					-- upvalues: p1 (copy), s1 (copy)
					p1.setEmoji(s1)
				end
			}, {
				corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0.4, 0)
				}),
				emoji = Roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(0.16, 0, 0.5, -9),
					Image = ReactionMap[s1]
				}),
				count = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 15,
					TextWrapped = true,
					Size = UDim2.new(0.5, 0, 1, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					Name = s1 .. "Filter",
					Text = #p1.reactionData[s1],
					Font = ArialBold,
					TextColor3 = White
				})
			})
		end)
	end, { t1 })

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 80),
		LayoutOrder = p1.LayoutOrder
	}, {
		verticalLayout = Roact.createElement("UIListLayout", {
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
			Size = UDim2.fromScale(1, 0.5)
		}),
		scroller = Roact.createElement("ScrollingFrame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScrollBarThickness = 5,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0.5),
			CanvasSize = UDim2.new(0, (#t1 + 1) * 54 + 10, 0, 0)
		}, {
			horizontalLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}, {
			padding = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(0, 5, 0, 5)
			}),
			allFilter = Roact.createElement("TextButton", {
				Size = UDim2.new(0, 54, 0, 28),
				BackgroundColor3 = Flint,
				BorderSizePixel = 0,
				Text = "All  " .. n1,
				Font = ArialBold,
				TextColor3 = White,
				TextSize = 15,
				TextWrapped = true,
				LayoutOrder = 2,
				[React.Event.Activated] = function() -- line: 122
					-- upvalues: p1 (copy)
					p1.setEmoji("All")
				end
			}, {
				corner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0.4, 0)
				})
			})
		}, v21)
	})
end
local function ReactionDetail(p2) -- line: 134
	-- upvalues: React (copy), Roact (copy), Flint (copy), Navigator (copy), Colors (copy), DetailList (copy)
	local v23, v24 = React.useState("All")

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
			navigator = Roact.createElement(Navigator, {
				LayoutOrder = 1,
				setEmoji = v24,
				reactionData = p2.reactionData
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
				emoji = v23,
				reactionData = p2.reactionData
			})
		})
	}
end

return ReactionDetail
