local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Otter = require(CorePackages.Packages.Otter)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local useLayoutValues = PlayerList.Common.useLayoutValues
local Constants = PlayerList.Common.Constants
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Constants2 = require(Modules.TopBar.Constants)
local v18 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local SetPlayerListVisibility = require(ParentParent.Actions.SetPlayerListVisibility)
local SetIsUsingGamepad = require(ParentParent.Actions.SetIsUsingGamepad)
local PlayerListDisplayContainer = require(ParentParent.Components.Container.PlayerListDisplayContainer)
local PlayerDropDown = require(scriptParent.PlayerDropDown)
local Connection = ParentParent.Components.Connection
local EventConnections = require(Connection.EventConnections)
local ContextActionsBinder = require(Connection.ContextActionsBinder)
local TopStatConnector = require(Connection.TopStatConnector)
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local FFlagPlayerListFixMobileScrolling = require(ParentParent.Flags.FFlagPlayerListFixMobileScrolling)
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagPlayerListIgnoreDevGamepadBindings = PlayerList.Flags.FFlagPlayerListIgnoreDevGamepadBindings
local t1 = {
	dampingRatio = 1,
	frequency = 4
}

local function map(p1, p2, p3, p4, p5) -- line: 62
	return (p1 - p2) * (p5 - p4) / (p3 - p2) + p4
end

local v37 = Roact.PureComponent:extend("PlayerListApp")

local function playerListSizeFromViewportSize(p6, p7, p8, n1: number?, n2: number?) -- line: 68
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), v18 (copy), Constants2 (copy)
	local v53 = math.min(p7.x, p7.y)
	local v54 = math.max(p7.x, p7.y)
	local v55 = (v53 - 320) * 60 / 55 + 270
	local v56 = (v54 - 480) * 46 / 190 + 434
	local v57 = if not FFlagEnableMobilePlayerListOnConsole or not (v55 > 500) then math.clamp(v55, math.min(270, v53 - 24), 500) else n1
	local v58 = if not FFlagEnableMobilePlayerListOnConsole or not (v56 > 600) then math.clamp(v56, math.min(434, v54 - 24), 600) else n2
	local v59 = p7.x > p7.y and v58 or v57
	local v60 = p7.y > p7.x and v58 or v57

	if not FFlagEnableMobilePlayerListOnConsole then
		v59 *= p8
		v60 *= p8
	end

	if v18 and p7.y < p7.x then
		v60 -= Constants2.TopBarHeight * p6.state.UiScale - 24
	end

	return UDim2.fromOffset(v59, v60)
end
local function shouldShowNeutralTeam(p9) -- line: 114
	for _, v in ipairs(p9) do
		if v.Team == nil then
			return true
		end
	end

	return false
end
local function getTeamCount(p10, p11) -- line: 123
	local t2 = {}
	local n3 = 0
	local g73 = nil
	local v72 = nil

	for _, v in pairs(p10) do
		if not t2[v.TeamColor.Number] then
			t2[v.TeamColor.Number] = true
			n3 += 1
		end
	end

	if n3 > 0 then
		for _, v in ipairs(p11) do
			if v.Team == nil then
				v72 = true
				g73 = true
			end

			if g73 then
				break
			end
		end

		if not g73 then
			v72 = false
		end

		g73 = false

		if v72 then
			n3 += 1
		end
	end

	return n3
end

function v37.init(p12) -- line: 138
	-- upvalues: Signals (copy), Display (copy), Roact (copy), Otter (copy)
	p12.state = {
		visible = false
	}
	p12.disposeUiScaleEffect = Signals.createEffect(function(p13) -- line: 143
		-- upvalues: Display (copy), p12 (copy)
		local v107 = Display.GetDisplayStore(p13)

		p12:setState({
			UiScale = v107.getUIScale(p13)
		})
	end)

	local v75, v76 = Roact.createBinding(0.5)

	p12.bodyTransparency = v75
	p12.updateBodyTransparency = v76
	p12.bodyTransparencyMotor = Otter.createSingleMotor(1)
	p12.bodyTransparencyMotor:onStep(function(p14) -- line: 152
		-- upvalues: p12 (copy)
		p12.updateBodyTransparency(p14)
		p12.props.setLayerCollectorEnabled(p14 < 0.99 or p12.props.displayOptions.isVisible)
	end)
	p12.bodyTransparencyMotor:onComplete(function() -- line: 156
		-- upvalues: p12 (copy)
		if not p12.props.displayOptions.isVisible then
			p12:setState({
				visible = false
			})
		end
	end)

	local v77, v78 = Roact.createBinding(0)

	p12.bgTransparency = v77
	p12.updateBgTransparency = v78
	p12.bgTransparencyMotor = Otter.createSingleMotor(1)
	p12.bgTransparencyMotor:onStep(p12.updateBgTransparency)

	local v79, v80 = Roact.createBinding(1)

	p12.frameScale = v79
	p12.updateFrameScale = v80
	p12.frameScaleMotor = Otter.createSingleMotor(0)
	p12.frameScaleMotor:onStep(function(p15) -- line: 170
		-- upvalues: p12 (copy)
		p12.updateFrameScale(p15)
	end)
	p12.titleRef = Roact.createRef()
	p12.closeRef = Roact.createRef()
