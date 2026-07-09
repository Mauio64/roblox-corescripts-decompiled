local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local LoadingSkeleton = require(Modules.LuaApp.Components.LoadingSkeleton)
local v6 = Roact.PureComponent:extend("ItemTileName")

v6.defaultProps = {
	textYAlignment = Enum.TextYAlignment.Top
}

local t1 = {
	[1] = {
		Size = UDim2.new(0.8, 0, 0, 16)
	},
	[2] = {
		Size = UDim2.new(0.5, 0, 0, 16)
	}
}

function v6.init(p1) -- line: 22
	-- upvalues: Roact (copy)
	function p1.createLoadingSkeletonLayout() -- line: 23
		-- upvalues: Roact (copy)
		return Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		})
	end
end
function v6.render(p2) -- line: 33
	-- upvalues: Roact (copy), LoadingSkeleton (copy), t1 (copy), withStyle (copy)
	local name = p2.props.name
	local textYAlignment = p2.props.textYAlignment

	return withStyle(function(p3) -- line: 36
		-- upvalues: name (copy), Roact (copy), LoadingSkeleton (copy), p2 (copy), t1 (copy), textYAlignment (copy)
		local Theme = p3.Theme
		local p3Font = p3.Font
		local v15 = p3Font.BaseSize * p3Font.Header2.RelativeSize

		return name == nil and Roact.createElement(LoadingSkeleton, {
			Size = UDim2.new(1, 0, 1, 0),
			createLayout = p2.createLoadingSkeletonLayout,
			panels = t1
		}) or Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 1, 0),
			TextSize = v15,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency,
			Font = p3Font.Header2.Font,
			Text = name,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = textYAlignment
		})
	end)
end

return v6
