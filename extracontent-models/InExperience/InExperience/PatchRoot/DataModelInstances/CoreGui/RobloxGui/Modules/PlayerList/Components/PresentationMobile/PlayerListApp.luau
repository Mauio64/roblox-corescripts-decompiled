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
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local useLayoutValues = PlayerList.Common.useLayoutValues
local Constants = PlayerList.Common.Constants

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Constants2 = require(Modules.TopBar.Constants)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local parent = script.Parent
local parent2 = parent.Parent.Parent

local SetPlayerListVisibility = require(parent2.Actions.SetPlayerListVisibility)
local SetIsUsingGamepad = require(parent2.Actions.SetIsUsingGamepad)

local PlayerListDisplayContainer = require(parent2.Components.Container.PlayerListDisplayContainer)
local PlayerDropDown = require(parent.PlayerDropDown)

local connection = parent2.Components.Connection
local EventConnections = require(connection.EventConnections)
local ContextActionsBinder = require(connection.ContextActionsBinder)
local TopStatConnector = require(connection.TopStatConnector)
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local FFlagPlayerListFixMobileScrolling = require(parent2.Flags.FFlagPlayerListFixMobileScrolling)
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagPlayerListIgnoreDevGamepadBindings = PlayerList.Flags.FFlagPlayerListIgnoreDevGamepadBindings
local FFlagPlayerListRemoveTopStat = require(parent2.Flags.FFlagPlayerListRemoveTopStat)

local v = { dampingRatio = 1, frequency = 4 }

local function map(p, p2, p3, p4, p5) -- 2 equivalent calls inferred from this helper
	return (p - p2) * (p5 - p4) / (p3 - p2) + p4
end

local extended = Roact.PureComponent:extend("PlayerListApp")

local function playerListSizeFromViewportSize(props, vector2, uiScale, playerListSizeMin: number?, playerListSizeMax: number?)
	local v2 = math.min(vector2.x, vector2.y)
	local v3 = math.max(vector2.x, vector2.y)
	local v4 = map(v2, 320, 375, 270, 330) -- inferred equivalent call
	local v5 = map(v3, 480, 670, 434, 480) -- inferred equivalent call

	if not (FFlagEnableMobilePlayerListOnConsole and v4 > 500) then
		playerListSizeMin = math.clamp(v4, math.min(270, v2 - 24), 500)
	end

	if not (FFlagEnableMobilePlayerListOnConsole and v5 > 600) then
		playerListSizeMax = math.clamp(v5, math.min(434, v3 - 24), 600)
	end

	local v6 = vector2.x > vector2.y and playerListSizeMax or playerListSizeMin
	playerListSizeMin = vector2.y > vector2.x and playerListSizeMax or playerListSizeMin

	if not FFlagEnableMobilePlayerListOnConsole then
		v6 *= uiScale
		playerListSizeMin *= uiScale
	end

	if enabled and vector2.y < vector2.x then
		playerListSizeMin -= Constants2.TopBarHeight * props.state.UiScale - 24
	end

	return UDim2.fromOffset(v6, playerListSizeMin)
end

local function shouldShowNeutralTeam(list): boolean -- 1 equivalent call inferred from this helper
	for _, item in ipairs(list) do
		if item.Team == nil then
			return true
		end
	end

	return false
end

local function getTeamCount(teams, players)
	local numberSet = {}
	local count = 0

	for _, item in pairs(teams) do
		if numberSet[item.TeamColor.Number] then
			continue
		end

		numberSet[item.TeamColor.Number] = true
		count += 1
	end

	if count > 0 and shouldShowNeutralTeam(players) then -- inferred equivalent call
		count += 1
	end

	return count
end

