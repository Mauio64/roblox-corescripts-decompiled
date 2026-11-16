local module = require("@luauforge/bundled/fPo")
local react = module.React
local uiBlox = module.UIBlox

local cell = uiBlox.App.Table.Cell
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local useStyle = uiBlox.Core.Style.useStyle
local useDesignTokens = module.Style.useDesignTokens

local function SelectionRow(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()

	local function handleAccountSelection()
		if props.userInteractionEnabled then
			props.onAccountSelection()
		end
	end

	local function renderText()
		local createElement = react.createElement
		local v8 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v5.Theme.BackgroundContrast.Color,
			BackgroundTransparency = 1
		}

		local v9 = {
			VerticalLayout = react.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			TitleText = 0,
			SubtitleText = 0
		}

		local v10 = if props.titleContent and props.titleContent ~= "" then react.createElement(styledTextLabel, {
			text = props.titleContent,
			fontStyle = v5.Font.Header2,
			colorStyle = v5.Theme.TextEmphasis,
			layoutOrder = 0
		}) else nil
		v9.TitleText = v10

		local v11 = if props.subtitleContent and props.subtitleContent ~= "" then react.createElement(styledTextLabel, {
			text = props.subtitleContent,
			fontStyle = v5.Font.Body,
			colorStyle = v5.Theme.TextEmphasis,
			layoutOrder = 1
		}) else nil
		v9.SubtitleText = v11
		return createElement("Frame", v8, v9)
	end

	local function renderIconComponent()
		if props.iconKey and props.iconKey ~= nil then
			return (react.createElement(imageSetLabel, {
				Size = UDim2.fromOffset(28, 28),
				Image = images[props.iconKey],
				ImageColor3 = props.iconColor or v5.Theme.Success.Color,
				BackgroundTransparency = 1
			}))
		end

		return react.createElement("Frame", { BorderSizePixel = 0 })
	end

	local function renderCellHead()
		return react.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = v5.Theme.BackgroundContrast.Color
			},
			{
				UIPadding = react.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24)
				}),
				Layout = react.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, v6.Size.Size_300)
				}),
				AvatarThumbnail = props.renderImage(),
				Names = renderText()
			}
		)
	end

	return react.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, v6.Size.Size_1600),
			BackgroundTransparency = 1,
			BackgroundColor3 = v5.Theme.BackgroundContrast.Color,
			BorderColor3 = v5.Theme.BackgroundContrast.Color
		},
		{
			Cell = react.createElement(cell, {
				BorderColor3 = v5.Theme.BackgroundContrast.Color,
				onActivated = handleAccountSelection,
				head = renderCellHead(),
				tail = renderIconComponent(),
				userInteractionEnabled = props.userInteractionEnabled,
				size = UDim2.new(1, 0, 0, v6.Size.Size_1600),
				background = react.createElement("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = v5.Theme.BackgroundContrast.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0
				})
			})
		}
	)
end

return SelectionRow
