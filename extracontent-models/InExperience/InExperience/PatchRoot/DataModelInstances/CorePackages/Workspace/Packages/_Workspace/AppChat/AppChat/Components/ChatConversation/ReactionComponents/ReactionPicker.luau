local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local ReactionMap = require(script.Parent.ReactionMap)
local ReactionList = require(script.Parent.ReactionList)
local color3 = Color3.fromRGB(57, 59, 61)
local color3_2 = Color3.fromRGB(100, 102, 104)

local function ReactionPicker(p1) -- line: 15
	-- upvalues: React (copy), ReactionList (copy), Cryo (copy), Roact (copy), ReactionMap (copy), color3 (copy), color3_2 (copy)
	if p1.numReactionsToShow == nil then
		p1.numReactionsToShow = 6
	end

	if p1.numReactionsToShow > 6 or p1.numReactionsToShow < 0 then
		error("Invalid number of reactions")
	end

	local v11 = React.useMemo(function() -- line: 23
		-- upvalues: ReactionList (copy), p1 (copy), Cryo (copy), Roact (copy), ReactionMap (copy), React (copy), color3 (copy)
		local t1 = {}
		local v16

		for v13 in ReactionList do
			if v13 > p1.numReactionsToShow then
				return Cryo.List.map(t1, function(s1: string, p2) -- line: 31
					-- upvalues: p1 (copy), Roact (copy), ReactionMap (copy), React (copy), color3 (copy)
					v16 = s1 ~= p1.selectedReactionType and 1 or 0

					return Roact.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 40, 0, 40)
					}, {
						imageButton = Roact.createElement("ImageButton", {
							Image = ReactionMap[s1],
							Name = s1 .. "_Button",
							Size = UDim2.new(0, 40, 0, 40),
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							ScaleType = Enum.ScaleType.Fit,
							[React.Event.Activated] = function() -- line: 45
								-- upvalues: p1 (copy), s1 (copy)
								p1.onReactionSelected(s1)
							end
						}),
						indicator = Roact.createElement("Frame", {
							Size = UDim2.new(0, 6, 0, 6),
							Position = UDim2.new(0.5, -3, 1, 2),
							BackgroundColor3 = color3,
							BackgroundTransparency = v16,
							Name = s1 .. "_Indicator"
						}, {
							corner = Roact.createElement("UICorner", {
								CornerRadius = UDim.new(1, 0)
							})
						})
					})
				end)
			end

			t1[v13] = ReactionList[v13]
		end

		return Cryo.List.map(t1, function(s1: string, p2) -- line: 31
			-- upvalues: p1 (copy), Roact (copy), ReactionMap (copy), React (copy), color3 (copy)
			v16 = s1 ~= p1.selectedReactionType and 1 or 0

			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 40, 0, 40)
			}, {
				imageButton = Roact.createElement("ImageButton", {
					Image = ReactionMap[s1],
					Name = s1 .. "_Button",
					Size = UDim2.new(0, 40, 0, 40),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
					[React.Event.Activated] = function() -- line: 45
						-- upvalues: p1 (copy), s1 (copy)
						p1.onReactionSelected(s1)
					end
				}),
				indicator = Roact.createElement("Frame", {
					Size = UDim2.new(0, 6, 0, 6),
					Position = UDim2.new(0.5, -3, 1, 2),
					BackgroundColor3 = color3,
					BackgroundTransparency = v16,
					Name = s1 .. "_Indicator"
				}, {
					corner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					})
				})
			})
		end)
	end, {
		ReactionMap,
		p1.selectedReactionType
	})

	return {
		ReactionPicker = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = color3_2
		}, {
			corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 19.5),
				PaddingLeft = UDim.new(0, 19.5)
			}),
			layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 11)
			})
		}, v11)
	}
end

return ReactionPicker
