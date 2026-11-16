local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
require(script.Parent.Parent.Types)

local function useDetailsPageRenderItems(items, headerContainer, vector2: Vector2, vector2_2: Vector2)
	local v = React.useMemo(function()
		local result = {}

		for k, item in items do
			table.insert(result, {
				index = item.portraitLayoutOrder + 1,
				renderComponent = item.renderComponent,
				showCornerGradient = item.showCornerGradient,
				useSelectionBumper = item.useSelectionBumper,
				key = k
			})
		end

		table.sort(result, function(a, b): boolean
			if not b.index then
				return true
			end

			if a.index then
				return a.index <= b.index
			end

			return false
		end)

		return result
	end, { items })

	return (React.useMemo(function()
		local clone = table.clone(v)

		table.insert(clone, 1, {
			index = 1,
			key = "Header",
			showCornerGradient = true,
			renderComponent = function()
				return React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, vector2.Y - vector2_2.Y * 2),
					BackgroundTransparency = 1
				}, {
					Layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Bottom
					}),
					HeaderContainer = headerContainer
				})
			end
		})

		return clone
	end, { v, headerContainer, vector2.Y, vector2_2.Y }))
end

return useDetailsPageRenderItems