end
function v37.renderBodyChildren(p16, _, p18) -- line: 178
	-- upvalues: Roact (copy), AppFonts (copy), RobloxTranslator (copy)
	local visible = p16.state.visible
	local isDropDownVisible = p16.props.isDropDownVisible
	local Size_1100 = p16.props.tokens.Size.Size_1100
	local Size_500 = p16.props.tokens.Size.Size_500

	return {
		UIScale = Roact.createElement("UIScale", {
			Scale = p16.frameScale
		}),
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 6)
		}),
		TitleText = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, Size_1100),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Font = AppFonts.default:getBold(),
			Visible = visible and not isDropDownVisible,
			TextSize = p16.props.tokens.FontSize.FontSize_500,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Text = RobloxTranslator:FormatByKey("InGame.PlayerList.Leaderboard"),
			[Roact.Ref] = p16.titleRef
		}),
		CloseButton = Roact.createElement("ImageButton", {
			Image = "rbxasset://textures/ui/InspectMenu/x.png",
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(Size_500, Size_500),
			Position = UDim2.fromOffset(Size_500 / 2, Size_500),
			BackgroundTransparency = 1,
			Visible = visible and not isDropDownVisible,
			ZIndex = 0,
			[Roact.Ref] = p16.closeRef,
			[Roact.Event.Activated] = function() -- line: 219
				-- upvalues: p16 (copy)
				p16.props.setPlayerListVisible(false)
			end
		}),
		ContentFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AutoLocalize = false,
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.new(1, 0, 1, -Size_1100),
			Visible = visible and not isDropDownVisible
		}, p18)
	}
end
function v37.render(p19) -- line: 235
	-- upvalues: Roact (copy), ContextActionsBinder (copy), WithLayoutValues (copy), FFlagEnableMobilePlayerListOnConsole (copy), Players (copy), getTeamCount (copy), Constants2 (copy), PlayerListDisplayContainer (copy), FFlagAddNewPlayerListFocusNav (copy), EventConnections (copy), TopStatConnector (copy), FFlagPlayerListFixMobileScrolling (copy), PlayerDropDown (copy), v18 (copy), playerListSizeFromViewportSize (copy)
	if not p19.state.visible then
		return Roact.createElement(ContextActionsBinder)
	end

	return WithLayoutValues(function(p20) -- line: 239
		-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), p19 (copy), Players (copy), getTeamCount (copy), Constants2 (copy), Roact (copy), PlayerListDisplayContainer (copy), FFlagAddNewPlayerListFocusNav (copy), EventConnections (copy), ContextActionsBinder (copy), TopStatConnector (copy), FFlagPlayerListFixMobileScrolling (copy), PlayerDropDown (copy), v18 (copy), playerListSizeFromViewportSize (copy)
		if FFlagEnableMobilePlayerListOnConsole then
			p20 = p19.props.layoutValues
		end

		local EntrySizeX

		if p20.IsTenFoot then
			EntrySizeX = p20.EntrySizeX
		else
			EntrySizeX = p20.EntryBaseSizeX + 4 * p20.EntrySizeIncreasePerStat

			local v112 = p20.PlayerDropDownSizeXMobile + p20.PlayerDropDownOffset
			local v113 = p20.ContainerPadding * 2 + v112

			if EntrySizeX > p19.props.screenSizeX - v113 then
				EntrySizeX = p19.props.screenSizeX - v113
			end
		end

		local n4 = 1e999

		if Players.MaxPlayers >= 6 and Players.MaxPlayers <= 12 then
			n4 = Players.MaxPlayers * 26 + getTeamCount(p19.props.teams, p19.props.players) * 20
		end

		local v115 = Constants2.TopBarHeight * p19.state.UiScale
		local t3 = {}

		if p19.state.visible then
			t3.PlayerScrollList = Roact.createElement(PlayerListDisplayContainer, {
				screenSizeY = p19.props.screenSizeY,
				entrySize = EntrySizeX,
				isVisible = if not FFlagAddNewPlayerListFocusNav then nil else p19.props.displayOptions.isVisible
			})
		end

		t3.EventConnections = Roact.createElement(EventConnections)
		t3.ContextActionsBindings = Roact.createElement(ContextActionsBinder)
		t3.TopStatConnector = Roact.createElement(TopStatConnector)

		return Roact.createElement("ImageButton", {
			Active = p19.props.displayOptions.isVisible,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(17, 18, 20),
			BackgroundTransparency = p19.bgTransparency,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutoLocalize = false,
			AutoButtonColor = false,
			Selectable = not FFlagPlayerListFixMobileScrolling,
			Image = "",
			[Roact.Event.Activated] = function() -- line: 291
				-- upvalues: p19 (copy)
				p19.props.setPlayerListVisible(false)
			end
		}, {
			PlayerDropDown = Roact.createElement(PlayerDropDown, {
				contentsVisible = true,
				selectedPlayer = p19.props.dropDownPlayer
			}),
			BodyPadding = if not v18 or not (p19.props.screenSizeY < p19.props.screenSizeX) then nil else Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v115)
			}),
			BodyBackground = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = playerListSizeFromViewportSize(p19, Vector2.new(p19.props.screenSizeX, p19.props.screenSizeY), p19.state.UiScale, p20.PlayerListSizeMin, p20.PlayerListSizeMax),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundColor3 = Color3.fromRGB(17, 18, 20),
				BackgroundTransparency = p19.bodyTransparency,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			}, p19:renderBodyChildren(n4, t3))
		})
	end)
