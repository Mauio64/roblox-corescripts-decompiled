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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local gridMetrics = UIBlox.App.Grid.GridMetrics
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/bundled/edf")
local module2 = require("@luauforge/bundled/fTi")
local module3 = require("@luauforge/deferred/gPt")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local module5 = require("@luauforge/bundled/dOi")
local module6 = require("@luauforge/bundled/fuD")
local module7 = require("@luauforge/bundled/dMx")
local module8 = require("@luauforge/bundled/dNQ")
local module9 = require("@luauforge/deferred/gQy")
local module10 = require("@luauforge/bundled/dOo")

local module11 = require("@luauforge/deferred/gXC")

local module12 = require("@luauforge/deferred/gXF")
local module13 = require("@luauforge/deferred/god")

local v5 = nil

if require("@luauforge/bundled/dOr")() then
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

	local createElement = React.createElement
	local frame = focusable.Frame
	local v17 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
		ref = ref
	}

	local createElement2 = React.createElement
	local v19 = {
		Size = UDim2.new(1, 0, 0, v9.Size.Size_1200),
		BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Text = not module13() and "Select an emote to pose your Avatar" or v10.avatarEmoteSelection,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = true
	}

	local v20 = if not foundationFontFaceMigration then v7.Font.Header2.Font else nil
	v19.Font = v20

	local v21 = if foundationFontFaceMigration then normalizeFontFace(v9.Typography.TitleLarge.Font) else nil
	v19.FontFace = v21

	v19.TextSize = v7.Font.BaseSize * v7.Font.Header2.RelativeSize
	v19.TextColor3 = v7.Theme.TextDefault.Color
	v19.TextXAlignment = Enum.TextXAlignment.Left
	v19.TextYAlignment = Enum.TextYAlignment.Center
	return createElement(frame, v17, {
		Header = createElement2("TextLabel", v19, {
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
	})
end

return LookEmotePicker
