local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/Types")

local function useDetailsPageRenderItems(items, p2, p3, p4)
	local v5 = React.useMemo(function()
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
		local clone = table.clone(v5)

		table.insert(clone, 1, {
			index = 1,
			key = "Header",
			showCornerGradient = true,
			renderComponent = function()
				return React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, p3.Y - p4.Y * 2),
					BackgroundTransparency = 1
				}, {
					Layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Bottom
					}),
					HeaderContainer = p2
				})
			end
		})

		return clone
	end, { v5, p2, p3.Y, p4.Y }))
end

return useDetailsPageRenderItems
