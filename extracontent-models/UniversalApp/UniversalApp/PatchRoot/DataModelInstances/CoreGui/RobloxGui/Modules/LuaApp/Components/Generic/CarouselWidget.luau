local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local FitChildren = require(Modules.LuaApp.FitChildren)
local ScrollingAppCarousel = require(CorePackages.Workspace.Packages.AppBlox).ScrollingAppCarousel
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local DeviceType = RobloxAppEnums.DeviceType
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local IconWithTooltip = require(CorePackages.Workspace.Packages.AppBlox).IconWithTooltip
local maybeForceDarkTheme = require(CorePackages.Workspace.Packages.CollectionViews).maybeForceDarkTheme
local Foundation = require(CorePackages.Packages.Foundation)
local IconButton = Foundation.IconButton
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local GetFFlagLuaAppGameCarouselUseAutoSizing = require(Modules.LuaApp.Flags.GetFFlagLuaAppGameCarouselUseAutoSizing)
local FFlagLuaAppPropagateFriendsCarouselHeader = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPropagateFriendsCarouselHeader
local FFlagLuaAppDisableChevronSeeAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDisableChevronSeeAll
local v32 = Images["icons/actions/cycleRight"]
local v33 = Roact.PureComponent:extend("CarouselWidget")

function v33.getDerivedStateFromProps(p1, p2) -- line: 50
	-- upvalues: RetrievalStatus (copy)
	if p1.fetchingStatus == nil then
		return
	end

	local v36 = RetrievalStatus.fromRawValue(p1.fetchingStatus)
	local wasLoaded = p2.wasLoaded

	if v36 == RetrievalStatus.Done then
		wasLoaded = true
	elseif v36 == RetrievalStatus.Failed or v36 == RetrievalStatus.NotStarted then
		wasLoaded = false
	elseif v36 == RetrievalStatus.Fetching and wasLoaded then
		v36 = RetrievalStatus.Done
	end

	return {
		wasLoaded = wasLoaded,
		dataStatus = v36
	}
end
function v33.init(p3) -- line: 72
	-- upvalues: RetrievalStatus (copy)
	p3.state = {
		wasLoaded = false,
		dataStatus = RetrievalStatus.NotStarted
	}
end
function v33.didMount(p4) -- line: 79
	-- upvalues: RetrievalStatus (copy)
	p4:setState({
		wasLoaded = false,
		dataStatus = RetrievalStatus.fromRawValue(p4.props.fetchingStatus)
	})
