local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local useTokens = require(Foundation.Providers.Style.useTokens)

local udim = UDim2.fromScale(1, 0)

local function slotFrame(layoutOrder: number, p) -- 2 equivalent calls inferred from this helper
	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Size = udim
	}, p)
end

local function BaseTileContent(props)
	local v = useTokens()
	local v2 = props.contentAction ~= nil
	local small = v.Gap.Small
	local v3

	if props.isContained then
		v3 = v.Padding.Medium
	else
		v3 = v.Padding.Small
	end

	local udim2 = UDim.new(0, v3)
	local v4

	if props.isContained then
		v4 = udim2
	end

	local size_1200 = v.Size.Size_1200

	local title = slotFrame(1, props.title) -- inferred equivalent call
	local metadata

	if props.metadata ~= nil then
		metadata = slotFrame(2, props.metadata) -- inferred equivalent call
	end

	local footer

	if props.footer ~= nil then
		footer = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			Size = udim,
			[React.Tag] = getTestIdTag(`{props.testId}--footer`)
		}, {
			Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, small) }),
			Content = props.footer
		})
	end

	local v5 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = udim2,
			PaddingBottom = v4,
			PaddingLeft = v4,
			PaddingRight = v4
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Footer = footer
	}

	if v2 then
		v5.Header = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = udim
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, small),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			Text = React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, -(size_1200 + small), 0, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Title = title,
				Metadata = metadata
			}),
			ContentAction = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.fromOffset(size_1200, v.Size.Size_800),
				[React.Tag] = getTestIdTag(`{props.testId}--content-action`)
			}, { Content = props.contentAction })
		})
	else
		v5.Title = title
		v5.Metadata = metadata
	end

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = udim,
		[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged,
		[React.Tag] = getTestIdTag(`{props.testId}--content`)
	}, v5)
end

return React.memo(BaseTileContent)
