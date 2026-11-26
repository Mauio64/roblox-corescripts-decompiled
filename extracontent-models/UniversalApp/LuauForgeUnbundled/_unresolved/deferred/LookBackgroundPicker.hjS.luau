local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local focusable = RoactGamepad.Focusable

local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dPv")

local defaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local gridMetrics = UIBlox.App.Grid.GridMetrics
local useStyle = UIBlox.Core.Style.useStyle

local v5 = {
	Color3.fromHex("#584D43"),
	Color3.fromHex("#775D49"),
	Color3.fromHex("#AB9585"),
	Color3.fromHex("#C3916F"),
	Color3.fromHex("#E2BA97"),
	Color3.fromHex("#534338"),
	Color3.fromHex("#63422C"),
	Color3.fromHex("#B79C66"),
	Color3.fromHex("#C2AD7F"),
	Color3.fromHex("#D4C69F"),
	Color3.fromHex("#917A78"),
	Color3.fromHex("#98504E"),
	Color3.fromHex("#CE8A7D"),
	Color3.fromHex("#F7CBCA"),
	Color3.fromHex("#F19DD9"),
	Color3.fromHex("#77859B"),
	Color3.fromHex("#5B7BAA"),
	Color3.fromHex("#8DB9D9"),
	Color3.fromHex("#AFA7F9"),
	Color3.fromHex("#9D6298"),
	Color3.fromHex("#3E8D9A"),
	Color3.fromHex("#6A9855"),
	Color3.fromHex("#829B70"),
	Color3.fromHex("#A8C391"),
	Color3.fromHex("#D89E52"),
	Color3.fromHex("#EFCE53"),
	Color3.fromHex("#F3DA7D"),
	Color3.fromHex("#625F62"),
	Color3.fromHex("#CDCDCD"),
	Color3.fromHex("#F8F8F8")
}

local function LookBackgroundPicker()
	local v6 = useDispatch()
	local v7 = useStyle()
	local v8 = useDesignTokens()

	local v9 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarScene.Looks[module.DraftLookId]
	end)

	local v10 = React.useCallback(function(p2)
		return React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p2,
			Text = "",
			[React.Event.Activated] = function()
				local hex = p2:ToHex()
				local v12 = not v9 and {} or v9.displayProperties
				local joined = Cryo.Dictionary.join(v12, {
					backgroundType = "Hex",
					backgroundValue = hex
				})

				v6(module2(module.DraftLookId, { displayProperties = joined }))
			end
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		})
	end, { v9, v6 })

	return React.createElement(
		focusable.Frame,
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
		{
			Header = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, v8.Size.Size_1200),
				BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
				BorderSizePixel = 0,
				Text = "Select a background",
				FontFace = normalizeFontFace(v8.Typography.TitleLarge.Font),
				TextSize = v7.Font.BaseSize * v7.Font.Header2.RelativeSize,
				TextColor3 = v7.Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true,
				ZIndex = 2
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v8.Size.Size_300)
				})
			}),
			ScrollingFrame = React.createElement(focusable.ScrollingFrame, {
				BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				Position = UDim2.fromOffset(0, v8.Size.Size_1200),
				Size = UDim2.fromScale(1, 1),
				AutomaticCanvasSize = Enum.AutomaticSize.Y
			}, {
				Container = React.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, v8.Size.Size_300),
							PaddingBottom = UDim.new(0, v8.Size.Size_300),
							PaddingLeft = UDim.new(0, v8.Size.Size_300),
							PaddingRight = UDim.new(0, v8.Size.Size_300)
						}),
						BackgroundColorsGrid = React.createElement(defaultMetricsGridView, {
							renderItem = v10,
							getItemHeight = function(p2)
								return p2
							end,
							getItemMetrics = gridMetrics.makeCustomMetricsGetter({
								minimumItemsPerRow = 5,
								minimumItemWidth = 60
							}),
							itemPadding = Vector2.new(v8.Size.Size_250, v8.Size.Size_250),
							items = v5,
							maxHeight = 1e999,
							defaultChildIndex = 1
						})
					}
				)
			})
		}
	)
end

return LookBackgroundPicker
