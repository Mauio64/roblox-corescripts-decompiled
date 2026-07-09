local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDefaultFocusBehavior = require(CorePackages.Packages.ReactFocusNavigation).useDefaultFocusBehavior
local Utils = require(Modules.AvatarExperience.Common.Utils)
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local ClearResultsListFocusedWidget = require(Modules.AvatarExperience.Catalog.Actions.ClearResultsListFocusedWidget)
local v24 = Images["icons/navigation/pushBack"]
local v25 = Images["icons/navigation/close"]
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function mapTokens(t1: {[any]: any}) -- line: 38
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		tooltipIconPadding = if not FFlagRenameDeprecatedUIBloxTokens then t1.Global.Size_100 else t1.Size.Size_200,
		horizontalPadding = if not FFlagRenameDeprecatedUIBloxTokens then t1.Global.Size_200 else t1.Size.Size_400,
		widgetCloseOrBackButtonSize = if not FFlagRenameDeprecatedUIBloxTokens then t1.Global.Size_450 else t1.Size.Size_900,
		size250 = if not FFlagRenameDeprecatedUIBloxTokens then t1.Global.Size_250 else t1.Size.Size_500,
		size1300 = if not FFlagRenameDeprecatedUIBloxTokens then t1.Global.Size_1300 else t1.Size.Size_2600
	}
end

return function(t2: {[any]: any}) -- line: 65
	-- upvalues: useDispatch (copy), useDesignTokens (copy), mapTokens (copy), useStyle (copy), useDefaultFocusBehavior (copy), useLocalization (copy), React (copy), useSelector (copy), Utils (copy), getUseSelectorDeepEquals (copy), ClearResultsListFocusedWidget (copy), useIsSpatial (copy), ImageSetButton (copy), v25 (copy), v24 (copy), Roact (copy), withTooltip (copy), TooltipOrientation (copy), CoreGui (copy), IconSize (copy), IconButton (copy), Images (copy)
	local v30 = useDispatch()
	local v31 = useDesignTokens(mapTokens)
	local v32 = useStyle()
	local v33, v34 = useDefaultFocusBehavior()
	local v35 = if not t2.focusedWidgetTitle or t2.focusedWidgetTitle == "" then nil else t2.focusedWidgetTitle
	local v36 = if not t2.focusedWidgetTooltip or t2.focusedWidgetTooltip == "" then nil else t2.focusedWidgetTooltip
	local v37 = useLocalization({
		title = v35,
		tooltip = v36
	})
	local _ = v37.title
	local v39 = if not t2.focusedWidgetLocalizedTitle or t2.focusedWidgetLocalizedTitle == "" then v37.title else t2.focusedWidgetLocalizedTitle
	local tooltip = v37.tooltip

	if t2.focusedWidgetLocalizedTooltip and t2.focusedWidgetLocalizedTooltip ~= "" then
		tooltip = t2.focusedWidgetLocalizedTooltip
	end

	local v41, v42 = React.useState(false)
	local v43 = useSelector(Utils.isAvatarExperienceRoute, getUseSelectorDeepEquals())

	React.useEffect(function() -- line: 101
		-- upvalues: v43 (copy), v42 (copy)
		if not v43 then
			v42(false)
		end
	end, { v43 })

	local Theme = v32.Theme
	local Font = v32.Font
	local v46 = v31.size250 / 2
	local v47 = Font.BaseSize * Font.Header2.RelativeSize
	local v48 = React.useCallback(function() -- line: 114
		-- upvalues: v30 (copy), ClearResultsListFocusedWidget (copy), t2 (copy)
		v30(ClearResultsListFocusedWidget(t2.searchUuid))

		if type(t2.onClose) == "function" then
			t2.onClose()
		end
	end, {
		t2.searchUuid,
		t2.onClose
	})

	if not t2.active then
		return nil
	end

	local v49 = React.useCallback(function() -- line: 125
		-- upvalues: v42 (copy)
		v42(function(p1) -- line: 126
			return not p1
		end)
	end, {})
	local v50 = useIsSpatial()
	local v51 = tooltip and not v50

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Selectable = true,
		Size = UDim2.new(1, 0, 0, v31.size1300 / 2),
		ref = v34
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v31.horizontalPadding),
			PaddingRight = UDim.new(0, v31.horizontalPadding)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		BackButton = React.createElement(ImageSetButton, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v31.widgetCloseOrBackButtonSize, 0, v31.widgetCloseOrBackButtonSize),
			Image = if not t2.showCloseIcon then v24 else v25,
			ImageColor3 = Theme.SystemPrimaryDefault.Color,
			Visible = true,
			LayoutOrder = 1,
			[Roact.Event.Activated] = v48,
			ref = v33
		}),
		Divider = React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 2,
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency,
			Size = UDim2.new(0, 1, 0, 16)
		}),
		TitleFrame = if not v39 then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.fromScale(1, 1)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v31.tooltipIconPadding)
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v46),
				PaddingLeft = UDim.new(0, v31.size250 / 4),
				PaddingRight = UDim.new(0, v31.horizontalPadding),
				PaddingBottom = UDim.new(0, v46)
			}),
			Title = if not v39 then nil else React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Text = v39,
				Font = Font.Header2.Font,
				TextSize = v47,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			TitleTooltip = if not v51 then nil else withTooltip({
				useLargeDropShadow = true,
				bodyText = tooltip
			}, {
				DisplayOrder = 1,
				preferredOrientation = TooltipOrientation.Bottom,
				guiTarget = CoreGui,
				active = v41
			}, function(p2) -- line: 215
				-- upvalues: React (copy), IconSize (copy), IconButton (copy), Images (copy), Theme (copy), v49 (copy)
				return React.createElement("Frame", {
					Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					[React.Change.AbsolutePosition] = p2,
					[React.Change.AbsoluteSize] = p2
				}, { React.createElement(IconButton, {
					icon = Images["icons/actions/info_small"],
					iconSize = IconSize.Small,
					iconColor3 = Theme.SystemPrimaryDefault.Color,
					iconTransparency = Theme.SystemPrimaryDefault.Transparency,
					onActivated = v49
				}) })
			end)
		})
	})
end