end
function v33.render(p5) -- line: 86
	-- upvalues: FFlagLuaAppPropagateFriendsCarouselHeader (copy), Roact (copy), ScrollingAppCarousel (copy), FFlagLuaAppDisableChevronSeeAll (copy), ImageSetLabel (copy), v32 (copy), CursorKind (copy), DeviceType (copy), IconWithTooltip (copy), TooltipOrientation (copy), maybeForceDarkTheme (copy), LoadingStateContainer (copy), View (copy), IconButton (copy), IconSize (copy), GetFFlagLuaAppGameCarouselUseAutoSizing (copy), FitChildren (copy), withStyle (copy), withSelectionCursorProvider (copy)
	local layoutOrder = p5.props.layoutOrder
	local onSeeAll = p5.props.onSeeAll
	local title = p5.props.title
	local items = p5.props.items
	local fetchingStatus = p5.props.fetchingStatus
	local onRetry = p5.props.onRetry
	local carouselHeight = p5.props.carouselHeight
	local canvasWidth = p5.props.canvasWidth
	local onChangeCanvasPosition = p5.props.onChangeCanvasPosition
	local onRefCallback = p5.props.onRefCallback
	local index = p5.props.index
	local itemCount = p5.props.itemCount
	local itemWidth = p5.props.itemWidth
	local itemPadding = p5.props.itemPadding
	local carouselMargin = p5.props.carouselMargin
	local showSeeAll = p5.props.showSeeAll
	local designTokens = p5.props.designTokens
	local showTooltip = p5.props.showTooltip
	local onActivateTooltip = p5.props.onActivateTooltip
	local tooltipHoverText = p5.props.tooltipHoverText
	local deviceType = p5.props.deviceType
	local screenSize = p5.props.screenSize
	local v63 = not FFlagLuaAppPropagateFriendsCarouselHeader or title ~= nil and title ~= ""
	local darkThemeTextColor = nil

	if p5.props.forceDarkThemeForHeader then
		darkThemeTextColor = designTokens.darkThemeTextColor
	end

	local function v65(p6, p7) -- line: 119
		-- upvalues: Roact (copy), ScrollingAppCarousel (copy), items (copy), index (copy), itemCount (copy), itemWidth (copy), itemPadding (copy), carouselMargin (copy), carouselHeight (copy), canvasWidth (copy), onChangeCanvasPosition (copy), onRefCallback (copy), designTokens (copy), title (copy), darkThemeTextColor (ref), FFlagLuaAppDisableChevronSeeAll (copy), p5 (copy), showSeeAll (copy), ImageSetLabel (copy), v32 (copy), showTooltip (copy), screenSize (copy), CursorKind (copy), onSeeAll (copy), deviceType (copy), DeviceType (copy), IconWithTooltip (copy), TooltipOrientation (copy), onActivateTooltip (copy), tooltipHoverText (copy), v63 (copy), maybeForceDarkTheme (copy), fetchingStatus (copy), LoadingStateContainer (copy), onRetry (copy), View (copy), IconButton (copy), IconSize (copy), GetFFlagLuaAppGameCarouselUseAutoSizing (copy), layoutOrder (copy), FitChildren (copy)
		local Theme = p6.Theme
		local p6Font = p6.Font
		local v77 = Roact.createElement(ScrollingAppCarousel, {
			items = items,
			index = index,
			itemCount = itemCount,
			itemWidth = itemWidth,
			itemPadding = itemPadding,
			carouselMargin = carouselMargin,
			carouselHeight = carouselHeight,
			canvasWidth = canvasWidth,
			onChangeCanvasPosition = onChangeCanvasPosition,
			onRefCallback = onRefCallback
		})
		local v78 = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Font = designTokens.headerFont,
			Text = title,
			TextSize = designTokens.headerTextSize,
			TextColor3 = darkThemeTextColor or Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextTruncate = Enum.TextTruncate.SplitWord
		})
		local v79 = not FFlagLuaAppDisableChevronSeeAll
		local t1 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = if not v79 then UDim.new(0, 4) else p5.props.textIconPadding
			}),
			Title = v78,
			SeeAllArrow = showSeeAll and Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = if not v79 then UDim2.new(0, 20, 0, 20) else p5.props.seeAllImageSize or UDim2.new(0, 20, 0, 20),
				Image = v32,
				ImageColor3 = darkThemeTextColor or Theme.TextEmphasis.Color,
				ImageTransparency = Theme.TextEmphasis.Transparency
			}) or nil,
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = if not showTooltip then Vector2.new(screenSize.X - 2 * (carouselMargin or 0), 1e999) else Vector2.new(screenSize.X - 2 * (carouselMargin or 0) - 48, 1e999)
			})
		}
		local v81 = p5.props.subtitle and p5.props.subtitle ~= ""
		local subtitleTextSize = designTokens.subtitleTextSize
		local v83 = nil

		if v81 then
			if type(p5.props.subtitle) == "string" then
				v83 = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					TextWrapped = true,
					Text = p5.props.subtitle,
					Size = UDim2.new(1, 0, 0, subtitleTextSize),
					Font = p6Font.Body.Font,
					TextColor3 = darkThemeTextColor or Theme.TextDefault.Color,
					TextSize = subtitleTextSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y
				})
			elseif type(p5.props.subtitle) == "table" then
				v83 = p5.props.subtitle
			end
		end

		local v84 = if not v81 then t1 else {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			TitleWrapper = Roact.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(),
				AutomaticSize = Enum.AutomaticSize.XY
			}, t1),
			Subtitle = v83,
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(screenSize.X - 2 * (carouselMargin or 0), 1e999)
			})
		}
		local v85 = if not showSeeAll then Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, v84) else Roact.createElement("ImageButton", {
			AutomaticSize = Enum.AutomaticSize.XY,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			SelectionImageObject = p7(CursorKind.InputButton),
			[Roact.Event.Activated] = onSeeAll
		}, v84)
		local v86 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, screenSize.X - 48, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = if deviceType ~= DeviceType.Desktop then nil else Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			HeaderText = v85,
			CarouselTooltip = Roact.createElement(IconWithTooltip, {
				layoutOrder = 2,
				triggerPointName = "CarouselTooltip",
				tooltipOrientation = TooltipOrientation.Bottom,
				onActivateTooltip = onActivateTooltip,
				anchorPoint = Vector2.new(1, 0),
				position = if deviceType ~= DeviceType.Desktop then UDim2.new(1, 0, 0, 0) else nil,
				hoverText = tooltipHoverText
			})
		})
		local t2 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12)
			}),
			Header = v63 and maybeForceDarkTheme(if not showTooltip then v85 else v86, p5.props.forceDarkThemeForHeader),
			CarouselFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, carouselHeight)
			}, {
				CarouselContent = fetchingStatus and Roact.createElement(LoadingStateContainer, {
					dataStatus = p5.state.dataStatus,
					onRetry = onRetry,
					renderOnLoading = function() -- line: 287
						return nil
					end,
					renderOnLoaded = function() -- line: 290
						-- upvalues: v77 (copy)
						return v77
					end
				}) or v77
			})
		}
		local v88 = if not p5.props.onActivateInfoIcon then nil else Roact.createElement(View, {
			tag = "col align-x-right align-y-top",
			Size = UDim2.new(1, -designTokens.iconSizeSmall, 0, -12)
		}, {
			Roact.createElement(View, {
				Size = UDim2.new(0, 0, 0, 14)
			}),
			Roact.createElement(IconButton, {
				icon = "icons/actions/info_small",
				size = IconSize.Small,
				onActivated = p5.props.onActivateInfoIcon
			})
		})

		if GetFFlagLuaAppGameCarouselUseAutoSizing() then
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = layoutOrder
			}, t2, v88)
		end

		return Roact.createElement(FitChildren.FitFrame, {
			BackgroundTransparency = 1,
			fitAxis = FitChildren.FitAxis.Height,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = layoutOrder
		}, t2, v88)
	end

	return withStyle(function(p8) -- line: 327
		-- upvalues: withSelectionCursorProvider (copy), v65 (copy)
		return withSelectionCursorProvider(function(p9) -- line: 328
			-- upvalues: v65 (copy), p8 (copy)
			return v65(p8, p9)
		end)
	end)
