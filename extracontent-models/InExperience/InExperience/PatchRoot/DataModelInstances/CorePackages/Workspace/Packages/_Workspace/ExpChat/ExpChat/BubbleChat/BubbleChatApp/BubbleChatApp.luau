local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local IXPServiceWrapper = require(ExpChat.IXPServiceWrapper)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Roact = require(ExpChatParent.Roact)
local React = require(ExpChatParent.React)
local RoactRodux = require(ExpChatParent.RoactRodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local None = require(ExpChatParent.llama).None
local SharedFlags = require(ExpChatParent.SharedFlags)
local v13 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local BubbleChat = script:FindFirstAncestor("BubbleChat")
local withSignalsData = require(script.Parent.withSignalsData)
local Permissions = require(ExpChat.Config).Permissions
local GlobalFlags = require(ExpChat.GlobalFlags)
local getFFlagUseCharacterStore = ExpChatShared.Flags.getFFlagUseCharacterStore
local v19 = game:DefineFastFlag("ExpChatRemoveBubbleChatAppUserMessagesState", false)
local FFlagExpChatUseMessagesStore = require(ExpChatParent.SharedFlags).FFlagExpChatUseMessagesStore
local v21 = game:DefineFastFlag("MemoizeBubbleChatApp", false)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore
local v23 = game:DefineFastFlag("ExpChatBubbleChatRerenderOnAncestryChange", false)
local v24 = Roact.PureComponent:extend("BubbleChatApp")
local GetFStringVoicePerformanceIXPLayerName = require(ExpChat.Flags.GetFStringVoicePerformanceIXPLayerName)
local v26 = game:DefineFastString("BillboardUpdateFrequencyIXPLayerValue", "BillboardUpdateFrequency")
local BillboardGui = require(BubbleChat.BillboardGui)

if not v19 then
	function v24.getDerivedStateFromProps(p1, p2) -- line: 42
		-- upvalues: Dictionary (copy)
		return {
			userMessages = Dictionary.join(p2.userMessages or {}, p1.userMessages)
		}
	end
end

function v24.init(p3) -- line: 52
	-- upvalues: v13 (copy), v19 (copy), Dictionary (copy), None (copy), v23 (copy), IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy), v26 (copy)
	v13:debug("Initializing")
	p3:setState({
		localPlayerVoiceEnabled = false,
		billboardUpdateFrequency = -1,
		userMessages = if not v19 then {} else nil
	})

	function p3.onBillboardFadeOut(p4) -- line: 60
		-- upvalues: v19 (copy), p3 (copy), Dictionary (copy), None (copy)
		if not v19 then
			p3:setState({
				userMessages = Dictionary.join(p3.state.userMessages, {
					[p4] = None
				})
			})
		end
	end
	function p3.setCameraPermissionStateFromControl(b1: boolean) -- line: 68
		-- upvalues: p3 (copy)
		p3:setState({
			hasCameraPermissions = b1
		})
	end

	if v23 then
		p3.isMounted = false
		p3.ancestryConnections = {}

		function p3.onTrackedAncestryChanged() -- line: 77
			-- upvalues: p3 (copy)
			if p3.isMounted then
				p3:setState(function(p5) -- line: 81
					return {
						ancestryRerenderToken = (p5.ancestryRerenderToken or 0) + 1
					}
				end)
			end
		end
	end

	local ok, result = pcall(function() -- line: 88
		-- upvalues: IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy)
		return IXPServiceWrapper:GetLayerData(GetFStringVoicePerformanceIXPLayerName())
	end)

	if ok and result and result[v26] then
		p3:setState({
			billboardUpdateFrequency = result[v26]
		})
	end
end
function v24.getPermissions(p6) -- line: 102
	if p6.props.getPermissions then
		p6.props.getPermissions(function(p7, p8) -- line: 103
			-- upvalues: p6 (copy)
			p6:setState({
				hasCameraPermissions = p7,
				hasMicPermissions = p8
			})
		end)
	end
