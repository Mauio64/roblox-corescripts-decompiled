local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Core.Style.withStyle
local VerticalScrollViewWithMargin = UIBlox.App.Container.VerticalScrollViewWithMargin
local v8 = Roact.PureComponent:extend("LicenseText")

v8.defaultProps = {
	contentMaxWidth = 1e999,
	paddingHorizontal = 0
}
v8.validateProps = t.strictInterface({
	licenseTextLines = t.array(t.string),
	contentMaxWidth = t.optional(t.number),
	paddingHorizontal = t.optional(t.number)
})

function v8.getTextLines(p1, p2) -- line: 34
	-- upvalues: Roact (copy), Cryo (copy)
	local licenseTextLines = p1.props.licenseTextLines
	local t1 = {
		TextLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})
	}

	for i, v in ipairs(licenseTextLines) do
		t1[i] = Roact.createElement("TextLabel", Cryo.Dictionary.join(p2, {
			LayoutOrder = i,
			Text = v
		}))
	end

	return t1
end
function v8.render(p3) -- line: 56
	-- upvalues: withStyle (copy), Roact (copy), VerticalScrollViewWithMargin (copy)
	return withStyle(function(p4) -- line: 57
		-- upvalues: p3 (copy), Roact (copy), VerticalScrollViewWithMargin (copy)
		local TextDefault = p4.Theme.TextDefault
		local p4Font = p4.Font
		local BodyFont = p4Font.Body.Font
		local v20 = p4Font.BaseSize * p4Font.Body.RelativeSize
		local contentMaxWidth = p3.props.contentMaxWidth
		local paddingHorizontal = p3.props.paddingHorizontal
		local v23 = contentMaxWidth + 2 * paddingHorizontal
		local v24 = p3:getTextLines({
			BackgroundTransparency = 1,
			LineHeight = 1.25,
			TextWrapped = true,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Font = BodyFont,
			TextSize = v20,
			TextColor3 = TextDefault.Color,
			TextTransparency = TextDefault.Transparency
		})

		return Roact.createElement(VerticalScrollViewWithMargin, {
			useAutomaticCanvasSize = true,
			paddingHorizontal = 0,
			canvasSizeY = UDim.new(0, 0)
		}, {
			LicenseFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			}, {
				License = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0)
				}, v24),
				LicenseMaxWidth = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(v23, 1e999)
				}),
				LicensePadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, paddingHorizontal),
					PaddingRight = UDim.new(0, paddingHorizontal),
					PaddingBottom = UDim.new(0, 24)
				})
			})
		})
	end)
end

return v8
