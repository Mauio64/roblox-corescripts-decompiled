local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelectedTheme = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useSelectedTheme
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local WidgetUtils = require(Modules.AvatarExperience.Common.WidgetUtils)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local WidgetConstants = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).WidgetConstants
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v23 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore

local function EntryButtonWidget(t1: {[any]: any}) -- line: 57
	-- upvalues: useNavigation (copy), useRoactService (copy), Analytics (copy), useSelector (copy), getUseSelectorDeepEquals (copy), FFlagSignalsNavP3gAvatarExperience (copy), v23 (copy), useSignalState (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), useSelectedTheme (copy), useStyle (copy), WidgetConstants (copy), WidgetUtils (copy), useLocalization (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), Focusable (copy)
	local v26 = useNavigation()
	local v27 = useRoactService(Analytics)
	local v28 = useSelector(function(p1) -- line: 60
		return p1.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
	end, getUseSelectorDeepEquals())
	local u30

	if FFlagSignalsNavP3gAvatarExperience then
		local v29 = v23(false)

		u30 = useSignalState(v29.getHistory)
	else
		u30 = useSelector(function(p2) -- line: 68
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return (Selectors.selectLegacyHistory(p2))
			end

			return p2.Navigation.history
		end, getUseSelectorDeepEquals())
	end

	local v31 = useSelectedTheme() == "dark"
	local v32 = useStyle()
	local Theme = v32.Theme
	local Font = v32.Font
	local widgetInfo = t1.widgetInfo
	local type = widgetInfo.type
	local v37 = if not type then nil else WidgetConstants.TypeToImageInfo[type]
	local v38 = nil
	local v39 = nil
	local rowHeight = t1.rowHeight

	if v37 then
		rowHeight *= v37.rowScale
		v38 = if not v31 then v37.backgroundImageLight else v37.backgroundImageDark
		v39 = if not v31 then v37.contentImageLight else v37.contentImageDark
	end

	local v41 = not v37 and 1.5 or v37.widthHeightRatio
	local v42 = useLocalization({
		titleText = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.title,
		descText = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.description
	})
	local v43 = useSelectionCursor(CursorKind.RoundedRect)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, rowHeight),
		LayoutOrder = t1.LayoutOrder
	}, {
		EntryButton = React.createElement(Focusable.ImageButton, {
			Size = UDim2.new(1, -3, 1, 0),
			Position = UDim2.fromOffset(1, 0),
			BackgroundTransparency = 1,
			Image = v38,
			ScaleType = Enum.ScaleType.Crop,
			[React.Event.Activated] = function() -- line: 82
				-- upvalues: v27 (copy), v28 (copy), WidgetConstants (copy), t1 (copy), widgetInfo (copy), WidgetUtils (copy), type (copy), v26 (copy), u30 (ref)
				v27.widgetInteraction(v28, WidgetConstants.ActionType.WIDGET_CLICK, nil, t1.widgetRow, nil, nil, widgetInfo.id)
				WidgetUtils.getEntryButtonWidgetActivationFunc(type, v26, u30)()
			end,
			ClipsDescendants = true,
			SelectionImageObject = v43
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			UIStroke = React.createElement("UIStroke", {
				Thickness = 1,
				Color = Theme.Divider.Color,
				Transparency = Theme.Divider.Transparency
			}),
			TextFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 8)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Title = if not v42.titleText then nil else React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = false,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Font = Font.Header1.Font,
					Text = v42.titleText,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = Font.BaseSize * Font.Header1.RelativeSize,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Description = if not v42.descText then nil else React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = false,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.XY,
					Font = Font.SubHeader1.Font,
					Text = v42.descText,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = Font.BaseSize * Font.SubHeader1.RelativeSize,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			ContentImageLabel = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				Image = v39,
				Size = UDim2.fromOffset(rowHeight * v41, rowHeight)
			})
		})
	})
end

return EntryButtonWidget
