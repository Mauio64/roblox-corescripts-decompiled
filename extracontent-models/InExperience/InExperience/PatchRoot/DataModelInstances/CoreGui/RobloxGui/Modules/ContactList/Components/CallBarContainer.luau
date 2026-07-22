local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Workspace = game:GetService("Workspace")
local v4 = game:DefineFastFlag("FixContactListNilCamera", false)
local v5 = if not v4 then Workspace.CurrentCamera else Workspace.CurrentCamera

local function getViewportSize() -- line: 9
	-- upvalues: v4 (copy), v5 (copy)
	if v4 then
		if v5 then
			return v5.ViewportSize
		end

		return Vector2.new(0, 0)
	end

	return v5.ViewportSize
end

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local CallProtocol = require(CorePackages.Workspace.Packages.CallProtocol)
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Chrome = RobloxGui.Modules.Chrome
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local v17 = if not Enabled() then nil else require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local TopBar = RobloxGui.Modules.TopBar
local Constants2 = require(TopBar.Constants)
local ContactList = RobloxGui.Modules.ContactList
local dependencies = require(ContactList.dependencies)
local RoduxCall = dependencies.RoduxCall
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local CallAction = RoduxCall.Enums.CallAction
local scriptParent = script.Parent
local CallBar = require(scriptParent.CallBar)
local vector2 = Vector2.new(200, 44)
local t1 = {
	callProtocol = CallProtocol.CallProtocol.default
}
local _ = {
	On = "On",
	Off = "Off"
}