end
function v37.didMount(p21) -- line: 325
	p21.props.setLayerCollectorEnabled(false)
	p21:setState({
		visible = p21.props.displayOptions.isVisible
	})
end
function v37.willUnmount(p22) -- line: 332
	p22.props.setLayerCollectorEnabled(true)

	if p22.disposeUiScaleEffect then
		p22.disposeUiScaleEffect()
	end
end
function v37.didUpdate(p23, p24, _) -- line: 339
	-- upvalues: FFlagPlayerListIgnoreDevGamepadBindings (copy), GuiService (copy), Constants (copy), UserInputService (copy), Otter (copy), t1 (copy)
	local isVisible = p23.props.displayOptions.isVisible
	local isDropDownVisible = p23.props.isDropDownVisible

	if FFlagPlayerListIgnoreDevGamepadBindings and isVisible ~= p24.displayOptions.isVisible then
		GuiService:SetMenuIsOpen(isVisible, Constants.PLAYER_LIST_MENU)
	end

	if isVisible then
		p23:setState({
			visible = true
		})
	end

	if isVisible ~= p24.displayOptions.isVisible and isVisible then
		local v96 = UserInputService:GetLastInputType().Name:find("Gamepad") ~= nil

		p23.props.setIsUsingGamepad(v96)
	end

	local v97 = not isDropDownVisible and not isVisible and 1 or 0.7

	p23.bgTransparencyMotor:setGoal(Otter.spring(v97, t1))

	local v98 = isDropDownVisible and isVisible
	local n5 = 1.25

	if v98 then
		n5 = 0.95
	elseif isVisible then
		n5 = 1
	end

	p23.frameScaleMotor:setGoal(Otter.spring(n5, t1))

	local n6 = 1

	if v98 then
		n6 = 0.8 * p23.props.preferredTransparency
	elseif isVisible then
		n6 = 0.2 * p23.props.preferredTransparency
	end

	p23.bodyTransparencyMotor:setGoal(Otter.spring(n6, t1))
end

local function mapStateToProps(p26) -- line: 385
	return {
		isDropDownVisible = p26.playerDropDown.isVisible,
		screenSizeX = p26.screenSize.X,
		screenSizeY = p26.screenSize.Y,
		preferredTransparency = p26.settings.preferredTransparency,
		displayOptions = p26.displayOptions,
		players = p26.players,
		playerStats = p26.playerStats,
		playerIconInfo = p26.playerIconInfo,
		playerRelationship = p26.playerRelationship,
		gameStats = p26.gameStats,
		teams = p26.teams
	}
end
local function mapDispatchToProps(p27) -- line: 405
	-- upvalues: SetPlayerListVisibility (copy), SetIsUsingGamepad (copy)
	return {
		setPlayerListVisible = function(p28) -- line: 407
			-- upvalues: p27 (copy), SetPlayerListVisibility (copy)
			return p27(SetPlayerListVisibility(p28))
		end,
		setIsUsingGamepad = function(p29) -- line: 410
			-- upvalues: p27 (copy), SetIsUsingGamepad (copy)
			return p27(SetIsUsingGamepad(p29))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(function(p30) -- line: 416
	-- upvalues: FFlagEnableMobilePlayerListOnConsole (copy), useLayoutValues (copy), useTokens (copy), Roact (copy), v37 (copy), Cryo (copy)
	local v104 = if not FFlagEnableMobilePlayerListOnConsole then nil else useLayoutValues()
	local v105 = useTokens()

	return Roact.createElement(v37, Cryo.Dictionary.join(p30, {
		layoutValues = if not FFlagEnableMobilePlayerListOnConsole then nil else v104,
		tokens = v105
	}))
end)
