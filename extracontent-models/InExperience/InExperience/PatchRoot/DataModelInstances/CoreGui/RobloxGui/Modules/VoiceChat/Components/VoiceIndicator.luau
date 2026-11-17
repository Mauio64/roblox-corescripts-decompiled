local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local Logger = require(RobloxGui.Modules.VoiceChat.Logger)
local logger = Logger(script.Name)

local Roact = require(CorePackages.Packages.Roact)
local ReactIs = require(CorePackages.Packages.ReactIs)

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local extended = Roact.PureComponent:extend("VoiceIndicator")

extended.validateProps = t.strictInterface({
	onClicked = t.optional(t.callback),
	userId = t.string,
	hideOnError = t.optional(t.boolean),
	size = t.optional(t.UDim2),
	iconStyle = t.optional(t.union(
		t.literal("MicDark"),
		t.literal("MicLight"),
		t.literal("SpeakerDark"),
		t.literal("SpeakerLight")
	)),
	iconTransparency = t.optional(t.union(t.number, t.table)),
	voiceState = t.string
})

extended.defaultProps = {}

function extended.getIcon(_, p)
	return "rbxasset://textures/ui/VoiceChat/" .. p .. ".png"
end

function extended:init()
	local binding, updateLevel = Roact.createBinding(0)
	self.level = binding
	self.updateLevel = updateLevel
	local binding2, updateVoiceState = Roact.createBinding(self.props.voiceState)
	self.voiceState = binding2
	self.updateVoiceState = updateVoiceState

	self.renderStepName = HttpService:GenerateGUID()
	RunService:BindToRenderStep(self.renderStepName, 1, function()
		self.updateLevel(math.random())
	end)

	self.levelIcon = Roact.joinBindings({ self.voiceState, self.level }):map(function(list)
		local item = list[1]
		local item2 = list[2]

		if item == Constants.VOICE_STATE.MUTED or item == Constants.VOICE_STATE.LOCAL_MUTED then
			return default:GetIcon("Muted", self.props.iconStyle)
		end

		if item == Constants.VOICE_STATE.CONNECTING then
			return default:GetIcon("Connecting", self.props.iconStyle)
		end

		if item == Constants.VOICE_STATE.INACTIVE then
			return default:GetIcon("Unmuted0", self.props.iconStyle)
		end

		if item ~= Constants.VOICE_STATE.TALKING then
			return default:GetIcon("Error", self.props.iconStyle)
		end

		local v = math.floor(item2 * 5 + 0.5) * 20
		return default:GetIcon("Unmuted" .. tostring(v), self.props.iconStyle)
	end)
end

function extended:renderWithSelectionCursor(callback)
	local v = self.props.voiceState == Constants.VOICE_STATE.ERROR
		or self.props.voiceState == Constants.VOICE_STATE.HIDDEN

	if self.props.hideOnError and (not self.props.voiceState or v) then
		return nil
	end

	local v2 = self.props.voiceState == Constants.VOICE_STATE.LOCAL_MUTED and 0.5 or 0
	local imageTransparency

	if self.props.iconTransparency then
		if ReactIs.isBinding(self.props.iconTransparency) then
			imageTransparency = self.props.iconTransparency:map(function(p)
				return 1 - (1 - p) * (1 - v2)
			end)
		else
			imageTransparency = 1 - (1 - self.props.iconTransparency) * (1 - v2)
		end
	else
		imageTransparency = v2
	end

	return Roact.createElement("ImageButton", {
		Size = self.props.size or UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = self.levelIcon,
		ImageTransparency = imageTransparency,
		SelectionImageObject = callback(CursorKind.RoundedRectNoInset),
		[Roact.Event.Activated] = self.props.onClicked
	})
end

function extended:render()
	return withSelectionCursorProvider(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended.didUpdate(p, p2, _)
	logger:trace("Voice state updated to {} for ...{}", p.props.voiceState, (string.sub(tostring(p.props.userId), -4)))

	if p2.voiceState ~= p.props.voiceState then
		p.updateVoiceState(p.props.voiceState)
	end
end

function extended.willUnmount(p)
	pcall(function()
		RunService:UnbindFromRenderStep(p.renderStepName)
	end)
end

local function mapStateToProps(p, p2)
	return { voiceState = p.voiceState[p2.userId] }
end

return RoactRodux.connect(mapStateToProps)(extended)
