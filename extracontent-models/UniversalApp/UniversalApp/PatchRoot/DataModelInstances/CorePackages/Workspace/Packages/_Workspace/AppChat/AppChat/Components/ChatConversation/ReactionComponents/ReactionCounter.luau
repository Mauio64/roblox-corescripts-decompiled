local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local ReactionMap = require(script.Parent.ReactionMap)
local ReactionList = require(script.Parent.ReactionList)
local ArialBold = Enum.Font.ArialBold
local color3 = Color3.new(1, 1, 1)
local color3_2 = Color3.fromRGB(100, 102, 104)

local function ReactionCounter(p1) -- line: 20
	-- upvalues: React (copy), ReactionList (copy), Cryo (copy), Roact (copy), ReactionMap (copy), color3_2 (copy), color3 (copy), ArialBold (copy)
	local n1 = 0
	local v13 = false
	local n2 = 0

	for _, v16 in p1.reactionData do
		if #v16 >= 2 then
			v13 = true
		end

		n1 += #v16
		n2 += 1
	end

	if n2 > 3 then
		v13 = true
	end

	local v17 = not (n1 >= 10) and 10 or 15
	local v18 = React.useMemo(function() -- line: 36
		-- upvalues: ReactionList (copy), p1 (copy), Cryo (copy), Roact (copy), ReactionMap (copy)
		local n3 = 1
		local t1 = {}

		for v21 in ReactionList do
			if n3 >= 4 then
				return Cryo.List.map(t1, function(p2, p3) -- line: 49
					-- upvalues: Roact (copy), ReactionMap (copy)
					return Roact.createElement("ImageLabel", {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Image = ReactionMap[p2],
						Size = UDim2.new(0, 20, 0, 20),
						ScaleType = Enum.ScaleType.Fit,
						Name = "ShowReaction" .. p3
					})
				end)
			end

			if p1.reactionData[ReactionList[v21]] ~= nil then
				t1[n3] = ReactionList[v21]
				n3 += 1
			end
		end

		return Cryo.List.map(t1, function(p2, p3) -- line: 49
			-- upvalues: Roact (copy), ReactionMap (copy)
			return Roact.createElement("ImageLabel", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Image = ReactionMap[p2],
				Size = UDim2.new(0, 20, 0, 20),
				ScaleType = Enum.ScaleType.Fit,
				Name = "ShowReaction" .. p3
			})
		end)
	end, {})

	return {
		reactionCounter = Roact.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BorderSizePixel = 0,
			Text = "",
			[Roact.Event.Activated] = p1.onPressed,
			BackgroundColor3 = color3_2
		}, {
			corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 7),
				PaddingLeft = UDim.new(0, 7)
			}),
			layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			})
		}, v18, {
			reactionCount = v13 and Roact.createElement("TextLabel", {
				TextSize = 17,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v17, 0, 20),
				Text = n1,
				TextColor3 = color3,
				Font = ArialBold
			})
		})
	}
end

return ReactionCounter
