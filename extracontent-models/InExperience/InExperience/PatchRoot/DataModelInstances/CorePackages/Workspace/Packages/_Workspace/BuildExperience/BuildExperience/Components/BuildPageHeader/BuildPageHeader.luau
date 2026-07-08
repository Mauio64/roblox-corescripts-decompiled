local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local HeaderBar = require(Parent.UIBlox).App.Bar.HeaderBar
local View = Foundation.View
local FlyoutSidePanelIXP = require(Parent.SharedExperimentDefinition).FlyoutSidePanelIXP
local FlyoutLeftHeader = require(Parent.FlyoutSidePanel).Components.FlyoutLeftHeader
local FFlagEnableHomeRobloxLogo = require(Parent.SharedFlags).FFlagEnableHomeRobloxLogo

local function renderFlyoutLeftHeader() -- line: 22
	-- upvalues: React (copy), FlyoutLeftHeader (copy), FFlagEnableHomeRobloxLogo (copy), FlyoutSidePanelIXP (copy)
	return React.createElement(FlyoutLeftHeader, {
		titleText = "Build",
		isRobloxLogoEnabled = false,
		isFlyoutEntrypointEnabled = if not FFlagEnableHomeRobloxLogo then nil else FlyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
		isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
	})
end
local function BuildPageHeader(t1: {[any]: any}) -- line: 33
	-- upvalues: FlyoutSidePanelIXP (copy), React (copy), View (copy), HeaderBar (copy), renderFlyoutLeftHeader (copy)
	local v12 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()

	return React.createElement(View, {
		ZIndex = 3,
		tag = "composition-content-header size-full-0 auto-y",
		testId = "BuildPageHeader",
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, t1.height)
	}, {
		HeaderBar = React.createElement(HeaderBar, {
			isTitleCentered = false,
			barHeight = t1.height,
			paddingLeft = UDim.new(0, 0),
			paddingRight = UDim.new(0, 0),
			renderLeft = if not v12 then nil else renderFlyoutLeftHeader,
			title = not v12 and "Build" or nil
		})
	})
end

return BuildPageHeader