end
function v24.getMicPermission(p9) -- line: 118
	-- upvalues: Permissions (copy)
	if p9.props.getPermissions then
		p9.props.getPermissions(function(_, p11) -- line: 119
			-- upvalues: p9 (copy)
			p9:setState({
				hasMicPermissions = p11
			})
		end, Permissions.MICROPHONE_ACCESS)
	end
end
function v24.getCameraPermissionWithoutRequest(p12) -- line: 133
	-- upvalues: Permissions (copy)
	if p12.props.getPermissions then
		p12.props.getPermissions(function(p13, _) -- line: 134
			-- upvalues: p12 (copy)
			p12:setState({
				hasCameraPermissions = p13
			})
		end, Permissions.CAMERA_ACCESS, true)
	end
end
function v24.updateTrackedAncestryConnections(p15) -- line: 148
	local t1 = {}

	if p15.props.characters then
		for _, v in pairs(p15.props.characters) do
			if v then
				t1[v] = true
			end
		end
	end

	if p15.props.mockUserIdToPartOrModel then
		for _, v in pairs(p15.props.mockUserIdToPartOrModel) do
			if v then
				t1[v] = true
			end
		end
	end

	for k in pairs(t1) do
		if not p15.ancestryConnections[k] then
			p15.ancestryConnections[k] = k.AncestryChanged:Connect(p15.onTrackedAncestryChanged)
		end
	end

	for k, v in pairs(p15.ancestryConnections) do
		if not t1[k] then
			v:Disconnect()
			p15.ancestryConnections[k] = nil
		end
	end
end
function v24.didMount(p16) -- line: 179
	-- upvalues: v23 (copy), GlobalFlags (copy), v13 (copy), Players (copy), VoiceChatService (copy), IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy)
	if v23 then
		p16.isMounted = true
		p16:updateTrackedAncestryConnections()
	end

	if GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled then
		if p16.props.isVoiceServiceInitialized then
			p16.props.isVoiceServiceInitialized():andThen(function() -- line: 191
				-- upvalues: p16 (copy)
				p16:getMicPermission()
			end):catch(function() -- line: 194
				-- upvalues: v13 (copy)
				v13:debug("VoiceChatServiceManager failed to initialize inside TextChatService bubblechat")
			end)
		else
			p16:getMicPermission()
		end

		p16:getCameraPermissionWithoutRequest()
	end

	task.spawn(function() -- line: 203
		-- upvalues: Players (copy), VoiceChatService (copy), v13 (copy), p16 (copy), IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy)
		local ok, result = pcall(function() -- line: 204
			-- upvalues: Players (copy), VoiceChatService (copy)
			if Players.LocalPlayer then
				return VoiceChatService:IsVoiceEnabledForUserIdAsync(Players.LocalPlayer.UserId)
			end

			return false
		end)

		if not ok then
			v13:debug("Unable to get voice enabled status: ", result)

			return
		end

		if result then
			p16:setState({
				localPlayerVoiceEnabled = true
			})
			IXPServiceWrapper:LogUserLayerExposure(GetFStringVoicePerformanceIXPLayerName())
		end
	end)
end
function v24.didUpdate(p17) -- line: 225
	-- upvalues: v23 (copy)
	if v23 then
		p17:updateTrackedAncestryConnections()
	end
end
function v24.willUnmount(p18) -- line: 231
	-- upvalues: v23 (copy)
	if v23 then
		p18.isMounted = false

		for k, v in pairs(p18.ancestryConnections) do
			v:Disconnect()
			p18.ancestryConnections[k] = nil
		end
	end
