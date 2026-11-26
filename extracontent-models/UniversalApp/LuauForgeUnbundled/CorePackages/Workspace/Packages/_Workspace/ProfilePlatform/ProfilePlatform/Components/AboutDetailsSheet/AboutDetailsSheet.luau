local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local PeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/PeekView")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local InputUi = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputUi")
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").useNavigationProps
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileCardWidth")
local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Hooks.useProfileCardWidth
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local navigateBack = NavigationRodux.Thunks.NavigateBack
local useScreenSize = RobloxAppHooks.useScreenSize
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local getSafeAreaSize = InputUi.getSafeAreaSize
local peekViewWithTopBar = PeekView.PeekViewWithTopBar
local peekViewState = PeekView.PeekViewState
local fFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local fFlagSwitchProfileWidthHookToSocialCommon = SharedFlags.FFlagSwitchProfileWidthHookToSocialCommon
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local splitPaneStore = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SplitPane").SplitPaneStore else nil
local useSignalState = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState else nil

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local iconButton = Foundation.IconButton
local view = Foundation.View
local text = Foundation.Text
local sheet = Foundation.Sheet
local overlayProvider = Foundation.OverlayProvider

local v5 = { 0.55, 1 }

local v6 = {
	position = UDim2.fromScale(0, 0),
	size = UDim2.fromScale(1, 1),
	anchorPoint = Vector2.new(0, 0)
}

local function AboutDetailsSheetLegacy(p2)
	local udim = UDim.new(0.55, 0)
	local v7 = useTopBarHeight()
	local v8 = useDispatch()
	local v9 = useProfileFormFactor()
	local v10 = v9.formFactor == Enums.ProfileFormFactor.Wide
	local v11

	if fFlagEnableSplitPane then
		v11 = useSignalState(splitPaneStore.getStore().getIsSplitEnabled)
	else
		v11 = false
	end

	local v12 = useScreenSize()
	local v13 = useSelector(function(p3)
		return p3.GlobalGuiInset
	end)

	local v14 = useSelector(function(p3)
		return p3.TopBar.statusBarHeight
	end)

	local safeAreaSize = getSafeAreaSize(v12, v13)
	local v15

	if fFlagProfilePlatformNewProfileHeader then
		v15 = if fFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth() else module12(v10)
	else
		v15 = math.min(safeAreaSize.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH)
	end

	local v16 = v15 / safeAreaSize.X.Offset

	local v17 = React.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v8(navigateBack(true))
		end
	end, { v8 })

	local v18 = React.useCallback(function()
		v17()
	end, { v17 })

	local v19 = React.useCallback(function(p3, p4, p5)
		if p3 == peekViewState.Closed then
			v17()
		end
	end, { v17 })

	local sections = useNavigationProps(function(p3, p4)
		return { sections = p4.sections }
	end).sections or {}

	local v20 = {
		position = UDim2.fromScale(1, 0),
		size = UDim2.fromScale(v16, 1),
		anchorPoint = Vector2.new(1, 0)
	}

	local v21 = React.useMemo(function()
		if fFlagEnableSplitPane and v11 then
			return v6
		end

		if v10 then
			return v20
		end

		return v6
	end, { v9.formFactor, v11 })

	return React.createElement(
		view,
		{ Size = v21.size, Position = v21.position, AnchorPoint = v21.anchorPoint },
		{
			AboutDetailsSheet = React.createElement(peekViewWithTopBar, {
				briefViewContentHeight = udim,
				fullViewContentHeight = UDim.new(1, -v7),
				onViewStateChanged = v19,
				topBarHeight = v7,
				topBarSlot = React.createElement(view, {
					tag = "bg-surface-100",
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 0, 0, v7),
					Active = true,
					BorderSizePixel = 0
				}, {
					LeftNavigationButton = React.createElement(iconButton, {
						Position = UDim2.new(0, 15, 0, v14),
						BackgroundTransparency = 1,
						onActivated = v18,
						icon = "icons/navigation/close"
					})
				}),
				contentSlot = React.createElement(view, {
					Size = UDim2.new(1, 0, 1, -v7),
					tag = "auto-y align-x-center col padding-bottom-large"
				}, {
					Contents = React.createElement(
						view,
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
		}
	)
end

local function AboutDetailsSheetFoundation(p2)
	local v7 = useDispatch()
	local v8

	if fFlagEnableSplitPane then
		v8 = useSignalState(splitPaneStore.getStore().getIsSplitEnabled)
	else
		v8 = false
	end

	local v9 = React.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v7(navigateBack(true))
		end
	end, { v7 })

	local v10 = useNavigationProps(function(p3, p4)
		return { sections = p4.sections, profileName = p4.profileName }
	end)

	local sections = v10.sections or {}
	local profileName = v10.profileName

	local state, setState = React.useState(nil)
	local v11 = useLocalization({
		about = TextKeys.About,
		aboutHeading = {
			TextKeys.AboutDetailsHeading,
			name = profileName or ""
		}
	})
	local v12 = state ~= nil

	if fFlagEnableSplitPane and v8 then
		v12 = true
		state = nil
	end

	local createElement = React.createElement
	local v14 = { ref = setState, Size = UDim2.fromScale(1, 1) }
	local v16

	if v12 then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local root = sheet.Root

		local createElement4 = React.createElement
		local header = sheet.Header

		local createElement5 = React.createElement

		local v25 = if profileName then v11.aboutHeading else v11.about
		local children = {
			Header = createElement4(header, { hasCloseAffordance = true }, {
				HeaderContent = createElement5(text, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-heading-small text-align-x-left",
					Text = v25
				})
			}),
			Content = React.createElement(sheet.Content, nil, {
				Contents = React.createElement(
					view,
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
		v16 = createElement2(overlayProvider, { gui = state }, {
			AboutSheet = createElement3(root, {
				onClose = v9,
				isOpen = true,
				preferCenterSheet = true,
				snapPoints = v5,
				defaultSnapPointIndex = 1
			}, children)
		}) or nil
	end

	return createElement(view, v14, { Overlay = v16 })
end

local function AboutDetailsSheet(p2)
	if fFlagProfileAboutDetailsUseSheet then
		return AboutDetailsSheetFoundation(p2)
	end

	return AboutDetailsSheetLegacy(p2)
end

return AboutDetailsSheet
