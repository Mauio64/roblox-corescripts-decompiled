local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local CurrentCamera = game:GetService("Workspace").CurrentCamera
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
local v14 = if not Enabled() then nil else require(Chrome.Service)
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

local function CallBarContainer(t2: {[any]: any}) -- line: 56
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), Constants2 (copy), React (copy), ReactOtter (copy), CurrentCamera (copy), vector2 (copy), Enabled (copy), v14 (copy), Constants (copy), useSelector (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), RoduxCall (copy), CallAction (copy), CallBar (copy)
	local v31 = Cryo.Dictionary.join(t1, t2)
	local v32 = useDispatch()
	local v33 = Constants2.useDisplayScaleState(Constants2.TopBarButtonPadding)
	local v34 = Constants2.useDisplayScaleState(Constants2.TopBarTopMargin)
	local v35, v36 = React.useState(false)
	local v37, v38 = ReactOtter.useAnimatedBinding({
		X = CurrentCamera.ViewportSize.X / 2 - vector2.X / 2,
		Y = -vector2.Y
	}, function(p1) -- line: 69
		-- upvalues: vector2 (copy), v35 (copy), v36 (copy)
		if p1.Y == -vector2.Y and v35 then
			v36(false)
		end
	end)
	local u39 = v38
	local v40 = React.useCallback(function(s1: string) -- line: 84
		-- upvalues: CurrentCamera (copy), vector2 (copy), Enabled (copy), v34 (copy), v33 (copy), v14 (copy), Constants2 (copy), u39 (ref), ReactOtter (copy), Constants (copy)
		local v51 = CurrentCamera.ViewportSize.X / 2 - vector2.X / 2
		local v52 = if s1 ~= "On" then -vector2.Y else not Enabled() and 4 or v34 + v33

		if Enabled() and v14 then
			local Max = v14:layout():get().Max

			if Max.X + 12 > CurrentCamera.ViewportSize.X / 2 - vector2.X / 2 then
				if Max.X + 24 + vector2.X > CurrentCamera.ViewportSize.X then
					if s1 == "On" then
						v52 = Constants2.ApplyDisplayScale(Constants2.TopBarHeight) + 10
					end
				else
					v51 = Max.X + 12
				end
			end
		end

		u39({
			X = ReactOtter.spring(v51, Constants.MENU_ANIMATION_SPRING),
			Y = ReactOtter.spring(v52, Constants.MENU_ANIMATION_SPRING)
		})
	end, {})
	local v41 = React.useCallback(function(p2) -- line: 124
		if p2.Call.currentCall ~= nil then
			return p2.Call.currentCall.status
		end

		return nil
	end, {})
	local v42 = useSelector(v41)
	local v43 = React.useCallback(function(p3) -- line: 129
		local n1 = 0

		if p3.Call.currentCall and p3.Call.currentCall.activeUtc then
			n1 = p3.Call.currentCall.activeUtc
		end

		return n1
	end)
	local v44 = useSelector(v43)
	local v45 = React.useCallback(function(p4) -- line: 138
		if p4.Call.currentCall ~= nil then
			return p4.Call.currentCall.instanceId
		end

		return nil
	end)
	local v46 = useSelector(v45)

	React.useEffect(function() -- line: 143
		-- upvalues: v31 (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v32 (copy), RoduxCall (copy)
		local v58 = v31.callProtocol:listenToHandleConnectingCall(function(p5) -- line: 146
			-- upvalues: SoundManager (copy), Sounds (copy), SoundGroups (copy), v32 (copy), RoduxCall (copy)
			SoundManager:PlaySound(Sounds.Ringtone.Name, {
				Volume = 0.5,
				Looped = true
			}, SoundGroups.Iris)
			v32(RoduxCall.Actions.UpdateCall(p5))
		end)
		local v59 = v31.callProtocol:listenToHandleTeleportingCall(function(p6) -- line: 152
			-- upvalues: SoundManager (copy), Sounds (copy), SoundGroups (copy), v32 (copy), RoduxCall (copy)
			SoundManager:StopSound(Sounds.Ringtone.Name)
			SoundManager:PlaySound(Sounds.CallAccept.Name, {
				Volume = 0.5
			}, SoundGroups.Iris)
			v32(RoduxCall.Actions.UpdateCall(p6))
		end)
		local v60 = v31.callProtocol:listenToHandleActiveCall(function(p7) -- line: 158
			-- upvalues: v32 (copy), RoduxCall (copy)
			v32(RoduxCall.Actions.UpdateCall(p7))
		end)
		local v61 = v31.callProtocol:listenToHandleTransferCallTeleportJoin(function() -- line: 162
			-- upvalues: v31 (copy), v32 (copy), RoduxCall (copy)
			v31.callProtocol:getCallState():andThen(function(p8) -- line: 165
				-- upvalues: v32 (copy), RoduxCall (copy)
				v32(RoduxCall.Actions.UpdateCall(p8))
			end)
		end)

		v31.callProtocol:getCallState():andThen(function(p9) -- line: 170
			-- upvalues: v32 (copy), RoduxCall (copy)
			v32(RoduxCall.Actions.UpdateCall(p9))
		end)

		return function() -- line: 174
			-- upvalues: v58 (copy), v59 (copy), v60 (copy), v61 (copy)
			v58:Disconnect()
			v59:Disconnect()
			v60:Disconnect()
			v61:Disconnect()
		end
	end, { v31.callProtocol })

	local v47, v48 = React.useState(nil)

	if Enabled() and v14 then
		React.useEffect(function() -- line: 184
			-- upvalues: v14 (copy), v48 (copy)
			local v62 = v14:layout():connect(function(p10) -- line: 186
				-- upvalues: v48 (copy)
				v48(p10)
			end)

			return function() -- line: 190
				-- upvalues: v62 (copy)
				v62.disconnect()
			end
		end, {})
	end

	React.useEffect(function() -- line: 196
		-- upvalues: v42 (copy), RoduxCall (copy), v46 (copy), v36 (copy), v40 (copy), CurrentCamera (copy)
		local v63 = v42 == RoduxCall.Enums.Status.Connecting or (v42 == RoduxCall.Enums.Status.Teleporting or (v42 == RoduxCall.Enums.Status.Active or v42 == RoduxCall.Enums.Status.Idle and game.JobId == v46))

		if v63 then
			v36(true)
		end

		v40(not v63 and "Off" or "On")

		local connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 209
			-- upvalues: v40 (copy), v63 (copy)
			v40(not v63 and "Off" or "On")
		end)

		return function() -- line: 213
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v42,
		v46,
		v47
	})
	React.useEffect(function() -- line: 222
		-- upvalues: v31 (copy), CallAction (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v32 (copy), RoduxCall (copy)
		local v65 = v31.callProtocol:listenToHandleEndCall(function(p11) -- line: 223
			-- upvalues: CallAction (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), v32 (copy), RoduxCall (copy)
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

			v32(RoduxCall.Actions.UpdateCall(p11))
		end)

		return function() -- line: 237
			-- upvalues: v65 (copy)
			v65:Disconnect()
		end
	end, { v31.callProtocol })

	return if not v35 then nil else React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}, {
		CallBar = React.createElement(CallBar, {
			size = vector2,
			activeUtc = v44,
			position = v37:map(function(p12) -- line: 251
				return UDim2.fromOffset(math.round(p12.X), (math.round(p12.Y)))
			end)
		})
	})
end

return CallBarContainer
