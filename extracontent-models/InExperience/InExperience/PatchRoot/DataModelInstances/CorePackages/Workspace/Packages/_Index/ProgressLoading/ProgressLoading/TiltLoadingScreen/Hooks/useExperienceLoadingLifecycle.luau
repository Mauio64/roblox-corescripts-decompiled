local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local React = require(parent.React)
local Motion = require(parent.Motion)
local Constants = require(script.Parent.Parent.Constants)
local shouldHoldForExit = require(script.Parent.Parent.shouldHoldForExit)
local SharedFlags = require(parent.SharedFlags)
local FFlagLoadingScreenMilestones = SharedFlags.FFlagLoadingScreenMilestones
local MockableProxyServices = require(parent.MockableProxyServices)
local Players = MockableProxyServices.Players
local MockableProxyServices2 = require(parent.MockableProxyServices)
local ReplicatedFirst = MockableProxyServices2.ReplicatedFirst
local MockableProxyServices3 = require(parent.MockableProxyServices)
local Game = MockableProxyServices3.game
local UserGameSettings = UserSettings():GetService("UserGameSettings")
require(ProgressLoading.LoadingScreenMilestones.Types)

local animation = Constants.ANIMATION

local state = Motion.createState({ reveal = 1 }, {
	default = Motion.transition({ duration = animation.chromeFadeIn })
})

local state2 = Motion.createState({ reveal = 0 }, {
	default = Motion.transition({ duration = animation.closeDur })
})

