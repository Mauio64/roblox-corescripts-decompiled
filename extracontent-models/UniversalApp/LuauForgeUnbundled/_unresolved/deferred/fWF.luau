local CorePackages = game:GetService("CorePackages")
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local module = require("@luauforge/bundled/dwA")

local images = UIBlox.App.ImageSet.Images

local extended = Roact.PureComponent:extend("GameDetailsTopBar")

local defineFastFlag = game:DefineFastFlag("GameDetailsTopBarInputSinkFix", false)

local function getNumberOfGameDetailsPages(list)
	local item = list[#list]
	local count = 0

	for i = 1, #item do
		if item[i].name ~= appPage.GameDetail then
			continue
		end

		count += 1

		if count > 1 then
			break
		end
	end

	return count
end

function extended:init()
	function self.onNavigationButtonActivated()
		if self.isMounted then
			local v5

			if fFlagSignalsNavP3fGameDetails then
				v5 = getLegacyNavigationStore(false).getHistory(false)
			else
				v5 = self.props.history
			end

			if getNumberOfGameDetailsPages(v5) <= 1 and self.props.onCloseButtonActivated ~= nil then
				self.props.onCloseButtonActivated({ backButtonNavigation = true })
			else
				self.props.navigateBack()
			end
		end
	end

	function self.onCloseButtonActivated()
		if self.isMounted and self.props.onCloseButtonActivated ~= nil then
			self.props.onCloseButtonActivated()
		end
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(p2)
	local statusBarHeight = p2.props.statusBarHeight
	local v5 = statusBarHeight + module.NAV_BAR_SIZE
	local showCloseIcon = p2.props.showCloseIcon

	local transitionPercentBinding = p2.props.transitionPercentBinding or Roact.createBinding(1)

	return withStyle(function(p3)
		local createElement = Roact.createElement
		local v7 = {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, v5),
			BackgroundTransparency = 1,
			Active = defineFastFlag and true or false,
			BorderSizePixel = 0
		}

		local createElement2 = Roact.createElement
		local v10 = {
			["Position"] = UDim2.new(0, 15, 0, statusBarHeight),
			Size = UDim2.new(0, 40, 0, 40),
			BorderSizePixel = 0,
			BackgroundTransparency = transitionPercentBinding:map(function(p4)
				return 1 - p4 + 0.3
			end),
			BackgroundColor3 = p3.Tokens.Color.Surface.Surface_0.Color3,
			Text = ""
		}

		local tag = React.Tag
		local v11 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-back") else nil
		v10[tag] = v11
		v10[Roact.Event.Activated] = p2.onNavigationButtonActivated
		local v12 = {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			LeftCloseButton = 0,
			LeftNavigationButton = 0
		}
		local v13

		if showCloseIcon then
			v13 = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = images["icons/navigation/close"],
				ImageColor3 = p3.Theme.IconEmphasis.Color,
				ImageTransparency = transitionPercentBinding:map(function(p4)
					return 1 - p4
				end),
				BackgroundTransparency = 1
			}) or nil
		end

		v12.LeftCloseButton = v13
		local v14

		if not showCloseIcon then
			v14 = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(0, 30, 0, 30),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = images["icons/actions/cycleLeft"],
				ImageColor3 = p3.Theme.SystemPrimaryDefault.Color,
				ImageTransparency = transitionPercentBinding:map(function(p4)
					return 1 - p4
				end),
				BackgroundTransparency = 1
			}) or nil
		end

		v12.LeftNavigationButton = v14
		return createElement("Frame", v7, {
			LeftNavigationButton = createElement2("TextButton", v10, v12)
		})
	end)
end

local function selectShowCloseIcon(p2): boolean
	return getNumberOfGameDetailsPages(p2) <= 1
end

local v5 = RoactRodux.connect(function(p2, p3)
	local v6, v7

	if not fFlagSignalsNavP3fGameDetails then
		if fFlagUseNavigationSelectors then
			v7 = selectors.selectLegacyHistory(p2)
		else
			v7 = p2.Navigation.history
		end

		v6 = getNumberOfGameDetailsPages(v7) <= 1

		if p3.showCloseIcon ~= nil then
			v6 = p3.showCloseIcon
		end
	end

	return {
		statusBarHeight = p2.TopBar.statusBarHeight,
		showCloseIcon = v6,
		history = v7
	}
end, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(navigateBack())
		end
	}
end)(extended)

return fFlagSignalsNavP3fGameDetails and function(p2)
	local legacyNavigationStore = getLegacyNavigationStore(false)

	local v7 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p3): boolean
			return getNumberOfGameDetailsPages(legacyNavigationStore.getHistory(p3)) <= 1
		end)
	end, { legacyNavigationStore })))

	if p2.showCloseIcon ~= nil then
		v7 = p2.showCloseIcon
	end

	return Roact.createElement(v5, Cryo.Dictionary.union(p2, { showCloseIcon = v7 }))
end or v5