end
function v24.render(p19) -- line: 241
	-- upvalues: GlobalFlags (copy), Players (copy), Roact (copy), Dictionary (copy), BillboardGui (copy), FFlagExpChatUseMessagesStore (copy)
	local t2 = {}

	if p19.props.characters then
		for k, v in pairs(p19.props.characters) do
			if v and v:IsDescendantOf(workspace) then
				t2[k] = false
			end
		end
	end

	if p19.props.mockUserIdToPartOrModel then
		for k, v in pairs(p19.props.mockUserIdToPartOrModel) do
			if v and v:IsDescendantOf(workspace) then
				t2[k] = false
			end
		end
	end

	if p19.props.voiceParticipants then
		for k, v in pairs(p19.props.voiceParticipants) do
			if v ~= "Hidden" then
				t2[k] = true
			end
		end
	end

	if GlobalFlags.AvatarChatEnabled and p19.state.hasCameraPermissions and Players.LocalPlayer then
		t2[tostring(Players.LocalPlayer.UserId)] = true
	end

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false
	}, Dictionary.map(t2, function(p20, p21) -- line: 286
		-- upvalues: Roact (copy), BillboardGui (copy), p19 (copy), FFlagExpChatUseMessagesStore (copy)
		return Roact.createElement(BillboardGui, {
			userId = p21,
			onFadeOut = p19.onBillboardFadeOut,
			voiceEnabled = p19.props.voiceEnabled and p20,
			getIconVoiceIndicator = p19.props.getIconVoiceIndicator,
			onClickedVoiceIndicator = p19.props.onClickedVoiceIndicator,
			onClickedCameraIndicator = p19.props.onClickedCameraIndicator,
			selfViewListenerChanged = p19.props.selfViewListenerChanged,
			hasCameraPermissions = p19.state.hasCameraPermissions,
			hasMicPermissions = p19.state.hasMicPermissions,
			displayCameraDeniedToast = p19.props.displayCameraDeniedToast,
			isCamEnabledForUserAndPlace = p19.props.isCamEnabledForUserAndPlace,
			isCameraOnlyUser = p19.props.isCameraOnlyUser,
			setCameraPermissionStateFromControl = p19.setCameraPermissionStateFromControl,
			getPermissions = p19.props.getPermissions,
			isBubbleChatEnabled = if not FFlagExpChatUseMessagesStore then p19.props.isBubbleChatEnabled else nil,
			voiceState = p19.props.voiceParticipants[p21],
			partOrModel = p19.props.mockUserIdToPartOrModel[p21],
			isTextChatServiceOn = p19.props.isTextChatServiceOn,
			billboardUpdateFrequency = p19.state.billboardUpdateFrequency
		}), "BubbleChat_" .. p21
	end))
end

local function mapStateToProps(p22, p23) -- line: 313
	-- upvalues: FFlagExpChatUseMessagesStore (copy), ExpChatShared (copy), v19 (copy), getFFlagUseCharacterStore (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy)
	local v62 = nil

	if not FFlagExpChatUseMessagesStore then
		v62 = if not p23.isTextChatServiceOn then p22.LegacyBubbleChatSettings.Enabled else p22.BubbleChatSettings.Enabled
	end

	local mockUserIdToPartOrModel = p22.Messages.mockUserIdToPartOrModel

	if FFlagExpChatUseMessagesStore then
		if p23.mockUserIdToPartOrModel then
			mockUserIdToPartOrModel = p23.mockUserIdToPartOrModel
		else
			local context = ExpChatShared.context
			local v65 = context and context.messagesStore

			if v65 then
				mockUserIdToPartOrModel = v65.getMockUserIdToPartOrModel(false)
			end
		end
	end

	return {
		isBubbleChatEnabled = if not FFlagExpChatUseMessagesStore then v62 else nil,
		userMessages = if not v19 then p22.Messages.messagesBySenderId else nil,
		voiceEnabled = p22.Voice.isEnabled,
		characters = if not getFFlagUseCharacterStore() then p22.Players.charactersByUserId else nil,
		voiceParticipants = if not GetFFlagExpChatUseVoiceParticipantsStore() then p22.Voice.participants else nil,
		mockUserIdToPartOrModel = mockUserIdToPartOrModel
	}
end

if getFFlagUseCharacterStore() or GetFFlagExpChatUseVoiceParticipantsStore() then
	local v29 = RoactRodux.connect(mapStateToProps)(v24)

	if v21 then
		return (React.memo(withSignalsData(v29)))
	end

	return (withSignalsData(v29))
end

if v21 then
	return (React.memo(RoactRodux.connect(mapStateToProps)(v24)))
end

return (RoactRodux.connect(mapStateToProps)(v24))
