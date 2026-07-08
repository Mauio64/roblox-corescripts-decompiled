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
local v23 = Roact.PureComponent:extend("BubbleChatApp")
local GetFStringVoicePerformanceIXPLayerName = require(ExpChat.Flags.GetFStringVoicePerformanceIXPLayerName)
local v25 = game:DefineFastString("BillboardUpdateFrequencyIXPLayerValue", "BillboardUpdateFrequency")
local BillboardGui = require(BubbleChat.BillboardGui)

if not v19 then
	function v23.getDerivedStateFromProps(p1, p2) -- line: 40
		-- upvalues: Dictionary (copy)
		return {
			userMessages = Dictionary.join(p2.userMessages or {}, p1.userMessages)
		}
	end
end

function v23.init(p3) -- line: 50
	-- upvalues: v13 (copy), v19 (copy), Dictionary (copy), None (copy), IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy), v25 (copy)
	v13:debug("Initializing")
	p3:setState({
		localPlayerVoiceEnabled = false,
		billboardUpdateFrequency = -1,
		userMessages = if not v19 then {} else nil
	})

	function p3.onBillboardFadeOut(p4) -- line: 58
		-- upvalues: v19 (copy), p3 (copy), Dictionary (copy), None (copy)
		if not v19 then
			p3:setState({
				userMessages = Dictionary.join(p3.state.userMessages, {
					[p4] = None
				})
			})
		end
	end
	function p3.setCameraPermissionStateFromControl(b1: boolean) -- line: 66
		-- upvalues: p3 (copy)
		p3:setState({
			hasCameraPermissions = b1
		})
	end

	local ok, result = pcall(function() -- line: 72
		-- upvalues: IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy)
		return IXPServiceWrapper:GetLayerData(GetFStringVoicePerformanceIXPLayerName())
	end)

	if ok and (result and result[v25]) then
		p3:setState({
			billboardUpdateFrequency = result[v25]
		})
	end
end
function v23.getPermissions(p5) -- line: 86
	if p5.props.getPermissions then
		p5.props.getPermissions(function(p6, p7) -- line: 87
			-- upvalues: p5 (copy)
			p5:setState({
				hasCameraPermissions = p6,
				hasMicPermissions = p7
			})
		end)
	end
end
function v23.getMicPermission(p8) -- line: 102
	-- upvalues: Permissions (copy)
	if p8.props.getPermissions then
		p8.props.getPermissions(function(_, p10) -- line: 103
			-- upvalues: p8 (copy)
			p8:setState({
				hasMicPermissions = p10
			})
		end, Permissions.MICROPHONE_ACCESS)
	end
end
function v23.getCameraPermissionWithoutRequest(p11) -- line: 117
	-- upvalues: Permissions (copy)
	if p11.props.getPermissions then
		p11.props.getPermissions(function(p12, _) -- line: 118
			-- upvalues: p11 (copy)
			p11:setState({
				hasCameraPermissions = p12
			})
		end, Permissions.CAMERA_ACCESS, true)
	end
