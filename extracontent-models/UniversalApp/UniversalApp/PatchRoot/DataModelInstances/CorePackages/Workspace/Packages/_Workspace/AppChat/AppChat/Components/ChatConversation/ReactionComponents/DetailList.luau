local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Colors = require(Parent.Style).Colors
local ReactionMap = require(script.Parent.ReactionMap)
local ReactionList = require(script.Parent.ReactionList)
local White = Colors.White
local ArialBold = Enum.Font.ArialBold

return function(p1) -- line: 23
	-- upvalues: ReactionList (copy), React (copy), Cryo (copy), Roact (copy), White (copy), ArialBold (copy), ReactionMap (copy)
	local t1 = {}

	if p1.emoji == "All" then
		local n1 = 1

		for v13 in ReactionList do
			if p1.reactionData[ReactionList[v13]] ~= nil then
				for v14 in p1.reactionData[ReactionList[v13]] do
					t1[n1] = {
						p1.reactionData[ReactionList[v13]][v14],
						ReactionList[v13]
					}
					n1 += 1
				end
			end
		end
	else
		local n2 = 1

		for v16 in p1.reactionData[p1.emoji] do
			t1[n2] = {
				p1.reactionData[p1.emoji][v16],
				p1.emoji
			}
			n2 += 1
		end
	end

	local v17 = React.useMemo(function() -- line: 44
		-- upvalues: Cryo (copy), t1 (copy), Roact (copy), White (copy), ArialBold (copy), ReactionMap (copy)
		return Cryo.List.map(t1, function(t2: {[any]: any}, _) -- line: 45
			-- upvalues: Roact (copy), White (copy), ArialBold (copy), ReactionMap (copy)
			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 36)
			}, {
				padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 25),
					PaddingRight = UDim.new(0, 25)
				}),
				profilePic = Roact.createElement("ImageLabel", {
					BorderSizePixel = 0,
					Image = "rbxthumb://type=AvatarHeadShot&id=505306092&w=150&h=150&filters=circular",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 36, 0, 36),
					ScaleType = Enum.ScaleType.Fit
				}),
				userInfo = Roact.createElement("TextLabel", {
					BorderSizePixel = 0,
					TextSize = 15,
					BackgroundTransparency = 1,
					Size = UDim2.new(0.5, 0, 0, 36),
					TextColor3 = White,
					Text = t2[1],
					Font = ArialBold,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(0, 56, 0, 0)
				}),
				emoji = Roact.createElement("ImageLabel", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 25, 0, 25),
					Image = ReactionMap[t2[2]],
					ScaleType = Enum.ScaleType.Fit,
					Position = UDim2.new(1, -25, 0.5, -12.5)
				})
			})
		end)
	end, {
		p1.reactionData,
		p1.emoji
	})

	return Roact.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		Size = UDim2.new(1, 0, 0, 285),
		CanvasSize = UDim2.new(0, 0, 0, #v17 * 53 - 17 + 5),
		LayoutOrder = p1.LayoutOrder
	}, {
		layout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 17)
		})
	}, v17)
end
