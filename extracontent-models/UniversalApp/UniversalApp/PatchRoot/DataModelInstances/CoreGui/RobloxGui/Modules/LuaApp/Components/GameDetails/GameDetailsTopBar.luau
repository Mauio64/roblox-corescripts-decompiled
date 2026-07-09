local CorePackages = game:GetService("CorePackages")
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3fGameDetails
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v9 = if not FFlagSignalsNavP3fGameDetails then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigateBack = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v13 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.LuaApp.Constants)
local Images = UIBlox.App.ImageSet.Images
local v21 = Roact.PureComponent:extend("GameDetailsTopBar")
local v22 = game:DefineFastFlag("GameDetailsTopBarInputSinkFix", false)

local function getNumberOfGameDetailsPages(p1) -- line: 43
	-- upvalues: AppPage (copy)
	local v28 = p1[#p1]
	local n1 = 0

	for i = 1, #v28 do
		if v28[i].name == AppPage.GameDetail then
			n1 += 1

			if n1 > 1 then
				return n1
			end
		end
	end

	return n1
end

function v21.init(p2) -- line: 60
	-- upvalues: getNumberOfGameDetailsPages (copy)
	function p2.onNavigationButtonActivated() -- line: 61
		-- upvalues: p2 (copy), getNumberOfGameDetailsPages (copy)
		if p2.isMounted then
			if getNumberOfGameDetailsPages(p2.props.history) <= 1 and p2.props.onCloseButtonActivated ~= nil then
				p2.props.onCloseButtonActivated({
					backButtonNavigation = true
				})

				return
			end

			p2.props.navigateBack()
		end
	end
	function p2.onCloseButtonActivated() -- line: 71
		-- upvalues: p2 (copy)
		if p2.isMounted and p2.props.onCloseButtonActivated ~= nil then
			p2.props.onCloseButtonActivated()
		end
	end
end
function v21.didMount(p3) -- line: 78
	p3.isMounted = true
end
function v21.willUnmount(p4) -- line: 82
	p4.isMounted = false
end
function v21.render(p5) -- line: 86
	-- upvalues: Constants (copy), Roact (copy), withStyle (copy), v22 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ImageSetLabel (copy), Images (copy)
	local statusBarHeight = p5.props.statusBarHeight
	local v36 = statusBarHeight + Constants.NAV_BAR_SIZE
	local showCloseIcon = p5.props.showCloseIcon
	local v38 = p5.props.transitionPercentBinding or Roact.createBinding(1)

	return withStyle(function(p6) -- line: 96
		-- upvalues: Roact (copy), v36 (copy), v22 (copy), statusBarHeight (copy), v38 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), p5 (copy), showCloseIcon (copy), ImageSetLabel (copy), Images (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, v36),
			Active = not not v22
		}, {
			LeftNavigationButton = Roact.createElement("TextButton", {
				Position = UDim2.new(0, 15, 0, statusBarHeight),
				Size = UDim2.new(0, 40, 0, 40),
				BorderSizePixel = 0,
				BackgroundTransparency = v38:map(function(p7) -- line: 108
					return 1 - p7 + 0.3
				end),
				BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p6.Tokens.Semantic.Color.Background.Default else p6.Tokens.Color.Surface.Surface_0)).Color3,
				Text = "",
				[Roact.Event.Activated] = p5.onNavigationButtonActivated
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				LeftCloseButton = showCloseIcon and Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 24, 0, 24),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Images["icons/navigation/close"],
					ImageColor3 = p6.Theme.IconEmphasis.Color,
					ImageTransparency = v38:map(function(p8) -- line: 127
						return 1 - p8
					end)
				}) or nil,
				LeftNavigationButton = not showCloseIcon and Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 30, 0, 30),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Images["icons/actions/cycleLeft"],
					ImageColor3 = p6.Theme.SystemPrimaryDefault.Color,
					ImageTransparency = v38:map(function(p9) -- line: 138
						return 1 - p9
					end)
				}) or nil
			})
		})
	end)
end

local function selectShowCloseIcon(p10) -- line: 148
	-- upvalues: getNumberOfGameDetailsPages (copy)
	return getNumberOfGameDetailsPages(p10) <= 1
end

local v25 = RoactRodux.connect(function(p11, p12) -- line: 155
	-- upvalues: FFlagSignalsNavP3fGameDetails (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), getNumberOfGameDetailsPages (copy)
	local v42 = nil
	local v43 = nil

	if not FFlagSignalsNavP3fGameDetails then
		v42 = if not FFlagUseNavigationSelectors then p11.Navigation.history else Selectors.selectLegacyHistory(p11)
		v43 = getNumberOfGameDetailsPages(v42) <= 1

		if p12.showCloseIcon ~= nil then
			v43 = p12.showCloseIcon
		end
	end

	return {
		statusBarHeight = p11.TopBar.statusBarHeight,
		showCloseIcon = v43,
		history = v42
	}
end, function(p13) -- line: 176
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateBack (copy)
	return {
		navigateBack = function() -- line: 178
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v13 (copy), p13 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v13.back()
			end

			return p13(NavigateBack())
		end
	}
end)(v21)

if FFlagSignalsNavP3fGameDetails then
	local v26 = v25

	function v25(p14) -- line: 190
		-- upvalues: v9 (copy), useSignalState (copy), getNumberOfGameDetailsPages (copy), Roact (copy), v26 (copy), Cryo (copy)
		local v46 = v9(false)
		local v47 = useSignalState(v46.getHistory)
		local v48 = getNumberOfGameDetailsPages(v47) <= 1

		if p14.showCloseIcon ~= nil then
			v48 = p14.showCloseIcon
		end

		return Roact.createElement(v26, Cryo.Dictionary.union(p14, {
			history = v47,
			showCloseIcon = v48
		}))
	end
end

return v25
