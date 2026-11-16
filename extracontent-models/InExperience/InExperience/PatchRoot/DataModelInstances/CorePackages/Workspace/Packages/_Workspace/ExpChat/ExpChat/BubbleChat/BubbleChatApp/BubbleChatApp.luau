local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local IXPServiceWrapper = require(ExpChat.IXPServiceWrapper)

local ExpChatShared = require(parent.ExpChatShared)
local Roact = require(parent.Roact)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local llama2 = require(parent.llama)
local none = llama2.None
local SharedFlags = require(parent.SharedFlags)

local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local BubbleChat = script:FindFirstAncestor("BubbleChat")

local withSignalsData = require(script.Parent.withSignalsData)

local Config = require(ExpChat.Config)
local Permissions = Config.Permissions
local GlobalFlags = require(ExpChat.GlobalFlags)
local getFFlagUseCharacterStore = ExpChatShared.Flags.getFFlagUseCharacterStore

local defineFastFlag = game:DefineFastFlag("ExpChatRemoveBubbleChatAppUserMessagesState", false)
local defineFastFlag2 = game:DefineFastFlag("MemoizeBubbleChatApp", false)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore

local defineFastFlag3 = game:DefineFastFlag("ExpChatBubbleChatRerenderOnAncestryChange", false)

local extended = Roact.PureComponent:extend("BubbleChatApp")

local GetFStringVoicePerformanceIXPLayerName = require(ExpChat.Flags.GetFStringVoicePerformanceIXPLayerName)

local defineFastString = game:DefineFastString("BillboardUpdateFrequencyIXPLayerValue", "BillboardUpdateFrequency")
local BillboardGui = require(BubbleChat.BillboardGui)

if not defineFastFlag then
	function extended.getDerivedStateFromProps(p, p2)
		return {
			userMessages = dictionary.join(p2.userMessages or {}, p.userMessages)
		}
	end
end

function extended:init()
	v:debug("Initializing")
	self:setState({
		userMessages = not defineFastFlag and {} or nil,
		localPlayerVoiceEnabled = false,
		billboardUpdateFrequency = -1
	})

	function self.onBillboardFadeOut(p)
		if not defineFastFlag then
			self:setState({
				userMessages = dictionary.join(self.state.userMessages, { [p] = none })
			})
		end
	end

	function self.setCameraPermissionStateFromControl(hasCameraPermissions: boolean)
		self:setState({ hasCameraPermissions = hasCameraPermissions })
	end

	if defineFastFlag3 then
		self.isMounted = false
		self.ancestryConnections = {}
		function self.onTrackedAncestryChanged()
			if self.isMounted then
				self:setState(function(p)
					return {
						ancestryRerenderToken = (p.ancestryRerenderToken or 0) + 1
					}
				end)
			end
		end
	end

	local success, result = pcall(function()
		return IXPServiceWrapper:GetLayerData(GetFStringVoicePerformanceIXPLayerName())
	end)

	if success and result and result[defineFastString] then
		self:setState({ billboardUpdateFrequency = result[defineFastString] })
	end
end

function extended.getPermissions(object)
	local function fn(hasCameraPermissions, hasMicPermissions)
		object:setState({
			hasCameraPermissions = hasCameraPermissions,
			hasMicPermissions = hasMicPermissions
		})
	end

	if object.props.getPermissions then
		object.props.getPermissions(fn)
	end
end

function extended:getMicPermission()
	local function fn(_, hasMicPermissions)
		self:setState({ hasMicPermissions = hasMicPermissions })
	end

	if self.props.getPermissions then
		self.props.getPermissions(fn, Permissions.MICROPHONE_ACCESS)
	end
end

function extended:getCameraPermissionWithoutRequest()
	local function fn(hasCameraPermissions, _)
		self:setState({ hasCameraPermissions = hasCameraPermissions })
	end

	if self.props.getPermissions then
		self.props.getPermissions(fn, Permissions.CAMERA_ACCESS, true)
	end
end

function extended:updateTrackedAncestryConnections()
	local set = {}

	if self.props.characters then
		for _, character in pairs(self.props.characters) do
			if character then
				set[character] = true
			end
		end
	end

	if self.props.mockUserIdToPartOrModel then
		for _, partOrModel in pairs(self.props.mockUserIdToPartOrModel) do
			if partOrModel then
				set[partOrModel] = true
			end
		end
	end

	for k in pairs(set) do
		if not self.ancestryConnections[k] then
			self.ancestryConnections[k] = k.AncestryChanged:Connect(self.onTrackedAncestryChanged)
		end
	end

	for k, ancestryConnection in pairs(self.ancestryConnections) do
		if set[k] then
			continue
		end

		ancestryConnection:Disconnect()
		self.ancestryConnections[k] = nil
	end
end

