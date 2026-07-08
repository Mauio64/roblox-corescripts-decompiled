local ContextActionService = game:GetService("ContextActionService")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local VRService = game:GetService("VRService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Actions = scriptParentParent.Actions
local Thunks = scriptParentParent.Thunks
local Utility = scriptParentParent.Utility
local Constants = require(scriptParentParent.Constants)
local GetSegmentFromPosition = require(Utility.GetSegmentFromPosition)
local EmotesButtons = require(scriptParent.EmotesButtons)
local SlotNumbers = require(scriptParent.SlotNumbers)
local WheelBackground = require(scriptParent.WheelBackground)
local FocusSegment = require(Actions.FocusSegment)
local HideMenu = require(Actions.HideMenu)
local PlayEmote = require(Thunks.PlayEmote)
local HighValue = Enum.ContextActionPriority.High.Value
local v23 = Roact.PureComponent:extend("EmotesWheel")

local function getRandomAssetId(p1) -- line: 36
	if #p1 == 0 then
		return
	end

	return p1[math.random(1, #p1)]
end

function v23.bindActions(p2) -- line: 45
	-- upvalues: Constants (copy), GetSegmentFromPosition (copy), ContextActionService (copy), HighValue (copy)
	if p2.actionsBound then
		return
	end

	local function selectEmote(_, _, p5) -- line: 50
		-- upvalues: Constants (copy), GetSegmentFromPosition (copy), p2 (copy)
		local vector2 = Vector2.new(p5.Position.X, p5.Position.Y)

		if vector2.Magnitude < Constants.ThumbstickThreshold then
			return
		end

		local v51 = GetSegmentFromPosition(vector2)

		if v51 == p2.props.emotesWheel.focusedSegmentIndex then
			return
		end

		if p2.props.emotesPage.currentEmotes[v51] then
			p2.props.focusSegment(v51)

			return
		end

		p2.props.focusSegment(0)
	end

	ContextActionService:BindActionAtPriority(Constants.EmoteSelectionAction, selectEmote, false, HighValue, Constants.SelectionThumbstick)

	local function playSelected(_, p7, _) -- line: 78
		-- upvalues: p2 (copy)
		if p7 == Enum.UserInputState.Begin then
			local focusedSegmentIndex = p2.props.emotesWheel.focusedSegmentIndex
			local v56 = p2.props.emotesPage.currentEmotes[focusedSegmentIndex]

			if not v56 then
				return
			end

			local v57 = p2.props.emotesPage.emotesInfo[v56]

			if not v57 then
				return
			end

			local v58 = if #v57 ~= 0 then v57[math.random(1, #v57)] else nil

			p2.props.playEmote(v56, focusedSegmentIndex, v58)
		end
	end

	ContextActionService:BindActionAtPriority(Constants.PlaySelectedAction, playSelected, false, HighValue, Constants.PlayEmoteButton)

	local function closeMenu(_, p10, _) -- line: 106
		-- upvalues: p2 (copy)
		if p10 == Enum.UserInputState.Begin then
			p2.props.hideMenu()
		end
	end

	local t1 = {
		Constants.EmoteMenuCloseKey,
		Constants.EmoteMenuCloseButton,
		Constants.EmoteMenuCloseButtonSecondary
	}

	ContextActionService:BindActionAtPriority(Constants.CloseMenuAction, closeMenu, false, HighValue, unpack(t1))

	local function closeMenuNoSink(_, p13, _) -- line: 126
		-- upvalues: p2 (copy)
		if p13 == Enum.UserInputState.Begin then
			p2.props.hideMenu()
		end

		return Enum.ContextActionResult.Pass
	end

	ContextActionService:BindActionAtPriority(Constants.LeaveMenuDontSinkInputAction, closeMenuNoSink, false, HighValue, unpack(Constants.LeaveMenuNoSinkInputs))

	local function activateEmoteByNumber(_, p16, p17) -- line: 141
		-- upvalues: Constants (copy), p2 (copy)
		if p16 ~= Enum.UserInputState.Begin then
			return
		end

		local v68 = nil

		for i, v in ipairs(Constants.EmoteSlotKeys) do
			if v == p17.KeyCode then
				v68 = i

				break
			end
		end

		if not v68 then
			return
		end

		local v71 = p2.props.emotesPage.currentEmotes[v68]

		if not v71 then
			return
		end

		local v72 = p2.props.emotesPage.emotesInfo[v71]

		if not v72 then
			return
		end

		local v73 = if #v72 ~= 0 then v72[math.random(1, #v72)] else nil

		p2.props.playEmote(v71, v68, v73)
	end

	ContextActionService:BindActionAtPriority(Constants.ActivateEmoteSlotAction, activateEmoteByNumber, false, HighValue, unpack(Constants.EmoteSlotKeys))

	local function sinkInput(_, _, _) -- line: 182
		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreActionAtPriority(Constants.VirtualCursorSinkAction, sinkInput, false, HighValue, Enum.KeyCode.ButtonSelect)
	p2.actionsBound = true
end
function v23.unbindActions(p21) -- line: 196
	-- upvalues: ContextActionService (copy), Constants (copy)
	if p21.actionsBound then
		ContextActionService:UnbindAction(Constants.CloseMenuAction)
		ContextActionService:UnbindAction(Constants.EmoteSelectionAction)
		ContextActionService:UnbindAction(Constants.PlaySelectedAction)
		ContextActionService:UnbindAction(Constants.LeaveMenuDontSinkInputAction)
		ContextActionService:UnbindAction(Constants.ActivateEmoteSlotAction)
		ContextActionService:UnbindCoreAction(Constants.VirtualCursorSinkAction)
		p21.actionsBound = false
	end
end
function v23.addCursorOverride(p22) -- line: 209
	-- upvalues: VRService (copy), MouseIconOverrideService (copy), Constants (copy), GamepadService (copy)
	if VRService.VREnabled then
		return
	end

	if p22.isUsingGamepad and not p22.isCursorHidden then
		MouseIconOverrideService.push(Constants.CursorOverrideName, Enum.OverrideMouseIconBehavior.ForceHide)
		GamepadService.GamepadCursorEnabled = false
		p22.isCursorHidden = true
	end
end
function v23.removeCursorOverride(p23) -- line: 222
	-- upvalues: MouseIconOverrideService (copy), Constants (copy)
	if p23.isCursorHidden then
		MouseIconOverrideService.pop(Constants.CursorOverrideName)
		p23.isCursorHidden = false
	end
end
function v23.connectListeners(p24) -- line: 230
	-- upvalues: UserInputService (copy), Constants (copy)
	p24.inputTypeChangedListener = UserInputService.LastInputTypeChanged:Connect(function(p25) -- line: 231
		-- upvalues: Constants (copy), p24 (copy)
		if Constants.GamepadInputTypes[p25] then
			p24.isUsingGamepad = true

			if p24.props.displayOptions.menuVisible then
				p24:addCursorOverride()

				return
			end
		else
			p24.isUsingGamepad = false
			p24:removeCursorOverride()
		end
	end)
end
function v23.disconnectListeners(p26) -- line: 246
	p26.inputTypeChangedListener:Disconnect()
end
function v23.didUpdate(p27) -- line: 250
	if p27.props.displayOptions.menuVisible then
		p27:bindActions()
		p27:addCursorOverride()

		return
	end

	p27:unbindActions()
	p27:removeCursorOverride()
end
function v23.didMount(p28) -- line: 262
	if p28.props.displayOptions.menuVisible then
		p28:bindActions()
	end

	p28:connectListeners()
end
function v23.willUnmount(p29) -- line: 270
	p29:unbindActions()
	p29:disconnectListeners()
end
function v23.render(p30) -- line: 276
	-- upvalues: Roact (copy), WheelBackground (copy), EmotesButtons (copy), SlotNumbers (copy)
	return Roact.createElement("Frame", {
		Active = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = p30.props.displayOptions.menuVisible
	}, {
		MouseUnlock = Roact.createElement("TextButton", {
			Modal = true,
			Text = "",
			Transparency = 1,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		Back = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Background = Roact.createElement(WheelBackground)
		}),
		Front = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			EmotesButtons = Roact.createElement(EmotesButtons),
			SlotNumbers = Roact.createElement(SlotNumbers)
		})
	})
end

local function mapStateToProps(p31) -- line: 309
	return {
		displayOptions = p31.displayOptions,
		emotesWheel = p31.emotesWheel,
		emotesPage = p31.emotesPage
	}
end
local function mapDispatchToProps(p32) -- line: 317
	-- upvalues: PlayEmote (copy), FocusSegment (copy), HideMenu (copy)
	return {
		playEmote = function(p33, p34, p35) -- line: 319
			-- upvalues: p32 (copy), PlayEmote (copy)
			return p32(PlayEmote(p33, p34, p35))
		end,
		focusSegment = function(p36) -- line: 323
			-- upvalues: p32 (copy), FocusSegment (copy)
			return p32(FocusSegment(p36))
		end,
		hideMenu = function() -- line: 327
			-- upvalues: p32 (copy), HideMenu (copy)
			return p32(HideMenu())
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v23)
