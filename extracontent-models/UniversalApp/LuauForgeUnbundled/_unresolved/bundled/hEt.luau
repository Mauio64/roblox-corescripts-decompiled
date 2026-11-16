local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local module = require("@luauforge/bundled/dwA")

local module2 = require("@luauforge/bundled/fye")
local vrReadyWrapper = module2.VRReadyWrapper
local vrConstants = module2.VRConstants

local module3 = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local module6 = require("@luauforge/bundled/hEu")
local module7 = require("@luauforge/bundled/hEv")

local InputHandlers = require(CorePackages.Packages.InputHandlers)
local module8 = require("@luauforge/bundled/eeo")
local focusNavigableSurfaceWrapper = module8.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module8.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module8.FocusNavigationEventNameEnum

local module9 = require("@luauforge/bundled/dHC")

local flyoutScrollAwayControl = if module9 then require("@luauforge/bundled/fsS").FlyoutScrollAwayControl else nil

local fFlagUseSignalsForGlobalContextMenuInset = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForGlobalContextMenuInset

local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local v5 = if fFlagUseSignalsForGlobalContextMenuInset then require("@luauforge/bundled/hEw") else nil

local extended = module3.PureComponent:extend("ContextualListMenu")

extended.defaultProps = { menuWidth = module.DEFAULT_WIDE_CONTEXTUAL_MENU__WIDTH }

function extended:init()
	self.focusEventHandlers = {
		[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				local callbackCancel = self.props.callbackCancel

				if callbackCancel ~= nil then
					callbackCancel()
					object:cancel()
				end
			end)
		}
	}
end

function extended.render(p2)
	local v6 = p2.props[module3.Children] or {}
	local callbackCancel = p2.props.callbackCancel
	local formFactor2 = p2.props.formFactor
	local screenSize = p2.props.screenSize
	local globalContextMenuInset = p2.props.globalContextMenuInset
	local menuWidth = p2.props.menuWidth
	local screenShape = p2.props.screenShape

	local v7 = formFactor2 == formFactor.WIDE

	if screenSize.X <= 0 or screenSize.Y <= 0 then
		return nil
	end

	v6.Layout = module3.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local element = module3.createElement(
		FitChildren.FitFrame,
		{
			BackgroundTransparency = 1,
			fitAxis = FitChildren.FitAxis.Height,
			Size = UDim2.new(1, 0, 0, 0)
		},
		v6
	)
	local v8

	if v7 then
		v8 = module3.createElement(
			module6,
			{
				itemWidth = menuWidth,
				onCancel = callbackCancel,
				parentShape = screenShape
			},
			{ Content = element }
		)
	else
		v8 = module3.createElement(module7, { onCancel = callbackCancel }, {
			Content = element
		})
	end

	local element2 = module3.createElement(
		focusNavigableSurfaceWrapper,
		{
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
			isIsolated = true,
			customEventHandlers = p2.focusEventHandlers
		},
		{ MenuContents = v8 }
	)

	local safeAreaSize = getSafeAreaSize(screenSize, globalContextMenuInset)

	return withStyle(function(p3)
		return module3.createElement(module3.Portal, { target = CoreGui }, {
			PortalUI = module3.createElement(vrReadyWrapper, {
				component = "ScreenGui",
				props = {
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = module.DisplayOrder.ContextualListMenu
				},
				vrProps = {
					partSize = vrConstants.MainScreenSize,
					offset = CFrame.new(vrConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
					virtualScreenSize = vrConstants.MainScreenResolution,
					panelName = "ContextualListMenu",
					curvature = vrConstants.MainScreenCurvature
				}
			}, {
				Content = module3.createElement("Frame", {
					Position = UDim2.new(0, -globalContextMenuInset.left, 0, -globalContextMenuInset.top),
					Size = UDim2.new(0, screenSize.X, 0, screenSize.Y),
					BackgroundColor3 = p3.Theme.Overlay.Color,
					BackgroundTransparency = p3.Theme.Overlay.Transparency,
					BorderSizePixel = 0,
					Active = true
				}, {
					SafeAreaFrame = module3.createElement(
						"Frame",
						{
							Position = UDim2.new(
								0,
								globalContextMenuInset.left,
								0,
								globalContextMenuInset.top
							),
							Size = safeAreaSize,
							BackgroundTransparency = 1,
							ClipsDescendants = true
						},
						{ Content = element2 }
					)
				})
			})
		})
	end)
end

if module9 then
	function extended.didMount(p2)
		flyoutScrollAwayControl.setContextualMenuVisible(true)
	end

	function extended.willUnmount(p2)
		flyoutScrollAwayControl.setContextualMenuVisible(false)
	end
end

local v6 = useSheetNavigation.connect(function(data, p2)
	local v7 = {
		formFactor = data.FormFactor,
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset,
		globalContextMenuInset = 0
	}
	local v8 = if not fFlagUseSignalsForGlobalContextMenuInset then data.GlobalContextMenuInset else nil
	v7.globalContextMenuInset = v8
	return v7
end)(extended)

return fFlagUseSignalsForGlobalContextMenuInset and function(p2)
	local v7 = useSignalState(v5(false).getGlobalContextMenuInset)
	return module3.createElement(v6, Cryo.Dictionary.union(p2, {
		globalContextMenuInset = v7
	}))
end or v6
