local parent = script:FindFirstAncestor("ExpChat").Parent

local ExpChatShared = require(parent.ExpChatShared)
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local UIBlox = require(parent.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local BubbleChat = script:FindFirstAncestor("BubbleChat")
local getVoiceIndicatorIcon = require(BubbleChat.Helpers.getVoiceIndicatorIcon)

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore

local extended = Roact.PureComponent:extend("VoiceIndicator")

extended.defaultProps = {}

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

		return getVoiceIndicatorIcon(self.props.getIcon, item, item2, self.props.iconStyle)
	end)

	function self.onClicked()
		if self.props.onClicked and self.props.userId then
			self.props.onClicked(self.props.userId)
		end
	end
end

function extended:renderWithSelectionCursor(callback)
	local v2 = self.props.voiceState == "Error" or self.props.voiceState == "Hidden"

	if self.props.hideOnError and (not self.props.voiceState or v2) then
		return nil
	end

	local v3 = self.props.voiceState == "LOCAL_MUTED" and 0.5 or 0
	local imageTransparency

	if self.props.iconTransparency then
		if type(self.props.iconTransparency) == "number" then
			imageTransparency = 1 - (1 - self.props.iconTransparency) * (1 - v3)
		else
			imageTransparency = self.props.iconTransparency:map(function(p)
				return 1 - (1 - p) * (1 - v3)
			end)
		end
	else
		imageTransparency = v3
	end

	return Roact.createElement("ImageButton", {
		Size = self.props.size or UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = self.levelIcon,
		ImageTransparency = imageTransparency,
		SelectionImageObject = callback(CursorKind.RoundedRectNoInset),
		[Roact.Event.Activated] = self.onClicked
	})
end

function extended:render()
	return withSelectionCursorProvider(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended.didUpdate(p, p2, _)
	v:trace("Voice state updated to {} for ...{}", p.props.voiceState, (string.sub(tostring(p.props.userId), -4)))

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
	return { voiceState = p.Voice.participants[p2.userId] }
end

if GetFFlagExpChatUseVoiceParticipantsStore() then
	return extended
end

return RoactRodux.connect(mapStateToProps)(extended)
