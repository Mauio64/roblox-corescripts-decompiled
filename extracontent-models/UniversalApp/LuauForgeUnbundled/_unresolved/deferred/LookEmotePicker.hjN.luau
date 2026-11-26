local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local gridMetrics = UIBlox.App.Grid.GridMetrics
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/bundled/egC")
local module2 = require("@luauforge/bundled/gxM")
local module3 = require("@luauforge/deferred/hbw")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local module5 = require("@luauforge/bundled/dRy")
local module6 = require("@luauforge/bundled/fCe")
local module7 = require("@luauforge/bundled/dPN")
local module8 = require("@luauforge/bundled/dRg")
local module9 = require("@luauforge/deferred/hcE")
local module10 = require("@luauforge/bundled/dRE")

local module11 = require("@luauforge/deferred/hjO")

local module12 = require("@luauforge/deferred/hjR")
local module13 = require("@luauforge/deferred/gSH")

local v5 = nil

if require("@luauforge/bundled/dRH")() then
	v5 = module10()
else
	local v6 = module5().AssetTypeToCategorySubcategory[module7.AssetTypeIdStrings.EmoteAnimation]

	if v6 then
		local category = v6.category
		local subcategory = v6.subcategory
		v5 = module6.getAvatarEditorCategoryInfo(category, subcategory)
	end
end

local function LookEmotePicker()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v6 = RoactGamepad.useRefCache()
	local v7 = useStyle()
	local v8 = useDispatch()
	local v9 = useDesignTokens()
	local v10

	if module13() then
		v10 = module2({ avatarEmoteSelection = "Feature.Avatar.Message.SelectEmote" })
	end

	local v11 = useSelector(function(p2): boolean
		return not p2.AvatarExperience.AvatarEditor.PageFinished[v5.SearchUuid]
	end)

	local v12 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v5.SearchUuid] or {}
	end)

	local v13 = v11 and #v12 == 0

	local v14 = v7.Font.Header2.RelativeSize * v7.Font.BaseSize
	local gridItemHeightGetterWithOptions = module6.GridItemHeightGetterWithOptions({
		itemTileType = module7.ItemTileType.AvatarEditorTile,
		fontHeight = v14
	})

	local v15 = React.useCallback(function()
		return v8(module9(v5))
	end, { v8 })

	React.useEffect(function()
		if v11 then
			v15()
		end
	end, {})

	local v16 = React.useCallback(function(p2)
		return React.createElement(module11, { itemId = p2 })
	end, {})

	return React.createElement(
		focusable.Frame,
		{
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
			ref = ref
		},
		{
			Header = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, v9.Size.Size_1200),
				BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
				BorderSizePixel = 0,
				Text = not module13() and "Select an emote to pose your Avatar" or v10.avatarEmoteSelection,
				FontFace = normalizeFontFace(v9.Typography.TitleLarge.Font),
				TextSize = v7.Font.BaseSize * v7.Font.Header2.RelativeSize,
				TextColor3 = v7.Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v9.Size.Size_300)
				})
			}),
			EmotesScrollingFrame = React.createElement(module, {
				Size = UDim2.new(1, 0, 1, -v9.Size.Size_1200),
				Position = UDim2.fromOffset(0, v9.Size.Size_1200),
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(1, 1),
				onLoadMore = if v11 then v15 else nil,
				hasMoreRows = v11,
				initializing = v13
			}, {
				ListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				EmotesContainer = React.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						Padding = React.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, module7.WidgetListHorizontalMargin),
							PaddingRight = UDim.new(0, module7.WidgetListHorizontalMargin),
							PaddingBottom = UDim.new(0, module7.WidgetListVerticalMargin)
						}),
						EmotesGridView = React.createElement(DefaultMetricsGridView, {
							getItemMetrics = gridMetrics.makeCustomMetricsGetter(module8.ItemsGridMetrics),
							items = v12,
							totalNumItems = 0,
							renderItem = v16,
							getItemHeight = gridItemHeightGetterWithOptions,
							LayoutOrder = 1
						})
					}
				),
				RecommendedEmotes = module12() and React.createElement(module3, {
					LayoutOrder = 2,
					categoryInfo = v5,
					itemDetailsPeekViewRefs = v6,
					baseRef = ref2,
					listFrameRef = ref,
					sendShopForMoreAnalytics = function() end
				})
			})
		}
	)
end

return LookEmotePicker