local Constants2 = require(ProgressLoading.LoadingScreenMilestones.Constants)
local AbortReason = Constants2.AbortReason
local Milestone = Constants2.Milestone
local DismissSource = Constants2.DismissSource
local function useExperienceLoadingLifecycle(flag: boolean, p, current)
	local ref

	if FFlagLoadingScreenMilestones then
		ref = React.useRef(p)
	else
		ref = nil
	end

	local state3, setState = React.useState(function(): boolean
		return not flag or not ReplicatedFirst:IsDefaultLoadingGuiRemoved()
	end)

	local state4, setState2 = React.useState(false)
	local v, current3 = Motion.useMotion(state)
	local ref2 = React.useRef(v.reveal)
	local ref3 = React.useRef(current3)
	ref3.current = current3
	local ref4 = React.useRef(current)
	ref4.current = current
	local ref5 = React.useRef(nil)
	local onEnterComplete = React.useCallback(function()
		if ref5.current then
			ref5.current()
		end
	end, {})

	React.useEffect(function()
		if not flag then
			return
		end

		local current2

		if ref then
			current2 = ref.current
		else
			current2 = nil
		end

		if FFlagLoadingScreenMilestones and current2 then
			current2.record(Milestone.ScreenVisible)
		end

		local v2 = {}
		local flag2 = false
		local flag3 = false
		local thread = nil
		local thread2 = nil
		local thread3 = nil
		local flag4 = false
		local flag5 = false

		local function doDismiss()
			if FFlagLoadingScreenMilestones and current2 then
				current2.record(Milestone.DismissStarted)
			end

			flag2 = true
			setState2(true)

			local function fadeChrome()
				thread = nil

				if flag3 then
					return
				end

				ref3.current(state2, {
					onAnimationComplete = function(p2)
						if p2 ~= true or flag3 then
							return
						end

						if FFlagLoadingScreenMilestones and current2 then
							current2.record(Milestone.ScreenHidden)
						end

						ReplicatedFirst:SetDefaultLoadingGuiRemoved()
						setState(false)

						if FFlagLoadingScreenMilestones and current2 then
							current2.complete()
						end

						if ref4.current then
							ref4.current()
						end
					end
				})
			end

			if UserGameSettings.ReducedMotion then
				fadeChrome()
			else
				thread = task.delay(animation.closeDur, fadeChrome)
			end
		end

		function ref5.current()
			if flag3 or flag2 then
				return
			end

			if shouldHoldForExit(UserGameSettings.ReducedMotion) then
				thread3 = task.delay(animation.enterExitHold, function()
					thread3 = nil

					if flag3 or flag2 then
						return
					end

					flag4 = true

					if FFlagLoadingScreenMilestones and current2 then
						current2.record(Milestone.DismissGateReleased)
					end

					if flag5 then
						doDismiss()
					end
				end)
				return
			end

			flag4 = true

			if flag5 then
				doDismiss()
			end
		end

		local function dismiss() -- 4 equivalent calls inferred from this helper
			if flag2 then
				return
			end

			if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
				doDismiss()
			elseif flag4 then
				doDismiss()
			else
				flag5 = true
			end
		end

		local function waitForCharacterAndDismiss() -- 3 equivalent calls inferred from this helper
			if thread2 then
				return
			end

			thread2 = task.spawn(function()
				if Players.CharacterAutoLoads then
					local localPlayer = Players.LocalPlayer

					if not localPlayer then
						Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
						localPlayer = Players.LocalPlayer
					end

					if not localPlayer.Character then
						localPlayer.CharacterAdded:Wait()
					end
				end

				thread2 = nil

				if flag3 then
					return
				end

				if FFlagLoadingScreenMilestones and current2 then
					current2.dismissRequested(DismissSource.NormalReady)
				end

				dismiss() -- inferred equivalent call
			end)
		end

		local function handleFinishedReplicating()
			if Game:IsLoaded() then
				waitForCharacterAndDismiss() -- inferred equivalent call
			else
				local loadedConnection = nil
				loadedConnection = Game.Loaded:Connect(function()
					loadedConnection:Disconnect()
					waitForCharacterAndDismiss() -- inferred equivalent call
				end)
				table.insert(v2, loadedConnection)
			end
		end

		table.insert(v2, ReplicatedFirst.FinishedReplicating:Connect(handleFinishedReplicating))
		table.insert(v2, ReplicatedFirst.RemoveDefaultLoadingGuiSignal:Connect(function()
			if FFlagLoadingScreenMilestones and current2 then
				current2.dismissRequested(DismissSource.DeveloperOverride)
			end

			dismiss() -- inferred equivalent call
		end))

		if ReplicatedFirst:IsFinishedReplicating() then
			if Game:IsLoaded() then
				if not thread2 then
					thread2 = task.spawn(function()
						if Players.CharacterAutoLoads then
							local localPlayer = Players.LocalPlayer

							if not localPlayer then
								Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
								localPlayer = Players.LocalPlayer
							end

							if not localPlayer.Character then
								localPlayer.CharacterAdded:Wait()
							end
						end

						thread2 = nil

						if flag3 then
							return
						end

						if FFlagLoadingScreenMilestones and current2 then
							current2.dismissRequested(DismissSource.NormalReady)
						end

						dismiss() -- inferred equivalent call
					end)
				end
			else
				local loadedConnection = nil
				loadedConnection = Game.Loaded:Connect(function()
					loadedConnection:Disconnect()
					waitForCharacterAndDismiss() -- inferred equivalent call
				end)
				table.insert(v2, loadedConnection)
			end
		end

		if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
			if FFlagLoadingScreenMilestones and current2 then
				current2.dismissRequested(DismissSource.DeveloperOverride)
			end

			dismiss() -- inferred equivalent call
		end

		return function()
			flag3 = true

			if FFlagLoadingScreenMilestones and current2 then
				current2.abort(AbortReason.Unmounted)
			end

			ref5.current = nil

			if thread3 then
				task.cancel(thread3)
			end

			if thread then
				task.cancel(thread)
			end

			if thread2 and coroutine.status(thread2) ~= "dead" then
				task.cancel(thread2)
			end

			for _, connection in v2 do
				connection:Disconnect()
			end
		end
	end, { flag })

	local v2 = {
		isVisible = state3,
		isDismissing = state4,
		chromeReveal = ref2.current,
		onEnterComplete = onEnterComplete,
		milestones = 0
	}
	local milestones

	if ref then
		milestones = ref.current
	end

	v2.milestones = milestones
	return v2
end

return useExperienceLoadingLifecycle
