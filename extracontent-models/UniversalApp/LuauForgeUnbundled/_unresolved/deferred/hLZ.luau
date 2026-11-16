local CorePackages = game:GetService("CorePackages")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module2 = require("@luauforge/bundled/ecR")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local module5 = require("@luauforge/bundled/hEu")
local module6 = require("@luauforge/bundled/hEv")

local module7 = require("@luauforge/bundled/fvl")

local extended = module2.PureComponent:extend("FormBasedContextualMenu")

extended.defaultProps = { enablePopUpCancelButton = true }

function extended.render(p2)
	local anchorSpaceSize = p2.props.anchorSpaceSize
	local anchorSpacePosition = p2.props.anchorSpacePosition
	local itemWidth = p2.props.itemWidth
	local v5 = p2.props[module2.Children]

	local screenSize = p2.props.screenSize
	local formFactor2 = p2.props.formFactor
	local closeContextualMenu = p2.props.closeContextualMenu

	local enablePopUpCancelButton = p2.props.enablePopUpCancelButton

	local v6 = formFactor2 == formFactor.WIDE and module5 or module6

	return module2.createElement(v6, {
		onCancel = closeContextualMenu,
		enableCancelButton = enablePopUpCancelButton,
		itemWidth = itemWidth,
		parentShape = {
			x = anchorSpacePosition.X,
			y = anchorSpacePosition.Y,
			width = anchorSpaceSize.X,
			height = anchorSpaceSize.Y,
			parentWidth = screenSize.X,
			parentHeight = screenSize.Y
		}
	}, module2.createElement(
		FitChildren.FitFrame,
		{
			BackgroundTransparency = 1,
			fitAxis = FitChildren.FitAxis.Height,
			Size = UDim2.new(0, itemWidth, 0, 0),
			Selectable = false
		},
		v5
	))
end

function extended.didUpdate(p2, p3, p4)
	local closeContextualMenu = p2.props.closeContextualMenu

	if fFlagSignalsNavP3dRouteGated then
		if p3.currentRouteKey ~= p2.props.currentRouteKey then
			closeContextualMenu()
		end
	elseif p3.currentRoute ~= p2.props.currentRoute then
		closeContextualMenu()
	end
end

local v5 = useSheetNavigation.connect(function(data, p2)
	local v6 = {
		formFactor = data.FormFactor,
		screenSize = data.ScreenSize,
		currentRoute = 0
	}
	local v7

	if not fFlagSignalsNavP3dRouteGated then
		if fFlagUseNavigationSelectors then
			v7 = selectors.selectCurrentLegacyRoute(data)
		else
			v7 = data.Navigation.history[#data.Navigation.history]
		end
	end

	v6.currentRoute = v7
	return v6
end, function(callback)
	return {
		closeContextualMenu = function()
			callback(module7())
		end
	}
end)(extended)
local v6

if fFlagSignalsNavP3dRouteGated then
	v6 = React.memo(function(p2)
		local v7 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
		return React.createElement(v5, Cryo.Dictionary.union(p2, {
			currentRouteKey = v7
		}))
	end)
else
	v6 = v5
end

return v6
