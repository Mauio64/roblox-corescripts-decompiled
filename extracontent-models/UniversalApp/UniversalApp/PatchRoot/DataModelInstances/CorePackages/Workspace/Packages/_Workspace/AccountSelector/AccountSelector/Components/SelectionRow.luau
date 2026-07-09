local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Cell = UIBlox.App.Table.Cell
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = dependencies.Style.useDesignTokens

local function SelectionRow(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), useDesignTokens (copy), React (copy), StyledTextLabel (copy), ImageSetLabel (copy), Images (copy), Cell (copy)
	local v13 = useStyle()
	local v14 = useDesignTokens()

	local function handleAccountSelection() -- line: 29
		-- upvalues: t1 (copy)
		if t1.userInteractionEnabled then
			t1.onAccountSelection()
		end
	end
	local function renderText() -- line: 35
		-- upvalues: React (copy), v13 (copy), t1 (copy), StyledTextLabel (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v13.Theme.BackgroundContrast.Color
		}, {
			VerticalLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			TitleText = if not t1.titleContent or t1.titleContent == "" then nil else React.createElement(StyledTextLabel, {
				layoutOrder = 0,
				text = t1.titleContent,
				fontStyle = v13.Font.Header2,
				colorStyle = v13.Theme.TextEmphasis
			}),
			SubtitleText = if not t1.subtitleContent or t1.subtitleContent == "" then nil else React.createElement(StyledTextLabel, {
				layoutOrder = 1,
				text = t1.subtitleContent,
				fontStyle = v13.Font.Body,
				colorStyle = v13.Theme.TextEmphasis
			})
		})
	end
	local function renderIconComponent() -- line: 66
		-- upvalues: t1 (copy), React (copy), ImageSetLabel (copy), Images (copy), v13 (copy)
		if t1.iconKey and t1.iconKey ~= nil then
			return (React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(28, 28),
				Image = Images[t1.iconKey],
				ImageColor3 = t1.iconColor or v13.Theme.Success.Color
			}))
		end

		return React.createElement("Frame", {
			BorderSizePixel = 0
		})
	end
	local function renderCellHead() -- line: 80
		-- upvalues: React (copy), v13 (copy), v14 (copy), t1 (copy), renderText (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BorderColor3 = v13.Theme.BackgroundContrast.Color
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v14.Size.Size_300)
			}),
			AvatarThumbnail = t1.renderImage(),
			Names = renderText()
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v14.Size.Size_1600),
		BackgroundColor3 = v13.Theme.BackgroundContrast.Color,
		BorderColor3 = v13.Theme.BackgroundContrast.Color
	}, {
		Cell = React.createElement(Cell, {
			BorderColor3 = v13.Theme.BackgroundContrast.Color,
			onActivated = handleAccountSelection,
			head = renderCellHead(),
			tail = renderIconComponent(),
			userInteractionEnabled = t1.userInteractionEnabled,
			size = UDim2.new(1, 0, 0, v14.Size.Size_1600),
			background = React.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v13.Theme.BackgroundContrast.Color
			})
		})
	})
end

return SelectionRow
