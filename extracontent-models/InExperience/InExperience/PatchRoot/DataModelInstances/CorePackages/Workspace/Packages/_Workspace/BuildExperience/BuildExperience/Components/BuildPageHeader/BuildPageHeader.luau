local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local HeaderBar = require(BuildExperienceParent.UIBlox).App.Bar.HeaderBar
local IconButton = Foundation.IconButton
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local AgentSpecDebugSheet = require(BuildExperience.Components.AgentSpecDebug.AgentSpecDebugSheet)
local FlyoutSidePanelIXP = require(BuildExperienceParent.SharedExperimentDefinition).FlyoutSidePanelIXP
local FlyoutLeftHeader = require(BuildExperienceParent.FlyoutSidePanel).Components.FlyoutLeftHeader
local FFlagEnableHomeRobloxLogo = require(BuildExperienceParent.SharedFlags).FFlagEnableHomeRobloxLogo

local function renderFlyoutLeftHeader() -- line: 29
	-- upvalues: React (copy), FlyoutLeftHeader (copy), FFlagEnableHomeRobloxLogo (copy), FlyoutSidePanelIXP (copy)
	return React.createElement(FlyoutLeftHeader, {
		titleText = "Build",
		isRobloxLogoEnabled = false,
		isFlyoutEntrypointEnabled = if not FFlagEnableHomeRobloxLogo then nil else FlyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
		isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
	})
end
local function BuildPageHeader(t1: {[any]: any}) -- line: 40
	-- upvalues: FlyoutSidePanelIXP (copy), React (copy), CreatorAgentChat (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), InputSize (copy), View (copy), HeaderBar (copy), renderFlyoutLeftHeader (copy), AgentSpecDebugSheet (copy)
	local v19 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
	local v20, v21 = React.useState(false)
	local v22 = if not CreatorAgentChat.experimentOverride.isEnabled() then nil else function() -- line: 45
		-- upvalues: React (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), InputSize (copy), v21 (copy)
		return React.createElement(IconButton, {
			isCircular = true,
			icon = IconName.LabBeaker,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			onActivated = function() -- line: 51
				-- upvalues: v21 (copy)
				v21(true)
			end
		})
	end

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
			renderLeft = if not v19 then nil else renderFlyoutLeftHeader,
			title = not v19 and "Build" or nil,
			renderRight = v22
		}),
		AgentSpecSheet = if not v20 then nil else React.createElement(AgentSpecDebugSheet, {
			onClose = function() -- line: 76
				-- upvalues: v21 (copy)
				v21(false)
			end
		})
	})
end

return BuildPageHeader
