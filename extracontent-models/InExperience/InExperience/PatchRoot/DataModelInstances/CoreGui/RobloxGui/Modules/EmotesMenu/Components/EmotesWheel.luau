local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local VRService = game:GetService("VRService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService

local parent = script.Parent
local parent2 = parent.Parent

local actions = parent2.Actions
local thunks = parent2.Thunks
local utility = parent2.Utility

local Constants = require(parent2.Constants)

local GetSegmentFromPosition = require(utility.GetSegmentFromPosition)

local EmotesButtons = require(parent.EmotesButtons)
local SlotNumbers = require(parent.SlotNumbers)
local WheelBackground = require(parent.WheelBackground)

local FocusSegment = require(actions.FocusSegment)
local HideMenu = require(actions.HideMenu)
local PlayEmote = require(thunks.PlayEmote)

local value = Enum.ContextActionPriority.High.Value

local extended = Roact.PureComponent:extend("EmotesWheel")

local function getRandomAssetId(list) -- 2 equivalent calls inferred from this helper
	if #list == 0 then
		return
	end

	return list[math.random(1, #list)]
end

function extended:bindActions()
	if self.actionsBound then
		return
	end

	local function selectEmote(_, _, p)
		local vector2 = Vector2.new(p.Position.X, p.Position.Y)

		if vector2.Magnitude < Constants.ThumbstickThreshold then
			return
		end

		local segmentFromPosition = GetSegmentFromPosition(vector2)

		if segmentFromPosition == self.props.emotesWheel.focusedSegmentIndex then
			return
		end

		if self.props.emotesPage.currentEmotes[segmentFromPosition] then
			self.props.focusSegment(segmentFromPosition)
		else
			self.props.focusSegment(0)
		end
	end

	ContextActionService:BindActionAtPriority(
		Constants.EmoteSelectionAction,
		selectEmote,
		false,
		value,
		Constants.SelectionThumbstick
	)

	local function playSelected(_, p, _)
		if p == Enum.UserInputState.Begin then
			local focusedSegmentIndex = self.props.emotesWheel.focusedSegmentIndex
			local currentEmote = self.props.emotesPage.currentEmotes[focusedSegmentIndex]

			if not currentEmote then
				return
			end

			local v = self.props.emotesPage.emotesInfo[currentEmote]

			if not v then
				return
			end

			local randomAssetId = getRandomAssetId(v) -- inferred equivalent call
			self.props.playEmote(currentEmote, focusedSegmentIndex, randomAssetId)
		end
	end

	ContextActionService:BindActionAtPriority(
		Constants.PlaySelectedAction,
		playSelected,
		false,
		value,
		Constants.PlayEmoteButton
	)

	local function closeMenu(_, p, _) -- 1 equivalent call inferred from this helper
		if p == Enum.UserInputState.Begin then
			self.props.hideMenu()
		end
	end

	local v = { Constants.EmoteMenuCloseKey, Constants.EmoteMenuCloseButton, Constants.EmoteMenuCloseButtonSecondary }

	ContextActionService:BindActionAtPriority(Constants.CloseMenuAction, closeMenu, false, value, unpack(v))

	local function closeMenuNoSink(_, p, _)
		closeMenu(nil, p) -- inferred equivalent call
		return Enum.ContextActionResult.Pass
	end

	ContextActionService:BindActionAtPriority(
		Constants.LeaveMenuDontSinkInputAction,
		closeMenuNoSink,
		false,
		value,
		unpack(Constants.LeaveMenuNoSinkInputs)
	)

	local function activateEmoteByNumber(_, p, p2)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		local v2 = nil

		for i, emoteSlotKey in ipairs(Constants.EmoteSlotKeys) do
			if emoteSlotKey == p2.KeyCode then
				v2 = i
				break
			end
		end

		if not v2 then
			return
		end

		local currentEmote = self.props.emotesPage.currentEmotes[v2]

		if not currentEmote then
			return
		end

		local v3 = self.props.emotesPage.emotesInfo[currentEmote]

		if not v3 then
			return
		end

		local randomAssetId = getRandomAssetId(v3) -- inferred equivalent call
		self.props.playEmote(currentEmote, v2, randomAssetId)
	end

	ContextActionService:BindActionAtPriority(
		Constants.ActivateEmoteSlotAction,
		activateEmoteByNumber,
		false,
		value,
		unpack(Constants.EmoteSlotKeys)
	)

	local function sinkInput(_, _, _)
		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreActionAtPriority(
		Constants.VirtualCursorSinkAction,
		sinkInput,
		false,
		value,
		Enum.KeyCode.ButtonSelect
	)

	self.actionsBound = true
end

function extended:unbindActions()
	if self.actionsBound then
		ContextActionService:UnbindAction(Constants.CloseMenuAction)
		ContextActionService:UnbindAction(Constants.EmoteSelectionAction)
		ContextActionService:UnbindAction(Constants.PlaySelectedAction)
		ContextActionService:UnbindAction(Constants.LeaveMenuDontSinkInputAction)
		ContextActionService:UnbindAction(Constants.ActivateEmoteSlotAction)
		ContextActionService:UnbindCoreAction(Constants.VirtualCursorSinkAction)

		self.actionsBound = false
	end
end

function extended:addCursorOverride()
	if VRService.VREnabled then
		return
	end

	if self.isUsingGamepad and not self.isCursorHidden then
		MouseIconOverrideService.push(Constants.CursorOverrideName, Enum.OverrideMouseIconBehavior.ForceHide)

		GamepadService.GamepadCursorEnabled = false
		self.isCursorHidden = true
	end
end

function extended:removeCursorOverride()
	if self.isCursorHidden then
		MouseIconOverrideService.pop(Constants.CursorOverrideName)

		self.isCursorHidden = false
	end
end

function extended:connectListeners()
	self.inputTypeChangedListener = UserInputService.LastInputTypeChanged:Connect(function(p)
		if Constants.GamepadInputTypes[p] then
			self.isUsingGamepad = true

			if self.props.displayOptions.menuVisible then
				self:addCursorOverride()
			end
		else
			self.isUsingGamepad = false

			self:removeCursorOverride()
		end
	end)
end

function extended:disconnectListeners()
	self.inputTypeChangedListener:Disconnect()
end

function extended:didUpdate()
	if self.props.displayOptions.menuVisible then
		self:bindActions()

		self:addCursorOverride()
	else
		self:unbindActions()

		self:removeCursorOverride()
	end
end

function extended:didMount()
	if self.props.displayOptions.menuVisible then
		self:bindActions()
	end

	self:connectListeners()
end

function extended:willUnmount()
	self:unbindActions()

	self:disconnectListeners()
end

function extended.render(p)
	return Roact.createElement(
		"Frame",
		{
			Active = true,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = p.props.displayOptions.menuVisible
		},
		{
			MouseUnlock = Roact.createElement("TextButton", {
				Modal = true,
				Size = UDim2.new(0, 0, 0, 0),
				Text = "",
				Transparency = 1
			}),
			Back = Roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 1 },
				{
					Background = Roact.createElement(WheelBackground)
				}
			),
			Front = Roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 2 },
				{
					EmotesButtons = Roact.createElement(EmotesButtons),
					SlotNumbers = Roact.createElement(SlotNumbers)
				}
			)
		}
	)
end

local function mapStateToProps(data)
	return {
		displayOptions = data.displayOptions,
		emotesWheel = data.emotesWheel,
		emotesPage = data.emotesPage
	}
end

local function mapDispatchToProps(callback)
	return {
		playEmote = function(p, p2, p3)
			return callback(PlayEmote(p, p2, p3))
		end,
		focusSegment = function(p)
			return callback(FocusSegment(p))
		end,
		hideMenu = function()
			return callback(HideMenu())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