local function CallBarContainer(t2: {[any]: any}) -- line: 67
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), Constants2 (copy), React (copy), ReactOtter (copy), v4 (copy), v5 (copy), vector2 (copy), Enabled (copy), v17 (copy), Constants (copy), useSelector (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), RoduxCall (copy), CallAction (copy), CallBar (copy)
	local v34 = Cryo.Dictionary.join(t1, t2)
	local v35 = useDispatch()
	local v36 = Constants2.useDisplayScaleState(Constants2.TopBarButtonPadding)
	local v37 = Constants2.useDisplayScaleState(Constants2.TopBarTopMargin)
	local v38, v39 = React.useState(false)
	local v40, v41 = ReactOtter.useAnimatedBinding({
		X = ((if not v4 then v5.ViewportSize else (if not v5 then Vector2.new(0, 0) else v5.ViewportSize))).X / 2 - vector2.X / 2,
		Y = -vector2.Y
	}, function(p1) -- line: 80
		-- upvalues: vector2 (copy), v38 (copy), v39 (copy)
		if p1.Y == -vector2.Y and v38 then
			v39(false)
		end
	end)
	local u42 = v41
	local v43 = React.useCallback(function(s1: string) -- line: 95
		-- upvalues: v4 (copy), v5 (copy), vector2 (copy), Enabled (copy), v37 (copy), v36 (copy), v17 (copy), Constants2 (copy), u42 (ref), ReactOtter (copy), Constants (copy)
		local v54 = ((if not v4 then v5.ViewportSize else (if not v5 then Vector2.new(0, 0) else v5.ViewportSize))).X / 2 - vector2.X / 2
		local v55 = if s1 ~= "On" then -vector2.Y else not Enabled() and 4 or v37 + v36

		if Enabled() and v17 then
			local Max = v17:layout():get().Max

			if Max.X + 12 > ((if not v4 then v5.ViewportSize else (if not v5 then Vector2.new(0, 0) else v5.ViewportSize))).X / 2 - vector2.X / 2 then
				if Max.X + 24 + vector2.X > ((if not v4 then v5.ViewportSize else (if not v5 then Vector2.new(0, 0) else v5.ViewportSize))).X then
					if s1 == "On" then
						v55 = Constants2.ApplyDisplayScale(Constants2.TopBarHeight) + 10
					end
				else
					v54 = Max.X + 12
				end
			end
		end

		u42({
			X = ReactOtter.spring(v54, Constants.MENU_ANIMATION_SPRING),
			Y = ReactOtter.spring(v55, Constants.MENU_ANIMATION_SPRING)
		})
	end, {})
	local v44 = React.useCallback(function(p2) -- line: 135
		if p2.Call.currentCall ~= nil then
			return p2.Call.currentCall.status
		end

		return nil
	end, {})
	local v45 = useSelector(v44)
	local v46 = React.useCallback(function(p3) -- line: 140
		local n1 = 0

		if p3.Call.currentCall and p3.Call.currentCall.activeUtc then
			n1 = p3.Call.currentCall.activeUtc
		end

		return n1
	end)
	local v47 = useSelector(v46)
	local v48 = React.useCallback(function(p4) -- line: 149
		if p4.Call.currentCall ~= nil then
			return p4.Call.currentCall.instanceId
		end

		return nil
	end)
	local v49 = useSelector(v48)

	React.useEffect(function() -- line: 154
		-- upvalues: v34 (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v35 (copy), RoduxCall (copy)
		local v61 = v34.callProtocol:listenToHandleConnectingCall(function(p5) -- line: 157
			-- upvalues: SoundManager (copy), Sounds (copy), SoundGroups (copy), v35 (copy), RoduxCall (copy)
			SoundManager:PlaySound(Sounds.Ringtone.Name, {
				Volume = 0.5,
				Looped = true
			}, SoundGroups.Iris)
			v35(RoduxCall.Actions.UpdateCall(p5))
		end)
		local v62 = v34.callProtocol:listenToHandleTeleportingCall(function(p6) -- line: 163
			-- upvalues: SoundManager (copy), Sounds (copy), SoundGroups (copy), v35 (copy), RoduxCall (copy)
			SoundManager:StopSound(Sounds.Ringtone.Name)
			SoundManager:PlaySound(Sounds.CallAccept.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
			v35(RoduxCall.Actions.UpdateCall(p6))
		end)
		local v63 = v34.callProtocol:listenToHandleActiveCall(function(p7) -- line: 169
			-- upvalues: v35 (copy), RoduxCall (copy)
			v35(RoduxCall.Actions.UpdateCall(p7))
		end)
		local v64 = v34.callProtocol:listenToHandleTransferCallTeleportJoin(function() -- line: 173
			-- upvalues: v34 (copy), v35 (copy), RoduxCall (copy)
			v34.callProtocol:getCallState():andThen(function(p8) -- line: 176
				-- upvalues: v35 (copy), RoduxCall (copy)
				v35(RoduxCall.Actions.UpdateCall(p8))
			end)
		end)

		v34.callProtocol:getCallState():andThen(function(p9) -- line: 181
			-- upvalues: v35 (copy), RoduxCall (copy)
			v35(RoduxCall.Actions.UpdateCall(p9))
		end)

		return function() -- line: 185
			-- upvalues: v61 (copy), v62 (copy), v63 (copy), v64 (copy)
			v61:Disconnect()
			v62:Disconnect()
			v63:Disconnect()
			v64:Disconnect()
		end
	end, { v34.callProtocol })

	local v50, v51 = React.useState(nil)

	if Enabled() and v17 then
		React.useEffect(function() -- line: 195
			-- upvalues: v17 (copy), v51 (copy)
			local v65 = v17:layout():connect(function(p10) -- line: 197
				-- upvalues: v51 (copy)
				v51(p10)
			end)

			return function() -- line: 201
				-- upvalues: v65 (copy)
				v65.disconnect()
			end
		end, {})
	end

	React.useEffect(function() -- line: 207
		-- upvalues: v45 (copy), RoduxCall (copy), v49 (copy), v39 (copy), v43 (copy), v4 (copy), v5 (copy)
		local v66 = v45 == RoduxCall.Enums.Status.Connecting or (v45 == RoduxCall.Enums.Status.Teleporting or (v45 == RoduxCall.Enums.Status.Active or v45 == RoduxCall.Enums.Status.Idle and game.JobId == v49))

		if v66 then
			v39(true)
		end

		v43(not v66 and "Off" or "On")

		local u67 = if not v4 then v5:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 228
			-- upvalues: v43 (copy), v66 (copy)
			v43(not v66 and "Off" or "On")
		end) else if not v5 then nil else v5:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 223
			-- upvalues: v43 (copy), v66 (copy)
			v43(not v66 and "Off" or "On")
		end)

		return function() -- line: 233
			-- upvalues: u67 (ref)
			if u67 then
				u67:Disconnect()
			end
		end
	end, {
		v45,
		v49,
		v50
	})
	React.useEffect(function() -- line: 244
		-- upvalues: v34 (copy), CallAction (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v35 (copy), RoduxCall (copy)
		local v68 = v34.callProtocol:listenToHandleEndCall(function(p11) -- line: 245
			-- upvalues: CallAction (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v35 (copy), RoduxCall (copy)
			if p11.callAction == CallAction.Cancel then
				SoundManager:StopSound(Sounds.Ringtone.Name)
				SoundManager:PlaySound(Sounds.HangUp.Name, {
					Volume = 0.5
				}, SoundGroups.Iris)
			elseif p11.callAction == CallAction.Decline then
				SoundManager:StopSound(Sounds.Ringtone.Name)
				SoundManager:PlaySound(Sounds.CallDecline.Name, {
					Volume = 0.5
				}, SoundGroups.Iris)
			elseif p11.callAction == CallAction.Finish then
				SoundManager:PlaySound(Sounds.HangUp.Name, {
					Volume = 0.5
				}, SoundGroups.Iris)
			end

			v35(RoduxCall.Actions.UpdateCall(p11))
		end)

		return function() -- line: 259
			-- upvalues: v68 (copy)
			v68:Disconnect()
		end
	end, { v34.callProtocol })

	return if not v38 then nil else React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}, {
		CallBar = React.createElement(CallBar, {
			size = vector2,
			activeUtc = v47,
			position = v40:map(function(p12) -- line: 273
				return UDim2.fromOffset(math.round(p12.X), (math.round(p12.Y)))
			end)
		})
	})
end

return CallBarContainer
