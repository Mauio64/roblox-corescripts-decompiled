local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local Roact = require(Modules.Common.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(Modules.Common.RoactRodux)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v13 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local FitChildren = require(Modules.LuaApp.FitChildren)
local FramePopOut = require(Modules.LuaApp.Components.FramePopOut)
local FramePopup = require(Modules.LuaApp.Components.FramePopup)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local v19 = Roact.PureComponent:extend("FormBasedContextualMenu")

v19.defaultProps = {
	enablePopUpCancelButton = true
}

function v19.render(p1) -- line: 34
	-- upvalues: Roact (copy), FormFactor (copy), FramePopOut (copy), FramePopup (copy), FitChildren (copy)
	local anchorSpaceSize = p1.props.anchorSpaceSize
	local anchorSpacePosition = p1.props.anchorSpacePosition
	local itemWidth = p1.props.itemWidth
	local v26 = p1.props[Roact.Children]
	local screenSize = p1.props.screenSize
	local formFactor = p1.props.formFactor
	local closeContextualMenu = p1.props.closeContextualMenu
	local enablePopUpCancelButton = p1.props.enablePopUpCancelButton
	local v31 = formFactor == FormFactor.WIDE and FramePopOut or FramePopup

	return Roact.createElement(v31, {
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
	}, Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		Selectable = false,
		fitAxis = FitChildren.FitAxis.Height,
		Size = UDim2.new(0, itemWidth, 0, 0)
	}, v26))
end
function v19.didUpdate(p2, p3, _) -- line: 73
	local closeContextualMenu = p2.props.closeContextualMenu

	if p3.currentRoute ~= p2.props.currentRoute then
		closeContextualMenu()
	end
end

local v20 = RoactRodux.connect(function(p5, _) -- line: 81
	-- upvalues: FFlagSignalsNavP3hMisc (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	return {
		formFactor = p5.FormFactor,
		screenSize = p5.ScreenSize,
		currentRoute = if not FFlagSignalsNavP3hMisc then if not FFlagUseNavigationSelectors then p5.Navigation.history[#p5.Navigation.history] else Selectors.selectCurrentLegacyRoute(p5) else nil
	}
end, function(p7) -- line: 90
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeContextualMenu = function() -- line: 92
			-- upvalues: p7 (copy), CloseCentralOverlay (copy)
			p7(CloseCentralOverlay())
		end
	}
end)(v19)

if FFlagSignalsNavP3hMisc then
	local v21 = v20

	function v20(p8) -- line: 100
		-- upvalues: v13 (copy), useSignalState (copy), React (copy), v21 (copy), Cryo (copy)
		local v40 = v13(false)
		local v41 = useSignalState(v40.getCurrentLegacyRoute)

		return React.createElement(v21, Cryo.Dictionary.union(p8, {
			currentRoute = v41
		}))
	end
end

return v20
