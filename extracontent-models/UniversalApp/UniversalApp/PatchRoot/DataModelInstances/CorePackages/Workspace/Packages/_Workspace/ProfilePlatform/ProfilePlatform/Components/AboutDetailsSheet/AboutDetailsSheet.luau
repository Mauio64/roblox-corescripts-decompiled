local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local PeekView = require(ProfilePlatformParent.PeekView)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local Foundation = require(ProfilePlatformParent.Foundation)
local InputUi = require(ProfilePlatformParent.InputUi)
local useNavigationProps = require(ProfilePlatformParent.RobloxAppNavigation).useNavigationProps
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local Enums = require(ProfilePlatform.Common.Enums)
local Constants = require(ProfilePlatform.Common.Constants)
local useProfileCardWidth = require(ProfilePlatform.Hooks.useProfileCardWidth)
local useProfileCardWidth2 = require(ProfilePlatformParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
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
local v31 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local IconButton = Foundation.IconButton
local View = Foundation.View
local FoundationText = Foundation.Text
local Sheet = Foundation.Sheet
local OverlayProvider = Foundation.OverlayProvider
local t1 = {
	0.55,
	1
}
local t2 = {
	position = UDim2.fromScale(0, 0),
	size = UDim2.fromScale(1, 1),
	anchorPoint = Vector2.new(0, 0)
}

local function AboutDetailsSheetLegacy(_) -- line: 55
	-- upvalues: useTopBarHeight (copy), useDispatch (copy), useProfileFormFactor (copy), Enums (copy), useScreenSize (copy), useSelector (copy), getSafeAreaSize (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagSwitchProfileWidthHookToSocialCommon (copy), useProfileCardWidth2 (copy), useProfileCardWidth (copy), Constants (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), NavigateBack (copy), PeekViewState (copy), useNavigationProps (copy), t2 (copy), View (copy), PeekViewWithTopBar (copy), IconButton (copy)
	local uDim = UDim.new(0.55, 0)
	local v44 = useTopBarHeight()
	local v45 = useDispatch()
	local v46 = useProfileFormFactor()
	local v47 = v46.formFactor == Enums.ProfileFormFactor.Wide
	local v48 = useScreenSize()
	local v49 = useSelector(function(p2) -- line: 63
		return p2.GlobalGuiInset
	end)
	local v50 = useSelector(function(p3) -- line: 66
		return p3.TopBar.statusBarHeight
	end)
	local v51 = getSafeAreaSize(v48, v49)
	local v52 = ((if not FFlagProfilePlatformNewProfileHeader then math.min(v51.X.Offset, Constants.MAXIMUM_CONTAINER_WIDTH) else (if not FFlagSwitchProfileWidthHookToSocialCommon then useProfileCardWidth(v47) else useProfileCardWidth2()))) / v51.X.Offset
	local v53 = React.useCallback(function() -- line: 79
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v31 (copy), v45 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v31.back(true)

			return
		end

		v45(NavigateBack(true))
	end, { v45 })
	local v54 = React.useCallback(function() -- line: 87
		-- upvalues: v53 (copy)
		v53()
	end, { v53 })
	local v55 = React.useCallback(function(p4, _, _) -- line: 91
		-- upvalues: PeekViewState (copy), v53 (copy)
		if p4 == PeekViewState.Closed then
			v53()
		end
	end, { v53 })
	local v56 = useNavigationProps(function(_, p8) -- line: 97
		return {
			sections = p8.sections
		}
	end).sections or {}
	local t3 = {
		position = UDim2.fromScale(1, 0),
		size = UDim2.fromScale(v52, 1),
		anchorPoint = Vector2.new(1, 0)
	}
	local v58 = React.useMemo(function() -- line: 110
		-- upvalues: v47 (copy), t3 (copy), t2 (copy)
		if v47 then
			return t3
		end

		return t2
	end, { v46.formFactor })

	return React.createElement(View, {
		Size = v58.size,
		Position = v58.position,
		AnchorPoint = v58.anchorPoint
	}, {
		AboutDetailsSheet = React.createElement(PeekViewWithTopBar, {
			briefViewContentHeight = uDim,
			fullViewContentHeight = UDim.new(1, -v44),
			onViewStateChanged = v55,
			topBarHeight = v44,
			topBarSlot = React.createElement(View, {
				tag = "bg-surface-100",
				Active = true,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 0, 0, v44)
			}, {
				LeftNavigationButton = React.createElement(IconButton, {
					BackgroundTransparency = 1,
					icon = "icons/navigation/close",
					Position = UDim2.new(0, 15, 0, v50),
					onActivated = v54
				})
			}),
			contentSlot = React.createElement(View, {
				tag = "auto-y align-x-center col padding-bottom-large",
				Size = UDim2.new(1, 0, 1, -v44)
			}, {
				Contents = React.createElement(View, {
					tag = "align-x-center col padding-x-xlarge gap-xlarge padding-top-large padding-bottom-large",
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					ContentSections = React.createElement(React.Fragment, {}, v56)
				})
			})
		})
	})
end
local function AboutDetailsSheetFoundation(_) -- line: 159
	-- upvalues: useDispatch (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), NavigateBack (copy), useNavigationProps (copy), useLocalization (copy), TextKeys (copy), View (copy), OverlayProvider (copy), Sheet (copy), t1 (copy), FoundationText (copy)
	local v60 = useDispatch()
	local v61 = React.useCallback(function() -- line: 162
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v31 (copy), v60 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v31.back(true)

			return
		end

		v60(NavigateBack(true))
	end, { v60 })
	local v62 = useNavigationProps(function(_, p11) -- line: 170
		return {
			sections = p11.sections,
			profileName = p11.profileName
		}
	end)
	local v63 = v62.sections or {}
	local profileName = v62.profileName
	local v65, v66 = React.useState(nil)
	local v67 = useLocalization({
		about = TextKeys.About,
		aboutHeading = {
			TextKeys.AboutDetailsHeading,
			name = profileName or ""
		}
	})

	return React.createElement(View, {
		ref = v66,
		Size = UDim2.fromScale(1, 1)
	}, {
		Overlay = v65 and React.createElement(OverlayProvider, {
			gui = v65
		}, {
			AboutSheet = React.createElement(Sheet.Root, {
				isOpen = true,
				preferCenterSheet = true,
				defaultSnapPointIndex = 1,
				onClose = v61,
				snapPoints = t1
			}, {
				Header = React.createElement(Sheet.Header, {
					hasCloseAffordance = true
				}, {
					HeaderContent = React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = "size-full-0 auto-y text-heading-small text-align-x-left",
						Text = if not profileName then v67.about else v67.aboutHeading
					})
				}),
				Content = React.createElement(Sheet.Content, nil, {
					Contents = React.createElement(View, {
						tag = "col align-x-center gap-xlarge padding-bottom-large",
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						ContentSections = React.createElement(React.Fragment, {}, v63)
					})
				})
			})
		}) or nil
	})
end
local function AboutDetailsSheet(p12) -- line: 222
	-- upvalues: FFlagProfileAboutDetailsUseSheet (copy), AboutDetailsSheetFoundation (copy), AboutDetailsSheetLegacy (copy)
	if FFlagProfileAboutDetailsUseSheet then
		return AboutDetailsSheetFoundation(p12)
	end

	return AboutDetailsSheetLegacy(p12)
end

return AboutDetailsSheet
