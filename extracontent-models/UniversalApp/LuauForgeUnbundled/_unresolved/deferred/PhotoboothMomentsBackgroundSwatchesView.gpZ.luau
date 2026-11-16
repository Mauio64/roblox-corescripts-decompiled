local module = require("@luauforge/deferred/gpo")
local module2 = require("@luauforge/deferred/gpq")

local module3 = require("@luauforge/deferred/gpG")

local useTokens = module2.Hooks.useTokens

local backgroundSwatchesStrip = module3.BackgroundSwatchesStrip

local function PhotoboothMomentsBackgroundSwatchesView(p2)
	local v5 = useTokens()

	local size_100 = v5.Size.Size_100

	local darkMode = v5.DarkMode
	local background = darkMode.ActionStandard.Background
	local emphasis = darkMode.Content.Emphasis
	local onSwatchActivated = p2.onSwatchActivated

	local state, setState = module.useState(Vector2.zero)
	local state2, setState2 = module.useState(0)
	local v6 = module.useCallback(function(p3)
		setState(p3.AbsoluteWindowSize)
	end, {})
	local v7 = module.useCallback(function(p3)
		setState2(p3.AbsoluteSize.X)
	end, {})
	local v8 = state2 <= state.X
	local v9 = math.floor(state.Y * backgroundSwatchesStrip.SwatchHeightRatio)
	local udim = UDim2.fromOffset(v9, v9)

	local v10 = module.useMemo(function()
		return {
			["row align-y-center gap-large size-0-full auto-x padding-x-large"] = true,
			["position-top-center anchor-top-center"] = v8
		}
	end, { v8 })

	local children = {}

	for k, swatch in p2.swatches do
		local v11 = if swatch.isSelected then emphasis else background
		children[swatch.id] = module.createElement(module2.View, {
			tag = "radius-circle",
			Size = udim,
			backgroundStyle = { Color3 = swatch.color, Transparency = 0 },
			stroke = {
				Color = v11.Color3,
				Transparency = v11.Transparency,
				Thickness = size_100
			},
			onActivated = function()
				onSwatchActivated(swatch.id)
			end,
			LayoutOrder = k,
			testId = `PhotoboothMomentsBackgroundSwatchesView_Swatch_{swatch.id}`
		})
	end

	return module.createElement(
		module2.View,
		{
			tag = "size-full-full",
			backgroundStyle = v5.Color.Extended.Black.Black_100,
			testId = "PhotoboothMomentsBackgroundSwatchesView"
		},
		{
			Gradient = module.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new(1, backgroundSwatchesStrip.GradientBottomTransparency)
			}),
			List = module.createElement(module2.ScrollView, {
				tag = "size-full-full",
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					ScrollingDirection = Enum.ScrollingDirection.X,
					CanvasSize = UDim2.fromScale(0, 0),
					scrollBarVisibility = module2.Enums.Visibility.None
				},
				onAbsoluteWindowSizeChanged = v6,
				testId = "PhotoboothMomentsBackgroundSwatchesView_List"
			}, {
				Row = module.createElement(
					module2.View,
					{
						tag = v10,
						onAbsoluteSizeChanged = v7,
						testId = "PhotoboothMomentsBackgroundSwatchesView_Row"
					},
					children
				)
			})
		}
	)
end

return PhotoboothMomentsBackgroundSwatchesView
