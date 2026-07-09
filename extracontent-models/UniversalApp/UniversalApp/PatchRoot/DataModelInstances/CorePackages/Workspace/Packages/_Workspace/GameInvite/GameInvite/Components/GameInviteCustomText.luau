local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteParent = GameInvite.Parent
local React = require(GameInviteParent.React)
local UIBlox = require(GameInviteParent.UIBlox)
local GameInviteConstants = require(GameInvite.GameInviteConstants)
local useStyle = UIBlox.Core.Style.useStyle
local SidePadding = GameInviteConstants.Layout.SidePadding

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: useStyle (copy), React (copy), SidePadding (copy)
	local v9 = useStyle()
	local Theme = v9.Theme
	local Font = v9.Font
	local v12 = Font.BaseSize * Font.Body.RelativeSize

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = t1.size,
		LayoutOrder = t1.layoutOrder
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, SidePadding),
			PaddingRight = UDim.new(0, SidePadding)
		}),
		CustomText = React.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			Text = t1.promptMessage,
			TextSize = v12,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency,
			Font = Font.Body.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Size = UDim2.new(1, 0, 1, 0)
		})
	})
end
