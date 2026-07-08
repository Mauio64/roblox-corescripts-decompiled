local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local v6 = Roact.PureComponent:extend("TileBanner")

v6.validateProps = t.strictInterface({
	bannerText = t.string
})

function v6.render(p1) -- line: 21
	-- upvalues: withStyle (copy), Roact (copy)
	local bannerText = p1.props.bannerText

	return withStyle(function(p2) -- line: 24
		-- upvalues: Roact (copy), bannerText (copy)
		local p2Font = p2.Font
		local Theme = p2.Theme
		local v12 = 6 + p2Font.CaptionBody.RelativeSize * p2Font.BaseSize

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.SystemPrimaryDefault.Color,
			BackgroundTransparency = Theme.SystemPrimaryDefault.Transparency,
			Size = UDim2.new(1, 0, 0, v12)
		}, {
			TextLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Font = p2Font.CaptionBody.Font,
				TextSize = p2Font.CaptionBody.RelativeSize * p2Font.BaseSize,
				Text = bannerText,
				TextColor3 = Theme.SystemPrimaryContent.Color,
				TextTransparency = Theme.SystemPrimaryContent.Transparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return v6
