local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)

require(script.Parent.Parent.Types)

local function useDetailsPageRenderItems(p1, p2, vector2: Vector2, vector2_2: Vector2) -- line: 9
	-- upvalues: React (copy)
	local v8 = React.useMemo(function() -- line: 15
		-- upvalues: p1 (copy)
		local t1 = {}

		for v10, v11 in p1 do
			table.insert(t1, {
				index = v11.portraitLayoutOrder + 1,
				renderComponent = v11.renderComponent,
				showCornerGradient = v11.showCornerGradient,
				useSelectionBumper = v11.useSelectionBumper,
				key = v10
			})
		end

		table.sort(t1, function(p3, p4) -- line: 27
			if not p4.index then
				return true
			end

			if not p3.index then
				return false
			end

			return p3.index <= p4.index
		end)

		return t1
	end, { p1 })

	return (React.useMemo(function() -- line: 40
		-- upvalues: v8 (copy), React (copy), vector2 (copy), vector2_2 (copy), p2 (copy)
		local v12 = table.clone(v8)

		table.insert(v12, 1, {
			index = 1,
			key = "Header",
			showCornerGradient = true,
			renderComponent = function() -- line: 47
				-- upvalues: React (copy), vector2 (copy), vector2_2 (copy), p2 (copy)
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, vector2.Y - vector2_2.Y * 2)
				}, {
					Layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Bottom
					}),
					HeaderContainer = p2
				})
			end
		})

		return v12
	end, {
		v8,
		p2,
		vector2.Y,
		vector2_2.Y
	}))
end

return useDetailsPageRenderItems