end
function v23.didMount(p14) -- line: 130
	-- upvalues: GlobalFlags (copy), v13 (copy), Players (copy), VoiceChatService (copy), IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy)
	if GlobalFlags.AvatarChatEnabled or GlobalFlags.ChromeEnabled then
		if p14.props.isVoiceServiceInitialized then
			p14.props.isVoiceServiceInitialized():andThen(function() -- line: 137
				-- upvalues: p14 (copy)
				p14:getMicPermission()
			end):catch(function() -- line: 140
				-- upvalues: v13 (copy)
				v13:debug("VoiceChatServiceManager failed to initialize inside TextChatService bubblechat")
			end)
		else
			p14:getMicPermission()
		end

		p14:getCameraPermissionWithoutRequest()
	end

	task.spawn(function() -- line: 149
		-- upvalues: Players (copy), VoiceChatService (copy), v13 (copy), p14 (copy), IXPServiceWrapper (copy), GetFStringVoicePerformanceIXPLayerName (copy)
		local ok, result = pcall(function() -- line: 150
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
			p14:setState({
				localPlayerVoiceEnabled = true
			})
			IXPServiceWrapper:LogUserLayerExposure(GetFStringVoicePerformanceIXPLayerName())
		end
	end)
end
function v23.render(p15) -- line: 171
	-- upvalues: GlobalFlags (copy), Players (copy), Roact (copy), Dictionary (copy), BillboardGui (copy), FFlagExpChatUseMessagesStore (copy)
	local t1 = {}

	if p15.props.characters then
		for k, v in pairs(p15.props.characters) do
			if v and v:IsDescendantOf(workspace) then
				t1[k] = false
			end
		end
	end

	if p15.props.mockUserIdToPartOrModel then
		for k, v in pairs(p15.props.mockUserIdToPartOrModel) do
			if v and v:IsDescendantOf(workspace) then
				t1[k] = false
			end
		end
	end

	if p15.props.voiceParticipants then
		for k, v in pairs(p15.props.voiceParticipants) do
			if v ~= "Hidden" then
				t1[k] = true
			end
		end
	end

	if GlobalFlags.AvatarChatEnabled and p15.state.hasCameraPermissions and Players.LocalPlayer then
		t1[tostring(Players.LocalPlayer.UserId)] = true
	end

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false
	}, Dictionary.map(t1, function(p16, p17) -- line: 216
		-- upvalues: Roact (copy), BillboardGui (copy), p15 (copy), FFlagExpChatUseMessagesStore (copy)
		return Roact.createElement(BillboardGui, {
			userId = p17,
			onFadeOut = p15.onBillboardFadeOut,
			voiceEnabled = p15.props.voiceEnabled and p16,
			getIconVoiceIndicator = p15.props.getIconVoiceIndicator,
			onClickedVoiceIndicator = p15.props.onClickedVoiceIndicator,
			onClickedCameraIndicator = p15.props.onClickedCameraIndicator,
			selfViewListenerChanged = p15.props.selfViewListenerChanged,
			hasCameraPermissions = p15.state.hasCameraPermissions,
			hasMicPermissions = p15.state.hasMicPermissions,
			displayCameraDeniedToast = p15.props.displayCameraDeniedToast,
			isCamEnabledForUserAndPlace = p15.props.isCamEnabledForUserAndPlace,
			isCameraOnlyUser = p15.props.isCameraOnlyUser,
			setCameraPermissionStateFromControl = p15.setCameraPermissionStateFromControl,
			getPermissions = p15.props.getPermissions,
			isBubbleChatEnabled = if not FFlagExpChatUseMessagesStore then p15.props.isBubbleChatEnabled else nil,
			voiceState = p15.props.voiceParticipants[p17],
			partOrModel = p15.props.mockUserIdToPartOrModel[p17],
			isTextChatServiceOn = p15.props.isTextChatServiceOn,
			billboardUpdateFrequency = p15.state.billboardUpdateFrequency
		}), "BubbleChat_" .. p17
	end))
end

local function mapStateToProps(p18, p19) -- line: 243
	-- upvalues: FFlagExpChatUseMessagesStore (copy), ExpChatShared (copy), v19 (copy), getFFlagUseCharacterStore (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy)
	local v48 = nil

	if not FFlagExpChatUseMessagesStore then
		v48 = if not p19.isTextChatServiceOn then p18.LegacyBubbleChatSettings.Enabled else p18.BubbleChatSettings.Enabled
	end

	local mockUserIdToPartOrModel = p18.Messages.mockUserIdToPartOrModel

	if FFlagExpChatUseMessagesStore then
		if p19.mockUserIdToPartOrModel then
			mockUserIdToPartOrModel = p19.mockUserIdToPartOrModel
		else
			local context = ExpChatShared.context
			local v51 = context and context.messagesStore

			if v51 then
				mockUserIdToPartOrModel = v51.getMockUserIdToPartOrModel(false)
			end
		end
	end

	return {
		isBubbleChatEnabled = if not FFlagExpChatUseMessagesStore then v48 else nil,
		userMessages = if not v19 then p18.Messages.messagesBySenderId else nil,
		voiceEnabled = p18.Voice.isEnabled,
		characters = if not getFFlagUseCharacterStore() then p18.Players.charactersByUserId else nil,
		voiceParticipants = if not GetFFlagExpChatUseVoiceParticipantsStore() then p18.Voice.participants else nil,
		mockUserIdToPartOrModel = mockUserIdToPartOrModel
	}
end

if getFFlagUseCharacterStore() or GetFFlagExpChatUseVoiceParticipantsStore() then
	local v28 = RoactRodux.connect(mapStateToProps)(v23)

	if v21 then
		return (React.memo(withSignalsData(v28)))
	end

	return (withSignalsData(v28))
end

if v21 then
	return (React.memo(RoactRodux.connect(mapStateToProps)(v23)))
end

return (RoactRodux.connect(mapStateToProps)(v23))
