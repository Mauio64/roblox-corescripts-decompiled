local module = require("@luauforge/bundled/hUT")
local module2 = require("@luauforge/bundled/hUP")

local windowProtocolService = require("@luauforge/bundled/hUR").WindowProtocolService

local useStyle = require("@luauforge/bundled/hUW").Core.Style.useStyle

local module3 = require("@luauforge/bundled/hUZ")
local module4 = require("@luauforge/bundled/hVa")
local module5 = require("@luauforge/bundled/hVb")

local module6 = require("@luauforge/bundled/hUX")
local module7 = require("@luauforge/bundled/hVe")

local view = module.View

local defineFastFlag = game:DefineFastFlag("DoNotCacheCaptionButtonBounds", false)

local v5 = { Color3 = Color3.fromRGB(232, 17, 35), Transparency = 0 }

local function CaptionButtonsArea(p2)
	local v6 = useStyle()
	local window = p2.window

	local v7 = module2.useMemo(function()
		return windowProtocolService:GetLogicalCaptionButtonsBounds(window)
	end, { window })

	if defineFastFlag then
		v7 = windowProtocolService:GetLogicalCaptionButtonsBounds(window)
	end

	local v8 = module2.useMemo(function()
		return windowProtocolService:ShouldRenderTitleBarControlsNatively()
	end, {})

	local v9 = module2.useMemo(function()
		return windowProtocolService:GetNativeTitleBarControlsPosition()
	end, {}) == Enum.TitleBarControlsPosition.Left and 0 or 1

	local state, setState = module2.useState(function()
		return windowProtocolService:GetWindowState(window)
	end)

	module2.useEffect(function()
		local onWindowStateChangedConnection = windowProtocolService.OnWindowStateChanged:Connect(function(p3, p4)
			if p3 ~= window then
				return
			end

			setState(p4)
		end)

		return function()
			onWindowStateChangedConnection:Disconnect()
		end
	end, { window })

	if v8 then
		return module2.createElement(view, {
			AnchorPoint = Vector2.new(v9, 0.5),
			Position = UDim2.new(v9, 0, 0.5, 0),
			Size = UDim2.new(0, v7.Width, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = module6.CAPTION_BUTTONS_Z_INDEX,
			testId = "custom-title-bar-caption-buttons-native-placeholder"
		})
	end

	local createElement = module2.createElement
	local v11 = {
		AnchorPoint = Vector2.new(v9, 0.5),
		Position = UDim2.new(v9, 0, 0.5, 0),
		Size = UDim2.new(0, v7.Width, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = module6.CAPTION_BUTTONS_Z_INDEX,
		onActivated = function() end,
		stateLayer = { affordance = module.Enums.StateLayerAffordance.None },
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 1)
		}
	}

	local children = {
		MinimizeButton = module2.createElement(module7, {
			LayoutOrder = 0,
			icon = module.Enums.IconName.Minus,
			iconSize = module.Enums.IconSize.Small,
			hoveredBackgroundStyle = v6.Theme.BackgroundOnHover,
			testId = "custom-title-bar-minimize-button",
			onActivated = function()
				if module4 then
					module3.default:logRobloxTelemetryCounter(module5.CaptionButtonPressed, 1, {
						action = "Minimize"
					})
				end

				windowProtocolService:Minimize(window)
			end
		}),
		MaximizeButton = 0,
		CloseButton = 0
	}

	local createElement2 = module2.createElement

	local v14 = if state == Enum.WindowState.Maximized then module.Enums.IconName.SquareCornerLineSmall else module.Enums.IconName.SquareSmall
	children.MaximizeButton = createElement2(module7, {
		LayoutOrder = 1,
		icon = v14,
		iconSize = module.Enums.IconSize.Small,
		hoveredBackgroundStyle = v6.Theme.BackgroundOnHover,
		testId = "custom-title-bar-maximize-button",
		onActivated = function()
			if state == Enum.WindowState.Maximized then
				if module4 then
					module3.default:logRobloxTelemetryCounter(module5.CaptionButtonPressed, 1, {
						action = "Restore"
					})
				end

				windowProtocolService:Restore(window)
			else
				if module4 then
					module3.default:logRobloxTelemetryCounter(module5.CaptionButtonPressed, 1, {
						action = "Maximize"
					})
				end

				windowProtocolService:Maximize(window)
			end
		end
	})

	children.CloseButton = module2.createElement(module7, {
		LayoutOrder = 2,
		icon = module.Enums.IconName.X,
		iconSize = module.Enums.IconSize.Small,
		hoveredBackgroundStyle = v5,
		testId = "custom-title-bar-close-button",
		onActivated = function()
			if module4 then
				module3.default:logRobloxTelemetryCounter(module5.CaptionButtonPressed, 1, {
					action = "Close"
				})
			end

			windowProtocolService:Close(window)
		end
	})
	return createElement(view, v11, children)
end

return CaptionButtonsArea