function extended:init()
	self.state = { visible = false }

	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)

	local binding, updateBodyTransparency = Roact.createBinding(0.5)
	self.bodyTransparency = binding
	self.updateBodyTransparency = updateBodyTransparency
	self.bodyTransparencyMotor = Otter.createSingleMotor(1)
	self.bodyTransparencyMotor:onStep(function(p)
		self.updateBodyTransparency(p)
		self.props.setLayerCollectorEnabled(p < 0.99 or self.props.displayOptions.isVisible)
	end)
	self.bodyTransparencyMotor:onComplete(function()
		if not self.props.displayOptions.isVisible then
			self:setState({ visible = false })
		end
	end)

	local binding2, updateBgTransparency = Roact.createBinding(0)
	self.bgTransparency = binding2
	self.updateBgTransparency = updateBgTransparency
	self.bgTransparencyMotor = Otter.createSingleMotor(1)
	self.bgTransparencyMotor:onStep(self.updateBgTransparency)

	local binding3, updateFrameScale = Roact.createBinding(1)
	self.frameScale = binding3
	self.updateFrameScale = updateFrameScale
	self.frameScaleMotor = Otter.createSingleMotor(0)
	self.frameScaleMotor:onStep(function(p)
		self.updateFrameScale(p)
	end)

	self.titleRef = Roact.createRef()
	self.closeRef = Roact.createRef()
end

function extended:renderBodyChildren(_, p)
	local visible = self.state.visible
	local isDropDownVisible = self.props.isDropDownVisible

	local size_1100 = self.props.tokens.Size.Size_1100
	local size_500 = self.props.tokens.Size.Size_500

	return {
		UIScale = Roact.createElement("UIScale", { Scale = self.frameScale }),
		UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 6) }),
		TitleText = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, size_1100),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Font = AppFonts.default:getBold(),
			Visible = visible and not isDropDownVisible,
			TextSize = self.props.tokens.FontSize.FontSize_500,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Text = RobloxTranslator:FormatByKey("InGame.PlayerList.Leaderboard"),
			[Roact.Ref] = self.titleRef
		}),
		CloseButton = Roact.createElement("ImageButton", {
			Image = "rbxasset://textures/ui/InspectMenu/x.png",
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(size_500, size_500),
			Position = UDim2.fromOffset(size_500 / 2, size_500),
			BackgroundTransparency = 1,
			Visible = visible and not isDropDownVisible,
			ZIndex = 0,
			[Roact.Ref] = self.closeRef,
			[Roact.Event.Activated] = function()
				self.props.setPlayerListVisible(false)
			end
		}),
		ContentFrame = Roact.createElement("Frame", {
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			Size = UDim2.new(1, 0, 1, -size_1100),
			BackgroundTransparency = 1,
			Visible = visible and not isDropDownVisible,
			AutoLocalize = false
		}, p)
	}
end

function extended:render()
	if self.state.visible then
		return WithLayoutValues(function(props)
			if FFlagEnableMobilePlayerListOnConsole then
				props = self.props.layoutValues
			end

			local entrySize

			if props.IsTenFoot then
				entrySize = props.EntrySizeX
			else
				entrySize = props.EntryBaseSizeX + 4 * props.EntrySizeIncreasePerStat

				local v2 = props.PlayerDropDownSizeXMobile + props.PlayerDropDownOffset
				local v3 = props.ContainerPadding * 2 + v2

				if self.props.screenSizeX - v3 < entrySize then
					entrySize = self.props.screenSizeX - v3
				end
			end

			local v2 = 1e999
			local v3

			if Players.MaxPlayers >= 6 then
				v3 = Players.MaxPlayers <= 12
			else
				v3 = false
			end

			if v3 then
				v2 = Players.MaxPlayers * 26 + getTeamCount(self.props.teams, self.props.players) * 20
			end

			local v4 = Constants2.TopBarHeight * self.state.UiScale

			local children = {}

			if self.state.visible then
				local createElement = Roact.createElement
				local v5 = {
					screenSizeY = self.props.screenSizeY,
					entrySize = entrySize,
					isVisible = 0
				}
				local isVisible

				if FFlagAddNewPlayerListFocusNav then
					isVisible = self.props.displayOptions.isVisible
				end

				v5.isVisible = isVisible
				children.PlayerScrollList = createElement(PlayerListDisplayContainer, v5)
			end

			children.EventConnections = Roact.createElement(EventConnections)
			children.ContextActionsBindings = Roact.createElement(ContextActionsBinder)

			if not FFlagPlayerListRemoveTopStat then
				children.TopStatConnector = Roact.createElement(TopStatConnector)
			end

			local createElement = Roact.createElement
			local v5 = {
				Active = self.props.displayOptions.isVisible,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = Color3.fromRGB(17, 18, 20),
				BackgroundTransparency = self.bgTransparency,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				AutoLocalize = false,
				AutoButtonColor = false,
				Selectable = not FFlagPlayerListFixMobileScrolling,
				Image = "",
				[Roact.Event.Activated] = function()
					self.props.setPlayerListVisible(false)
				end
			}
			local v6 = {
				PlayerDropDown = Roact.createElement(PlayerDropDown, {
					contentsVisible = true,
					selectedPlayer = self.props.dropDownPlayer
				}),
				BodyPadding = 0,
				BodyBackground = 0
			}
			local bodyPadding

			if enabled and self.props.screenSizeY < self.props.screenSizeX then
				bodyPadding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, v4) })
			end

			v6.BodyPadding = bodyPadding

			v6.BodyBackground = Roact.createElement("Frame", {
				Size = playerListSizeFromViewportSize(
					self,
					Vector2.new(self.props.screenSizeX, self.props.screenSizeY),
					self.state.UiScale,
					props.PlayerListSizeMin,
					props.PlayerListSizeMax
				),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundColor3 = Color3.fromRGB(17, 18, 20),
				BackgroundTransparency = self.bodyTransparency,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0
			}, self:renderBodyChildren(v2, children))
			return createElement("ImageButton", v5, v6)
		end)
	end

	return Roact.createElement(ContextActionsBinder)
