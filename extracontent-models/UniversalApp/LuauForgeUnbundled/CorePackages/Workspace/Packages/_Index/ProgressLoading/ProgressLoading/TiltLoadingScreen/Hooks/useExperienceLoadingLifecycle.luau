local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Motion")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")
local shouldHoldForExit = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/shouldHoldForExit")
local fFlagLoadingScreenMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagLoadingScreenMilestones
local players = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/MockableProxyServices").Players
local replicatedFirst = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/MockableProxyServices").ReplicatedFirst
local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/MockableProxyServices").game
local UserGameSettings = UserSettings():GetService("UserGameSettings")
require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Types")

local animation = Constants.ANIMATION

local state = Motion.createState({ reveal = 1 }, {
	default = Motion.transition({ duration = animation.chromeFadeIn })
})

local state2 = Motion.createState({ reveal = 0 }, {
	default = Motion.transition({ duration = animation.closeDur })
})

local module5 = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants")
local abortReason = module5.AbortReason
local milestone = module5.Milestone
local dismissSource = module5.DismissSource
local function useExperienceLoadingLifecycle(p2, p3, current)
	local ref = if fFlagLoadingScreenMilestones then React.useRef(p3) else nil
	local state3, setState = React.useState(function(): boolean
		if p2 then
			return not replicatedFirst:IsDefaultLoadingGuiRemoved()
		end

		return true
	end)

	local state4, setState2 = React.useState(false)
	local v5, v6 = Motion.useMotion(state)
	local ref2 = React.useRef(v5.reveal)
	local ref3 = React.useRef(v6)
	ref3.current = v6
	local ref4 = React.useRef(current)
	ref4.current = current
	local ref5 = React.useRef(nil)
	local v7 = React.useCallback(function()
		if ref5.current then
			ref5.current()
		end
	end, {})

	React.useEffect(function()
		if not p2 then
			return
		end

		local current2 = if ref then ref.current else nil

		if fFlagLoadingScreenMilestones and current2 then
			current2.record(milestone.ScreenVisible)
		end

		local v8 = {}
		local flag = false
		local flag2 = false
		local thread = nil
		local thread2 = nil
		local thread3 = nil
		local flag3 = false
		local flag4 = false

		local function doDismiss()
			if fFlagLoadingScreenMilestones and current2 then
				current2.record(milestone.DismissStarted)
			end

			flag = true
			setState2(true)

			local function fadeChrome()
				thread = nil

				if flag2 then
					return
				end

				ref3.current(state2, {
					onAnimationComplete = function(p4)
						if p4 ~= true or flag2 then
							return
						end

						if fFlagLoadingScreenMilestones and current2 then
							current2.record(milestone.ScreenHidden)
						end

						replicatedFirst:SetDefaultLoadingGuiRemoved()
						setState(false)

						if fFlagLoadingScreenMilestones and current2 then
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
			if flag2 or flag then
				return
			end

			if shouldHoldForExit(UserGameSettings.ReducedMotion) then
				thread3 = task.delay(animation.enterExitHold, function()
					thread3 = nil

					if flag2 or flag then
						return
					end

					flag3 = true

					if fFlagLoadingScreenMilestones and current2 then
						current2.record(milestone.DismissGateReleased)
					end

					if flag4 then
						doDismiss()
					end
				end)
				return
			end

			flag3 = true

			if flag4 then
				doDismiss()
			end
		end

		local function dismiss()
			if flag then
				return
			end

			if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
				doDismiss()
			elseif flag3 then
				doDismiss()
			else
				flag4 = true
			end
		end

		local function waitForCharacterAndDismiss()
			if thread2 then
				return
			end

			thread2 = task.spawn(function()
				if players.CharacterAutoLoads then
					local localPlayer = players.LocalPlayer

					if not localPlayer then
						players:GetPropertyChangedSignal("LocalPlayer"):Wait()
						localPlayer = players.LocalPlayer
					end

					if not localPlayer.Character then
						localPlayer.CharacterAdded:Wait()
					end
				end

				thread2 = nil

				if flag2 then
					return
				end

				if fFlagLoadingScreenMilestones and current2 then
					current2.dismissRequested(dismissSource.NormalReady)
				end

				if flag then
					return
				end

				if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
					doDismiss()
				elseif flag3 then
					doDismiss()
				else
					flag4 = true
				end
			end)
		end

		local function handleFinishedReplicating()
			if Game:IsLoaded() then
				if thread2 then
					return
				end

				thread2 = task.spawn(function()
					if players.CharacterAutoLoads then
						local localPlayer = players.LocalPlayer

						if not localPlayer then
							players:GetPropertyChangedSignal("LocalPlayer"):Wait()
							localPlayer = players.LocalPlayer
						end

						if not localPlayer.Character then
							localPlayer.CharacterAdded:Wait()
						end
					end

					thread2 = nil

					if flag2 then
						return
					end

					if fFlagLoadingScreenMilestones and current2 then
						current2.dismissRequested(dismissSource.NormalReady)
					end

					if flag then
						return
					end

					if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
						doDismiss()
					elseif flag3 then
						doDismiss()
					else
						flag4 = true
					end
				end)
			else
				local loadedConnection = nil
				loadedConnection = Game.Loaded:Connect(function()
					loadedConnection:Disconnect()

					if thread2 then
						return
					end

					thread2 = task.spawn(function()
						if players.CharacterAutoLoads then
							local localPlayer = players.LocalPlayer

							if not localPlayer then
								players:GetPropertyChangedSignal("LocalPlayer"):Wait()
								localPlayer = players.LocalPlayer
							end

							if not localPlayer.Character then
								localPlayer.CharacterAdded:Wait()
							end
						end

						thread2 = nil

						if flag2 then
							return
						end

						if fFlagLoadingScreenMilestones and current2 then
							current2.dismissRequested(dismissSource.NormalReady)
						end

						if flag then
							return
						end

						if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
							doDismiss()
						elseif flag3 then
							doDismiss()
						else
							flag4 = true
						end
					end)
				end)
				table.insert(v8, loadedConnection)
			end
		end

		table.insert(v8, replicatedFirst.FinishedReplicating:Connect(handleFinishedReplicating))
		table.insert(v8, replicatedFirst.RemoveDefaultLoadingGuiSignal:Connect(function()
			if fFlagLoadingScreenMilestones and current2 then
				current2.dismissRequested(dismissSource.DeveloperOverride)
			end

			if flag then
				return
			end

			if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
				doDismiss()
			elseif flag3 then
				doDismiss()
			else
				flag4 = true
			end
		end))

		if replicatedFirst:IsFinishedReplicating() then
			if Game:IsLoaded() then
				if not thread2 then
					thread2 = task.spawn(function()
						if players.CharacterAutoLoads then
							local localPlayer = players.LocalPlayer

							if not localPlayer then
								players:GetPropertyChangedSignal("LocalPlayer"):Wait()
								localPlayer = players.LocalPlayer
							end

							if not localPlayer.Character then
								localPlayer.CharacterAdded:Wait()
							end
						end

						thread2 = nil

						if flag2 then
							return
						end

						if fFlagLoadingScreenMilestones and current2 then
							current2.dismissRequested(dismissSource.NormalReady)
						end

						if flag then
							return
						end

						if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
							doDismiss()
						elseif flag3 then
							doDismiss()
						else
							flag4 = true
						end
					end)
				end
			else
				local loadedConnection = nil
				loadedConnection = Game.Loaded:Connect(function()
					loadedConnection:Disconnect()

					if thread2 then
						return
					end

					thread2 = task.spawn(function()
						if players.CharacterAutoLoads then
							local localPlayer = players.LocalPlayer

							if not localPlayer then
								players:GetPropertyChangedSignal("LocalPlayer"):Wait()
								localPlayer = players.LocalPlayer
							end

							if not localPlayer.Character then
								localPlayer.CharacterAdded:Wait()
							end
						end

						thread2 = nil

						if flag2 then
							return
						end

						if fFlagLoadingScreenMilestones and current2 then
							current2.dismissRequested(dismissSource.NormalReady)
						end

						if flag then
							return
						end

						if not shouldHoldForExit(UserGameSettings.ReducedMotion) then
							doDismiss()
						elseif flag3 then
							doDismiss()
						else
							flag4 = true
						end
					end)
				end)
				table.insert(v8, loadedConnection)
			end
		end

		if replicatedFirst:IsDefaultLoadingGuiRemoved() then
			if fFlagLoadingScreenMilestones and current2 then
				current2.dismissRequested(dismissSource.DeveloperOverride)
			end

			if not flag then
				if shouldHoldForExit(UserGameSettings.ReducedMotion) then
					if flag3 then
						doDismiss()
					else
						flag4 = true
					end
				else
					doDismiss()
				end
			end
		end

		return function()
			flag2 = true

			if fFlagLoadingScreenMilestones and current2 then
				current2.abort(abortReason.Unmounted)
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

			for k, connection in v8 do
				connection:Disconnect()
			end
		end
	end, { p2 })

	local v8 = {
		isVisible = state3,
		isDismissing = state4,
		chromeReveal = ref2.current,
		onEnterComplete = v7,
		milestones = 0
	}

	local v9 = if ref then ref.current else nil
	v8.milestones = v9
	return v8
end

return useExperienceLoadingLifecycle
