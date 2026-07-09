local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

require(Modules.AvatarExperience.AvatarSwitcher.useAvatarSwitcherPageProps)

local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local Grid = AvatarExperienceUIKit.GridComponents.Grid
local AvatarSwitcherScrollingContent = require(Modules.AvatarExperience.AvatarSwitcher.AvatarSwitcherScrollingContent)
local AvatarTileContainer = require(Modules.AvatarExperience.AvatarSwitcher.AvatarTile.AvatarTileContainer)
local SettingsTileContainer = require(Modules.AvatarExperience.AvatarSwitcher.SettingsTile.SettingsTileContainer)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local OrganicEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.OrganicEventImpressionsReporter)
local FStringAXImpressionsEventName = require(Modules.AvatarExperience.Flags.FStringAXImpressionsEventName)
local LoadMoreButton = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventoryItemsList.LoadMoreButton)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local v29 = game:DefineFastFlag("AXRemoveAvatarSwitcherPageGamepadBindings", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function AvatarSwitcherPage(p1) -- line: 48
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useNavigation (copy), Foundation (copy), React (copy), useLocalization (copy), useSelector (copy), selectIsPortrait (copy), getUseSelectorDeepEquals (copy), SettingsTileContainer (copy), AvatarTileContainer (copy), AvatarScreen (copy), Focusable (copy), v29 (copy), SceneInteractionFrame (copy), AvatarExperienceView (copy), TopBar (copy), GamepadFocusHandlerForPage (copy), AvatarSwitcherScrollingContent (copy), Grid (copy), OrganicEventImpressionsReporter (copy), FStringAXImpressionsEventName (copy), ImpressionEnums (copy), LoadMoreButton (copy)
	local v33 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v34 = useNavigation()
	local v35 = Foundation.Hooks.useTokens()
	local v36 = RoactGamepad.useRefCache()
	local v37 = React.useRef(nil)
	local v38 = React.useRef(nil)
	local v39 = useLocalization({
		title = "Feature.Avatar.Label.Title.AvatarSwitcher"
	})
	local v40 = useSelector(selectIsPortrait, getUseSelectorDeepEquals())
	local v41 = React.useCallback(function(p2) -- line: 63
		-- upvalues: p1 (copy), React (copy), SettingsTileContainer (copy), v36 (copy), AvatarTileContainer (copy)
		local item = p2.item

		if p1.shouldRenderSettingsTile(item) then
			return (React.createElement(SettingsTileContainer, {
				itemWidth = p1.gridMetrics.itemWidth,
				index = p2.index,
				ref = v36[p2.index]
			}))
		end

		return React.createElement(AvatarTileContainer, {
			impressionsSchema = "defaultItem",
			itemWidth = p1.gridMetrics.itemWidth,
			itemId = item,
			index = p2.index,
			ref = v36[p2.index],
			isSelected = p1.itemIdsToIsWearing[item],
			hasItemFromCurrentPageEquipped = p1.hasItemFromCurrentPageEquipped,
			impressionsTag = p1.impressionsTag,
			gridInformation = p2.gridInformation
		})
	end, {
		p1.gridMetrics,
		p1.itemIdsToIsWearing,
		p1.shouldRenderSettingsTile
	})
	local v42 = React.useCallback(function() -- line: 86
		-- upvalues: React (copy), Foundation (copy), v34 (copy), AvatarScreen (copy)
		return React.createElement(Foundation.IconButton, {
			icon = "icons/common/settings",
			size = Foundation.Enums.IconSize.Medium,
			onActivated = function() -- line: 90
				-- upvalues: v34 (copy), AvatarScreen (copy)
				v34.navigate(AvatarScreen.ManageOutfitPage)
			end
		})
	end, {})

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v33 else nil,
		inputBindings = if not v29 then {
			Back = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p1.onBackButtonPressed)
		} else nil
	}, {
		AvatarSwitcherPageSceneInteractionFrame = React.createElement(SceneInteractionFrame),
		AvatarSwitcherExperienceView = React.createElement(AvatarExperienceView, {
			allowAdaptiveScrolling = true,
			showRobuxBalance = false,
			showUndoRedo = true,
			showSaveButton = false,
			isSceneFullView = p1.isSceneFullView,
			isUIFullView = p1.isUIFullView,
			topBar = React.createElement(TopBar.Container, {
				ZIndex = 3,
				titleText = v39.title,
				transparentBackground = v40,
				leftItem = TopBar.makeBackButton(p1.onBackButtonPressed),
				rightItems = { v42 },
				ref = v37,
				NextSelectionDown = v36[1]
			})
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = v33
			}) else nil,
			AvatarSwitcherContent = React.createElement(Foundation.View, {
				tag = "bg-surface-0 size-full-full",
				onAbsoluteSizeChanged = p1.onAbsoluteSizeChanged
			}, {
				AvatarSwitcherScrollingContent = React.createElement(AvatarSwitcherScrollingContent, {
					onThresholdReached = p1.onScrollingFrameThresholdReached,
					onCanvasPositionChanged = p1.onCanvasPositionChanged
				}, {
					ListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, v35.Gap.Medium)
					}),
					AvatarSwitcherGridContainer = React.createElement(Foundation.View, {
						tag = "auto-xy size-full-0",
						LayoutOrder = 1,
						padding = {
							left = UDim.new(0, v35.Size.Size_400),
							right = UDim.new(0, v35.Size.Size_400),
							bottom = UDim.new(0, v35.Size.Size_1000)
						}
					}, {
						AvatarSwitcherGrid = React.createElement(Grid, {
							itemsPerRow = p1.gridMetrics.itemsPerRow,
							renderItem = v41,
							items = p1.itemIds,
							gapVertical = v35.Size.Size_400,
							gapHorizontal = v35.Size.Size_300,
							getItemId = function(p3) -- line: 160
								return p3
							end,
							ref = v38
						})
					}),
					ImpressionsReporter = React.createElement(OrganicEventImpressionsReporter, {
						eventName = "marketplaceOrganicFELog",
						impressionsSchema = "defaultItem",
						requestId = "",
						parentRef = v38,
						pageFilter = p1.impressionsPageFilter,
						onRequestImpressionsSignal = p1.requestImpressionsSignal,
						eventContext = FStringAXImpressionsEventName(),
						impressionsTag = p1.impressionsTag,
						surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
						analyticsMetadata = p1.analyticsMetadata,
						searchUuid = p1.searchUuid
					}),
					LoadMoreButton = if not p1.showLoadMoreButton then nil else React.createElement(LoadMoreButton, {
						LayoutOrder = 2,
						onActivated = p1.fetchMoreOutfits
					})
				})
			})
		})
	})
end

return AvatarSwitcherPage
