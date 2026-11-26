local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)

local withStyle = UIBlox.Style.withStyle

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local extended = Roact.PureComponent:extend("EmptyPage")

local quad = roactFitComponents.Rect.quad(9, 0, 24, 0)
extended.validateProps = t.strictInterface({
	page = t.table,
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table)
})

function extended.render(p2)
	local page = p2.props.page
	local emptyString = page.EmptyString or page.Title

	return withStyle(function(data)
		return withLocalization({
			itemType = emptyString,
			noItemsLabel = "Feature.Avatar.Label.NoItems"
		})(function(p3)
			local v5 = p3.noItemsLabel:gsub("({itemType})", p3.itemType)
			local theme = data.Theme
			local font = data.Font
			local v6 = font.BaseSize * font.Header2.RelativeSize
			local v7 = RoactGamepad.Focusable[fitFrameVertical]
			return Roact.createElement(v7, {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 22),
				margin = quad,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				BorderSizePixel = 0,
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				NextSelectionUp = p2.props.NextSelectionUp,
				NextSelectionDown = p2.props.NextSelectionDown
			}, {
				NoItemsText = Roact.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, v6),
					BackgroundTransparency = 1,
					Text = v5,
					TextSize = v6,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.TextTransparency,
					TextXAlignment = Enum.TextXAlignment.Center,
					LayoutOrder = 1,
					FontFace = normalizeFontFace(data.Tokens.Typography.TitleLarge.Font)
				})
			})
		end)
	end)
end

return extended
