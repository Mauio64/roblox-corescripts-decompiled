local Parent = script:FindFirstAncestor("DetailsPageComponents").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require(Parent.Style).useDesignTokens

return React.memo(function(t1: {[any]: any}) -- line: 24
	-- upvalues: useStyle (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), RetrievalStatus (copy), React (copy), StyledTextLabel (copy)
	local v10 = useStyle()
	local v11 = useDesignTokens()
	local v12 = ((if not FFlagRenameDeprecatedUIBloxTokens then v11.Semantic.Typography.Body else v11.Typography.BodyLarge)) or {}
	local v13 = ((if not FFlagRenameDeprecatedUIBloxTokens then v11.Semantic.Typography.Header else v11.Typography.HeadingSmall)) or {}
	local v14 = t1.dataStatus == RetrievalStatus.Done
	local v15 = t1.descriptionText and #t1.descriptionText > 0

	if not v14 or not v15 then
		return nil
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, t1.listPadding or 16)
		}),
		Title = React.createElement(StyledTextLabel, {
			richText = false,
			fluidSizing = false,
			text = t1.titleText,
			size = UDim2.fromScale(1, 0),
			fontStyle = v13,
			colorStyle = v10.Theme.TextEmphasis,
			automaticSize = Enum.AutomaticSize.Y
		}),
		Description = React.createElement(StyledTextLabel, {
			richText = false,
			fluidSizing = false,
			text = t1.descriptionText,
			size = UDim2.new(1, 0, 0, 0),
			textYAlignment = Enum.TextYAlignment.Top,
			fontStyle = v12,
			colorStyle = v10.Theme.TextDefault,
			automaticSize = Enum.AutomaticSize.Y,
			lineHeight = v12.LineHeight
		})
	})
end)