end

function extended.didMount(object)
	object.props.setLayerCollectorEnabled(false)
	object:setState({ visible = object.props.displayOptions.isVisible })
end

function extended.willUnmount(p)
	p.props.setLayerCollectorEnabled(true)

	if p.disposeUiScaleEffect then
		p.disposeUiScaleEffect()
	end
end

function extended.didUpdate(object, p, _)
	local isVisible = object.props.displayOptions.isVisible
	local isDropDownVisible = object.props.isDropDownVisible

	if FFlagPlayerListIgnoreDevGamepadBindings and isVisible ~= p.displayOptions.isVisible then
		GuiService:SetMenuIsOpen(isVisible, Constants.PLAYER_LIST_MENU)
	end

	if isVisible then
		object:setState({ visible = true })
	end

	if isVisible ~= p.displayOptions.isVisible and isVisible then
		local v2 = UserInputService:GetLastInputType().Name:find("Gamepad") ~= nil

		object.props.setIsUsingGamepad(v2)
	end

	object.bgTransparencyMotor:setGoal(Otter.spring((isDropDownVisible or isVisible) and 0.7 or 1, v))

	local v2 = isDropDownVisible and isVisible

	object.frameScaleMotor:setGoal(Otter.spring(v2 and 0.95 or isVisible and 1 or 1.25, v))

	local v3 = 1

	if v2 then
		v3 = 0.8 * object.props.preferredTransparency
	elseif isVisible then
		v3 = 0.2 * object.props.preferredTransparency
	end

	object.bodyTransparencyMotor:setGoal(Otter.spring(v3, v))
end

local function mapStateToProps(data)
	return {
		isDropDownVisible = data.playerDropDown.isVisible,
		screenSizeX = data.screenSize.X,
		screenSizeY = data.screenSize.Y,
		preferredTransparency = data.settings.preferredTransparency,
		displayOptions = data.displayOptions,
		players = data.players,
		playerStats = data.playerStats,
		playerIconInfo = data.playerIconInfo,
		playerRelationship = data.playerRelationship,
		gameStats = data.gameStats,
		teams = data.teams
	}
end

local function mapDispatchToProps(callback)
	return {
		setPlayerListVisible = function(p)
			return callback(SetPlayerListVisibility(p))
		end,
		setIsUsingGamepad = function(p)
			return callback(SetIsUsingGamepad(p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(function(p)
	local layoutValues

	if FFlagEnableMobilePlayerListOnConsole then
		layoutValues = useLayoutValues()
	end

	local tokens = useTokens()

	local createElement = Roact.createElement
	local join = Cryo.Dictionary.join

	if not FFlagEnableMobilePlayerListOnConsole then
		layoutValues = nil
	end

	return createElement(extended, join(p, { layoutValues = layoutValues, tokens = tokens }))
end)