end

return function(p10) -- line: 333
	-- upvalues: useUiModeInfo (copy), useStyle (copy), useDesignTokens (copy), UiMode (copy), useSelector (copy), Cryo (copy), Roact (copy), v33 (copy)
	local v67 = useUiModeInfo()
	local v68 = useStyle()
	local v69 = useDesignTokens(function(p11) -- line: 336
		-- upvalues: v67 (copy), UiMode (copy), v68 (copy)
		if v67.uiMode == UiMode.TenFoot then
			return {
				headerFont = p11.Typography.HeadingSmall.Font,
				headerTextSize = p11.Typography.HeadingSmall.FontSize,
				subtitleTextSize = p11.Typography.TitleLarge.FontSize,
				darkThemeTextColor = p11.Color.Extended.White.White_100.Color3,
				iconSizeSmall = p11.Size.Size_800
			}
		end

		return {
			headerFont = v68.Font.Header1.Font,
			headerTextSize = v68.Font.BaseSize * v68.Font.Header1.RelativeSize,
			subtitleTextSize = v68.Font.BaseSize * v68.Font.CaptionLarge.RelativeSize,
			darkThemeTextColor = p11.Color.Extended.White.White_100.Color3,
			iconSizeSmall = p11.Size.Size_800
		}
	end)
	local v70 = useSelector(function(p12) -- line: 355
		return p12.ScreenSize
	end)
	local v71 = p10.showSeeAll and v67.uiMode ~= UiMode.TenFoot
	local v72 = Cryo.Dictionary.join(p10, {
		designTokens = v69,
		showSeeAll = v71,
		screenSize = v70
	})

	return Roact.createElement(v33, v72)
end
