local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactFitComponents = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v10 = Roact.PureComponent:extend("EmptyPage")
local v11 = RoactFitComponents.Rect.quad(9, 0, 24, 0)

v10.validateProps = t.strictInterface({
	page = t.table,
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table)
})

function v10.render(p1) -- line: 32
	-- upvalues: withStyle (copy), withLocalization (copy), RoactGamepad (copy), FitFrameVertical (copy), Roact (copy), v11 (copy)
	local page = p1.props.page
	local v14 = page.EmptyString or page.Title

	return withStyle(function(p2) -- line: 36
		-- upvalues: withLocalization (copy), v14 (copy), RoactGamepad (copy), FitFrameVertical (copy), Roact (copy), v11 (copy), p1 (copy)
		return withLocalization({
			noItemsLabel = "Feature.Avatar.Label.NoItems",
			itemType = v14
		})(function(p3) -- line: 40
			-- upvalues: p2 (copy), RoactGamepad (copy), FitFrameVertical (copy), Roact (copy), v11 (copy), p1 (copy)
			local v17 = p3.noItemsLabel:gsub("({itemType})", p3.itemType)
			local Theme = p2.Theme
			local p2Font = p2.Font
			local Header2Font = p2Font.Header2.Font
			local v21 = p2Font.BaseSize * p2Font.Header2.RelativeSize
			local v22 = RoactGamepad.Focusable[FitFrameVertical]

			return Roact.createElement(v22, {
				BorderSizePixel = 0,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 22),
				margin = v11,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency,
				NextSelectionUp = p1.props.NextSelectionUp,
				NextSelectionDown = p1.props.NextSelectionDown
			}, {
				NoItemsText = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v21),
					Text = v17,
					TextSize = v21,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.TextTransparency,
					TextXAlignment = Enum.TextXAlignment.Center,
					Font = Header2Font
				})
			})
		end)
	end)
end

return v10
