local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectedTheme = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useSelectedTheme
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local IconWithTooltip = require(CorePackages.Workspace.Packages.AppBlox).IconWithTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useTokens = Foundation.Hooks.useTokens
local Grid = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).GridComponents.Grid
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SponsoredItemsImpressionsTracker = require(Modules.AvatarExperience.Catalog.Components.Search.SponsoredItemsImpressionsTracker)
local selectSponsoredItems = require(Modules.AvatarExperience.Catalog.Selectors.selectSponsoredItems)
local WidgetListHorizontalMargin = Constants.WidgetListHorizontalMargin

local function SponsoredItems(t1: {[any]: any}) -- line: 70
	-- upvalues: useStyle (copy), useSelectedTheme (copy), useLocalization (copy), useTokens (copy), useSelector (copy), selectSponsoredItems (copy), getUseSelectorDeepEquals (copy), Constants (copy), React (copy), Cryo (copy), RoactGamepad (copy), WidgetListHorizontalMargin (copy), SponsoredItemsImpressionsTracker (copy), FFlagRenameDeprecatedUIBloxTokens (copy), IconWithTooltip (copy), TooltipOrientation (copy), Grid (copy)
	local t1LayoutOrder = t1.LayoutOrder
	local numItemsPerRow = t1.numItemsPerRow
	local v27 = useStyle()
	local v28 = useSelectedTheme() == "dark"
	local v29 = useLocalization({
		sponsored = "Feature.GamePage.Label.Sponsored",
		sponsoredDisclosure = "Feature.GamePage.Label.SponsoredDisclosure"
	})
	local v30 = useTokens()
	local v31 = useSelector(selectSponsoredItems, getUseSelectorDeepEquals())
	local v32 = numItemsPerRow * (Constants.SponsoredItemsRow - 1)
	local v33 = React.useMemo(function() -- line: 88
		-- upvalues: v31 (copy), numItemsPerRow (copy), Cryo (copy)
		if v31 and numItemsPerRow > 0 then
			return Cryo.List.getRange(v31, 1, numItemsPerRow)
		end

		return nil
	end, {
		v31,
		numItemsPerRow
	})
	local Font = v27.Font
	local BodyFont = Font.Body.Font
	local v36 = Font.BaseSize * Font.Header2.RelativeSize
	local Theme = v27.Theme
	local v38 = if not v28 then Theme.BackgroundContrast else Theme.BackgroundMuted

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BorderSizePixel = 0,
		Size = UDim2.new(1, WidgetListHorizontalMargin * 2, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = v38.Transparency,
		BackgroundColor3 = v38.Color,
		LayoutOrder = t1LayoutOrder,
		onFocusGained = t1.moveFocusToColumn
	}, {
		ImpressionsTracker = React.createElement(SponsoredItemsImpressionsTracker, {
			visibleItems = v33 or {},
			scrollingFrameRef = t1.scrollingFrameRef,
			sponsoredGridRef = t1.sponsoredGridRef,
			requestImpressionsSignal = t1.requestImpressionsSignal,
			indexOffset = v32
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, WidgetListHorizontalMargin),
			PaddingRight = UDim.new(0, WidgetListHorizontalMargin),
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		SponsoredLabel = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			SponsoredUIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Tokens.Global.Size_50 else v27.Tokens.Size.Size_100),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SponsoredTitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 1,
				Font = BodyFont,
				Text = v29.sponsored,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = v36,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Theme.TextMuted.Color
			}),
			SponsoredTooltip = React.createElement(IconWithTooltip, {
				layoutOrder = 2,
				triggerPointName = "SponsoredTooltip",
				supportTenFootUi = true,
				supportVR = true,
				tooltipOrientation = TooltipOrientation.Right,
				onActivateTooltip = t1.onActivateTooltipCallback,
				anchorPoint = Vector2.new(1, 0),
				hoverText = v29.sponsoredDisclosure
			})
		}),
		GridView = React.createElement(RoactGamepad.Focusable.Frame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			restorePreviousChildFocus = true,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			NextSelectionRight = t1.NextSelectionRight,
			NextSelectionUp = t1.NextSelectionUp,
			NextSelectionDown = t1.NextSelectionDown,
			ref = t1.sponsoredGridRef,
			onFocusGained = t1.onFocusGained
		}, React.createElement(Grid, {
			itemsPerRow = numItemsPerRow,
			getItemId = function(p1) -- line: 196
				return p1.id
			end,
			gapHorizontal = v30.Gap.Small,
			gapVertical = v30.Gap.Large,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			items = v33 or {},
			renderItem = t1.renderItem
		}))
	})
end

return SponsoredItems
