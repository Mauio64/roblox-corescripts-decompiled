local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local PeekView = require(parent.PeekView)
local RoactUtils = require(parent.RoactUtils)
local NavigationRodux = require(parent.NavigationRodux)
local Foundation = require(parent.Foundation)
local InputUi = require(parent.InputUi)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local SharedFlags = require(parent.SharedFlags)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local Enums = require(ProfilePlatform.Common.Enums)
local Constants = require(ProfilePlatform.Common.Constants)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth2 = ProfilePlatformCommon.Hooks.useProfileCardWidth
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local useScreenSize = RobloxAppHooks.useScreenSize
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local getSafeAreaSize = InputUi.getSafeAreaSize
local PeekViewWithTopBar = PeekView.PeekViewWithTopBar
local PeekViewState = PeekView.PeekViewState
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local splitPaneStore

if FFlagEnableSplitPane then
	local SplitPane = require(parent.SplitPane)
	splitPaneStore = SplitPane.SplitPaneStore
else
	splitPaneStore = nil
end

local useSignalState

if FFlagEnableSplitPane then
	local SignalsReact = require(parent.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation2 = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation2.NavigationCommands
else
	navigationCommands = nil
end

local IconButton = Foundation.IconButton
local View = Foundation.View
local Text = Foundation.Text
local Sheet = Foundation.Sheet
local OverlayProvider = Foundation.OverlayProvider

local snapPoints = { 0.55, 1 }

local v = {
	position = UDim2.fromScale(0, 0),
	size = UDim2.fromScale(1, 1),
	anchorPoint = Vector2.new(0, 0)
}

local function AboutDetailsSheetLegacy(_)
	local udim = UDim.new(0.55, 0)
	local topBarHeight = useTopBarHeight()
	local v2 = useDispatch()
	local v3 = useProfileFormFactor()
	local v4 = v3.formFactor == Enums.ProfileFormFactor.Wide
	local v5

	if FFlagEnableSplitPane then
		v5 = useSignalState(splitPaneStore.getStore().getIsSplitEnabled)
	else
		v5 = false
	end

	local v6 = useScreenSize()
	local v7 = useSelector(function(p)
		return p.GlobalGuiInset
	end)

	local v8 = useSelector(function(p)
		return p.TopBar.statusBarHeight
	end)

	local safeAreaSize = getSafeAreaSize(v6, v7)
	local v9

	if FFlagProfilePlatformNewProfileHeader then
		if FFlagSwitchProfileWidthHookToSocialCommon then
			v9 = useProfileCardWidth2()
		else
			v9 = useProfileCardWidth(v4)
		end
	else
		v9 = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local v10 = v9 / safeAreaSize.X.Offset

	local v11 = React.useCallback(function()
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v2(NavigateBack(true))
		end
	end, { v2 })

	local onActivated = React.useCallback(function()
		v11()
	end, { v11 })

	local onViewStateChanged = React.useCallback(function(p, _, _)
		if p == PeekViewState.Closed then
			v11()
		end
	end, { v11 })

	local sections = useNavigationProps(function(_, p)
		return { sections = p.sections }
	end).sections or {}

	local v12 = {
		position = UDim2.fromScale(1, 0),
		size = UDim2.fromScale(v10, 1),
		anchorPoint = Vector2.new(1, 0)
	}

	local v13 = React.useMemo(function()
		if FFlagEnableSplitPane and v5 then
			return v
		end

		return if v4 then v12 else v
	end, { v3.formFactor, v5 })

	return React.createElement(View, {
		Size = v13.size,
		Position = v13.position,
		AnchorPoint = v13.anchorPoint
	}, {
		AboutDetailsSheet = React.createElement(PeekViewWithTopBar, {
			briefViewContentHeight = udim,
			fullViewContentHeight = UDim.new(1, -topBarHeight),
			onViewStateChanged = onViewStateChanged,
			topBarHeight = topBarHeight,
			topBarSlot = React.createElement(View, {
				tag = "bg-surface-100",
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 0, 0, topBarHeight),
				Active = true,
				BorderSizePixel = 0
			}, {
				LeftNavigationButton = React.createElement(IconButton, {
					Position = UDim2.new(0, 15, 0, v8),
					BackgroundTransparency = 1,
					onActivated = onActivated,
					icon = "icons/navigation/close"
				})
			}),
			contentSlot = React.createElement(View, {
				Size = UDim2.new(1, 0, 1, -topBarHeight),
				tag = "auto-y align-x-center col padding-bottom-large"
			}, {
				Contents = React.createElement(
					View,
					{
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						tag = "align-x-center col padding-x-xlarge gap-xlarge padding-top-large padding-bottom-large"
					},
					{
						ContentSections = React.createElement(React.Fragment, {}, sections)
					}
				)
			})
		})
	})
end

local function AboutDetailsSheetFoundation(_)
	local v2 = useDispatch()
	local v3

	if FFlagEnableSplitPane then
		v3 = useSignalState(splitPaneStore.getStore().getIsSplitEnabled)
	else
		v3 = false
	end

	local onClose = React.useCallback(function()
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v2(NavigateBack(true))
		end
	end, { v2 })

	local v4 = useNavigationProps(function(_, p)
		return { sections = p.sections, profileName = p.profileName }
	end)

	local sections = v4.sections or {}
	local profileName = v4.profileName

	local state, setState = React.useState(nil)
	local v5 = useLocalization({
		about = TextKeys.About,
		aboutHeading = {
			TextKeys.AboutDetailsHeading,
			name = profileName or ""
		}
	})
	local v6 = state ~= nil

	if FFlagEnableSplitPane and v3 then
		v6 = true
		state = nil
	end

	local createElement = React.createElement
	local v7 = { ref = setState, Size = UDim2.fromScale(1, 1) }
	local overlay

	if v6 then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local root = Sheet.Root

		local createElement4 = React.createElement
		local header = Sheet.Header

		local createElement5 = React.createElement

		local text = if profileName then v5.aboutHeading else v5.about
		local children = {
			Header = createElement4(header, { hasCloseAffordance = true }, {
				HeaderContent = createElement5(Text, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-heading-small text-align-x-left",
					Text = text
				})
			}),
			Content = React.createElement(Sheet.Content, nil, {
				Contents = React.createElement(
					View,
					{
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						tag = "col align-x-center gap-xlarge padding-bottom-large"
					},
					{
						ContentSections = React.createElement(React.Fragment, {}, sections)
					}
				)
			})
		}
		overlay = createElement2(OverlayProvider, { gui = state }, {
			AboutSheet = createElement3(root, {
				onClose = onClose,
				isOpen = true,
				preferCenterSheet = true,
				snapPoints = snapPoints,
				defaultSnapPointIndex = 1
			}, children)
		}) or nil
	end

	return createElement(View, v7, { Overlay = overlay })
end

local function AboutDetailsSheet(p)
	if FFlagProfileAboutDetailsUseSheet then
		return AboutDetailsSheetFoundation(p)
	end

	return AboutDetailsSheetLegacy(p)
end

return AboutDetailsSheet
