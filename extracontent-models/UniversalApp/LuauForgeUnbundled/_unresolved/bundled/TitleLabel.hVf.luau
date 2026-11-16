local module = require("@luauforge/bundled/hUT")
local module2 = require("@luauforge/bundled/hUP")

local text = module.Text

local windowProtocolService = require("@luauforge/bundled/hUR").WindowProtocolService

local module3 = require("@luauforge/bundled/hUX")

local function TitleLabel(p2)
	local window = p2.window

	local v5 = module2.useMemo(function()
		return windowProtocolService:GetLogicalCaptionButtonsBounds(window)
	end, { window })

	if module2.useMemo(function()
		return windowProtocolService:GetNativeTitleBarControlsPosition()
	end, {}) == Enum.TitleBarControlsPosition.Left then
		return module2.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = module3.TITLE_LABEL_Z_INDEX,
			[module2.Tag] = "data-testid=custom-title-bar-title-label"
		}, {
			Layout = module2.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Title = module2.createElement(text, {
				Text = p2.title,
				tag = "auto-xy text-title-medium content-emphasis"
			})
		})
	end

	return module2.createElement("Frame", {
		Size = UDim2.new(1, -v5.Width, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = module3.TITLE_LABEL_Z_INDEX,
		[module2.Tag] = "data-testid=custom-title-bar-title-label"
	}, {
		Layout = module2.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6)
		}),
		Padding = module2.createElement("UIPadding", { PaddingLeft = UDim.new(0, 8) }),
		Icon = module2.createElement("ImageLabel", {
			Image = "rbxasset://textures/ui/LuaApp/icons/pc_window_icon_128.png",
			Size = UDim2.fromOffset(16, 16),
			ScaleType = Enum.ScaleType.Fit,
			LayoutOrder = 1,
			[module2.Tag] = "data-testid=custom-title-bar-title-label-icon"
		}, {
			Corner = module2.createElement("UICorner", {
				CornerRadius = UDim.new(0.25, 0)
			})
		}),
		Title = module2.createElement(text, {
			Text = p2.title,
			LayoutOrder = 2,
			tag = "auto-xy text-label-medium content-emphasis"
		})
	})
end

return TitleLabel
