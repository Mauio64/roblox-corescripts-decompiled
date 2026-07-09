local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local GridMetrics = UIBlox.App.Grid.GridMetrics
local useStyle = UIBlox.Core.Style.useStyle
local RefreshScrollingFrameWithLoadMore = require(Modules.LuaApp.Components.RefreshScrollingFrameWithLoadMore)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local RecommendedItems = require(Modules.AvatarExperience.Common.Components.RecommendedItems)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local GetAvatarEditorStructure = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorStructure)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local GetUserInventory = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventory)
local getEmotesCategory = require(Modules.AvatarExperience.Common.getEmotesCategory)
local LookEmotePickerTile = require(script.Parent.LookEmotePickerTile)
local GetFFlagAXLookComposerRecommendedEmotes = require(Modules.AvatarExperience.Flags.GetFFlagAXLookComposerRecommendedEmotes)
local GetFFlagAXLooksTranslationAudit = require(Modules.AvatarExperience.Flags.GetFFlagAXLooksTranslationAudit)
local GetFFlagAXExtractEmotesCategory = require(Modules.AvatarExperience.Flags.GetFFlagAXExtractEmotesCategory)
local u27 = nil

if GetFFlagAXExtractEmotesCategory() then
	u27 = getEmotesCategory()
else
	local v28 = GetAvatarEditorStructure().AssetTypeToCategorySubcategory[Constants.AssetTypeIdStrings.EmoteAnimation]

	if v28 then
		local category = v28.category
		local subcategory = v28.subcategory

		u27 = Utils.getAvatarEditorCategoryInfo(category, subcategory)
	end
end

local function LookEmotePicker() -- line: 55
	-- upvalues: React (copy), RoactGamepad (copy), useStyle (copy), useDispatch (copy), useDesignTokens (copy), GetFFlagAXLooksTranslationAudit (copy), useLocalization (copy), useSelector (copy), u27 (ref), Utils (copy), Constants (copy), GetUserInventory (copy), LookEmotePickerTile (copy), Focusable (copy), FFlagRenameDeprecatedUIBloxTokens (copy), RefreshScrollingFrameWithLoadMore (copy), LoadableGridView (copy), GridMetrics (copy), Constants2 (copy), GetFFlagAXLookComposerRecommendedEmotes (copy), RecommendedItems (copy)
	local v32 = React.useRef(nil)
	local v33 = React.useRef(nil)
	local v34 = RoactGamepad.useRefCache()
	local v35 = useStyle()
	local v36 = useDispatch()
	local v37 = useDesignTokens()
	local v38 = if not GetFFlagAXLooksTranslationAudit() then nil else useLocalization({
		avatarEmoteSelection = "Feature.Avatar.Message.SelectEmote"
	})
	local v39 = useSelector(function(p1) -- line: 69
		-- upvalues: u27 (ref)
		return not p1.AvatarExperience.AvatarEditor.PageFinished[u27.SearchUuid]
	end)
	local v40 = useSelector(function(p2) -- line: 72
		-- upvalues: u27 (ref)
		return p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[u27.SearchUuid] or {}
	end)
	local v41 = v39 and #v40 == 0
	local v42 = v35.Font.Header2.RelativeSize * v35.Font.BaseSize
	local v43 = Utils.GridItemHeightGetterWithOptions({
		itemTileType = Constants.ItemTileType.AvatarEditorTile,
		fontHeight = v42
	})
	local v44 = React.useCallback(function() -- line: 85
		-- upvalues: v36 (copy), GetUserInventory (copy), u27 (ref)
		return v36(GetUserInventory(u27))
	end, { v36 })

	React.useEffect(function() -- line: 89
		-- upvalues: v39 (copy), v44 (copy)
		if v39 then
			v44()
		end
	end, {})

	local v45 = React.useCallback(function(p3) -- line: 95
		-- upvalues: React (copy), LookEmotePickerTile (copy)
		return React.createElement(LookEmotePickerTile, {
			itemId = p3
		})
	end, {})

	return React.createElement(Focusable.Frame, {
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v35.Theme.BackgroundDefault.Color,
		ref = v32
	}, {
		Header = React.createElement("TextLabel", {
			BorderSizePixel = 0,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then v37.Global.Size_600 else v37.Size.Size_1200),
			BackgroundColor3 = v35.Theme.BackgroundDefault.Color,
			Text = not GetFFlagAXLooksTranslationAudit() and "Select an emote to pose your Avatar" or v38.avatarEmoteSelection,
			Font = v35.Font.Header2.Font,
			TextSize = v35.Font.BaseSize * v35.Font.Header2.RelativeSize,
			TextColor3 = v35.Theme.TextDefault.Color,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v37.Global.Space_150 else v37.Size.Size_300)
			})
		}),
		EmotesScrollingFrame = React.createElement(RefreshScrollingFrameWithLoadMore, {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -if not FFlagRenameDeprecatedUIBloxTokens then v37.Global.Size_600 else v37.Size.Size_1200),
			Position = UDim2.fromOffset(0, if not FFlagRenameDeprecatedUIBloxTokens then v37.Global.Size_600 else v37.Size.Size_1200),
			CanvasSize = UDim2.fromScale(1, 1),
			onLoadMore = if not v39 then nil else v44,
			hasMoreRows = v39,
			initializing = v41
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			EmotesContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, Constants.WidgetListHorizontalMargin),
					PaddingRight = UDim.new(0, Constants.WidgetListHorizontalMargin),
					PaddingBottom = UDim.new(0, Constants.WidgetListVerticalMargin)
				}),
				EmotesGridView = React.createElement(LoadableGridView, {
					totalNumItems = 0,
					LayoutOrder = 1,
					getItemMetrics = GridMetrics.makeCustomMetricsGetter(Constants2.ItemsGridMetrics),
					items = v40,
					renderItem = v45,
					getItemHeight = v43
				})
			}),
			RecommendedEmotes = GetFFlagAXLookComposerRecommendedEmotes() and React.createElement(RecommendedItems, {
				LayoutOrder = 2,
				categoryInfo = u27,
				itemDetailsPeekViewRefs = v34,
				baseRef = v33,
				listFrameRef = v32,
				sendShopForMoreAnalytics = function() -- line: 199
				end
			})
		})
	})
end

return LookEmotePicker