function extended:didMount()
	if defineFastFlag3 then
		self.isMounted = true
		self:updateTrackedAncestryConnections()
	end

	if GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled then
		if self.props.isVoiceServiceInitialized then
			self.props.isVoiceServiceInitialized():andThen(function()
				self:getMicPermission()
			end):catch(function()
				v:debug("VoiceChatServiceManager failed to initialize inside TextChatService bubblechat")
			end)
		else
			self:getMicPermission()
		end

		self:getCameraPermissionWithoutRequest()
	end

	task.spawn(function()
		local success, result = pcall(function()
			if Players.LocalPlayer then
				return VoiceChatService:IsVoiceEnabledForUserIdAsync(Players.LocalPlayer.UserId)
			end

			return false
		end)

		if not success then
			v:debug("Unable to get voice enabled status: ", result)
		elseif result then
			self:setState({ localPlayerVoiceEnabled = true })

			IXPServiceWrapper:LogUserLayerExposure(GetFStringVoicePerformanceIXPLayerName())
		end
	end)
end

function extended:didUpdate()
	if defineFastFlag3 then
		self:updateTrackedAncestryConnections()
	end
end

function extended:willUnmount()
	if defineFastFlag3 then
		self.isMounted = false

		for k, ancestryConnection in pairs(self.ancestryConnections) do
			ancestryConnection:Disconnect()
			self.ancestryConnections[k] = nil
		end
	end
end

function extended.render(props)
	local v2 = {}

	if props.props.characters then
		for k, character in pairs(props.props.characters) do
			if character and character:IsDescendantOf(workspace) then
				v2[k] = false
			end
		end
	end

	if props.props.mockUserIdToPartOrModel then
		for k, partOrModel in pairs(props.props.mockUserIdToPartOrModel) do
			if partOrModel and partOrModel:IsDescendantOf(workspace) then
				v2[k] = false
			end
		end
	end

	if props.props.voiceParticipants then
		for k, voiceParticipant in pairs(props.props.voiceParticipants) do
			if voiceParticipant ~= "Hidden" then
				v2[k] = true
			end
		end
	end

	if GlobalFlags.AvatarChatEnabled and props.state.hasCameraPermissions and Players.LocalPlayer then
		v2[tostring(Players.LocalPlayer.UserId)] = true
	end

	return Roact.createElement("ScreenGui", { ResetOnSpawn = false }, dictionary.map(v2, function(p, userId)
		return Roact.createElement(BillboardGui, {
			userId = userId,
			onFadeOut = props.onBillboardFadeOut,
			voiceEnabled = props.props.voiceEnabled and p,
			getIconVoiceIndicator = props.props.getIconVoiceIndicator,
			onClickedVoiceIndicator = props.props.onClickedVoiceIndicator,
			onClickedCameraIndicator = props.props.onClickedCameraIndicator,
			selfViewListenerChanged = props.props.selfViewListenerChanged,
			hasCameraPermissions = props.state.hasCameraPermissions,
			hasMicPermissions = props.state.hasMicPermissions,
			displayCameraDeniedToast = props.props.displayCameraDeniedToast,
			isCamEnabledForUserAndPlace = props.props.isCamEnabledForUserAndPlace,
			isCameraOnlyUser = props.props.isCameraOnlyUser,
			setCameraPermissionStateFromControl = props.setCameraPermissionStateFromControl,
			getPermissions = props.props.getPermissions,
			voiceState = props.props.voiceParticipants[userId],
			partOrModel = props.props.mockUserIdToPartOrModel[userId],
			isTextChatServiceOn = props.props.isTextChatServiceOn,
			billboardUpdateFrequency = props.state.billboardUpdateFrequency
		}), "BubbleChat_" .. userId
	end))
end

local function mapStateToProps(data, p)
	local mockUserIdToPartOrModel = data.Messages.mockUserIdToPartOrModel

	if p.mockUserIdToPartOrModel then
		mockUserIdToPartOrModel = p.mockUserIdToPartOrModel
	else
		local context = ExpChatShared.context
		local messagesStore = context and context.messagesStore

		if messagesStore then
			mockUserIdToPartOrModel = messagesStore.getMockUserIdToPartOrModel(false)
		end
	end

	local userMessages

	if not defineFastFlag then
		userMessages = data.Messages.messagesBySenderId
	end

	local v2 = {
		userMessages = userMessages,
		voiceEnabled = data.Voice.isEnabled,
		characters = 0,
		voiceParticipants = 0,
		mockUserIdToPartOrModel = 0
	}
	local characters

	if not getFFlagUseCharacterStore() then
		characters = data.Players.charactersByUserId
	end

	v2.characters = characters
	local voiceParticipants

	if not GetFFlagExpChatUseVoiceParticipantsStore() then
		voiceParticipants = data.Voice.participants
	end

	v2.voiceParticipants = voiceParticipants
	v2.mockUserIdToPartOrModel = mockUserIdToPartOrModel
	return v2
end

if getFFlagUseCharacterStore() or GetFFlagExpChatUseVoiceParticipantsStore() then
	local v2 = RoactRodux.connect(mapStateToProps)(extended)

	if defineFastFlag2 then
		return (React.memo(withSignalsData(v2)))
	end

	return (withSignalsData(v2))
elseif defineFastFlag2 then
	return (React.memo(RoactRodux.connect(mapStateToProps)(extended)))
else
	return (RoactRodux.connect(mapStateToProps)(extended))
end
