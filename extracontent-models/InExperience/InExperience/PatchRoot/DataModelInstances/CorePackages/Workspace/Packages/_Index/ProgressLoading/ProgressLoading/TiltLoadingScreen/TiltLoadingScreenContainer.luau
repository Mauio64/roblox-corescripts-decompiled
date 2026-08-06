local Parent = script:FindFirstAncestor("ProgressLoading").Parent
local React = require(Parent.React)
local Motion = require(Parent.Motion)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local InExperienceLocales = require(Parent.InExperienceLocales)
local TiltLoadingScreenView = require(script.Parent.TiltLoadingScreenView)
local useTiltLoadingScreenViewModel = require(script.Parent.Hooks.useTiltLoadingScreenViewModel)
local useLoadingScreenAnimation = require(script.Parent.Hooks.useLoadingScreenAnimation)
local Constants = require(script.Parent.Constants)
local shouldHoldForExit = require(script.Parent.shouldHoldForExit)
local FFlagEnableTiltLoadingScreen = require(Parent.SharedFlags).FFlagEnableTiltLoadingScreen
local FFlagIncreaseLoadingScreenOrder = require(Parent.SharedFlags).FFlagIncreaseLoadingScreenOrder
local ContextActionService = game:GetService("ContextActionService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ANIMATION = Constants.ANIMATION
local v20 = Motion.createState({
	reveal = 1
}, {
	default = Motion.transition({
		duration = ANIMATION.chromeFadeIn
	})
})
local v21 = Motion.createState({
	reveal = 0
}, {
	default = Motion.transition({
		duration = ANIMATION.closeDur
	})
})

require(script.Parent.Types)

local function TiltLoadingScreenContainer(p1) -- line: 41
	-- upvalues: FFlagEnableTiltLoadingScreen (copy), React (copy), ReplicatedFirst (copy), UserGameSettings (copy), Motion (copy), v20 (copy), useTiltLoadingScreenViewModel (copy), useLoadingScreenAnimation (copy), InExperienceLocales (copy), LocalizationService (copy), shouldHoldForExit (copy), ANIMATION (copy), v21 (copy), Players (copy), ContextActionService (copy), FFlagIncreaseLoadingScreenOrder (copy), Constants (copy), Foundation (copy), Localization (copy), TiltLoadingScreenView (copy)
	if not FFlagEnableTiltLoadingScreen then
		return nil
	end

	local v24, v25 = React.useState(function() -- line: 46
		-- upvalues: ReplicatedFirst (copy)
		return not ReplicatedFirst:IsDefaultLoadingGuiRemoved()
	end)
	local v26, v27 = React.useState(false)
	local ReducedMotion = UserGameSettings.ReducedMotion
	local v29, v30 = Motion.useMotion(v20)
	local v31 = React.useRef(v30)

	v31.current = v30

	local v32 = React.useRef(p1.onDismissComplete)

	v32.current = p1.onDismissComplete

	local v33 = React.useRef(p1.onCancel)

	v33.current = p1.onCancel

	local v34 = useTiltLoadingScreenViewModel(p1.placeId)
	local v35 = useLoadingScreenAnimation({
		reducedMotion = ReducedMotion,
		contentReady = v34.gameData ~= nil,
		isDismissing = v26
	})
	local v36 = React.useMemo(function() -- line: 64
		-- upvalues: InExperienceLocales (copy), LocalizationService (copy)
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function() -- line: 68
		-- upvalues: shouldHoldForExit (copy), UserGameSettings (copy), ANIMATION (copy), v27 (copy), v31 (copy), v21 (copy), ReplicatedFirst (copy), v25 (copy), v32 (copy), Players (copy)
		local t1 = {}
		local u41 = false
		local u42 = false
		local u43 = nil
		local u44 = nil
		local u45 = nil
		local u46 = nil
		local u47 = false

		local function dismiss() -- line: 78
			-- upvalues: u41 (ref), u47 (ref), u46 (ref), shouldHoldForExit (copy), UserGameSettings (copy), ANIMATION (copy), u42 (ref), dismiss (copy), v27 (copy), u43 (ref), v31 (copy), v21 (copy), u44 (ref), ReplicatedFirst (copy), v25 (copy), v32 (copy)
			if u41 then
				return
			end

			if u47 and u46 ~= nil then
				return
			end

			if shouldHoldForExit(UserGameSettings.ReducedMotion, u47) then
				u47 = true
				u46 = task.delay(ANIMATION.enterExitHold, function() -- line: 89
					-- upvalues: u46 (ref), u42 (ref), dismiss (copy)
					u46 = nil

					if u42 then
						return
					end

					dismiss()
				end)

				return
			end

			u41 = true
			v27(true)

			local function fadeChrome() -- line: 102
				-- upvalues: u43 (ref), u42 (ref), v31 (copy), v21 (copy), u44 (ref), ANIMATION (copy), ReplicatedFirst (copy), v25 (copy), v32 (copy)
				u43 = nil

				if u42 then
					return
				end

				v31.current(v21, {
					onAnimationComplete = function(p2) -- line: 108
						-- upvalues: u42 (ref), u44 (ref), ANIMATION (copy), ReplicatedFirst (copy), v25 (copy), v32 (copy)
						if p2 ~= true or u42 then
							return
						end

						u44 = task.delay(ANIMATION.endPause, function() -- line: 112
							-- upvalues: u44 (ref), u42 (ref), ReplicatedFirst (copy), v25 (copy), v32 (copy)
							u44 = nil

							if u42 then
								return
							end

							ReplicatedFirst:SetDefaultLoadingGuiRemoved()
							v25(false)

							if v32.current then
								v32.current()
							end
						end)
					end
				})
			end

			if UserGameSettings.ReducedMotion then
				fadeChrome()

				return
			end

			u43 = task.delay(ANIMATION.closeDur, fadeChrome)
		end
		local function waitForCharacterAndDismiss() -- line: 134
			-- upvalues: u45 (ref), Players (copy), u42 (ref), dismiss (copy)
			if u45 then
				return
			end

			u45 = task.spawn(function() -- line: 138
				-- upvalues: Players (copy), u45 (ref), u42 (ref), dismiss (copy)
				if Players.CharacterAutoLoads then
					local LocalPlayer = Players.LocalPlayer

					if not LocalPlayer then
						Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
						LocalPlayer = Players.LocalPlayer
					end

					if not LocalPlayer.Character then
						LocalPlayer.CharacterAdded:Wait()
					end
				end

				u45 = nil

				if u42 then
					return
				end

				dismiss()
			end)
		end
		local function handleFinishedReplicating() -- line: 157
			-- upvalues: u45 (ref), Players (copy), u42 (ref), dismiss (copy), t1 (copy)
			if game:IsLoaded() then
				if u45 then
					return
				end

				u45 = task.spawn(function() -- line: 138
					-- upvalues: Players (copy), u45 (ref), u42 (ref), dismiss (copy)
					if Players.CharacterAutoLoads then
						local LocalPlayer = Players.LocalPlayer

						if not LocalPlayer then
							Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
							LocalPlayer = Players.LocalPlayer
						end

						if not LocalPlayer.Character then
							LocalPlayer.CharacterAdded:Wait()
						end
					end

					u45 = nil

					if u42 then
						return
					end

					dismiss()
				end)

				return
			end

			local connection = nil

			connection = game.Loaded:Connect(function() -- line: 162
				-- upvalues: connection (ref), u45 (ref), Players (copy), u42 (ref), dismiss (copy)
				connection:Disconnect()

				if u45 then
					return
				end

				u45 = task.spawn(function() -- line: 138
					-- upvalues: Players (copy), u45 (ref), u42 (ref), dismiss (copy)
					if Players.CharacterAutoLoads then
						local LocalPlayer = Players.LocalPlayer

						if not LocalPlayer then
							Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
							LocalPlayer = Players.LocalPlayer
						end

						if not LocalPlayer.Character then
							LocalPlayer.CharacterAdded:Wait()
						end
					end

					u45 = nil

					if u42 then
						return
					end

					dismiss()
				end)
			end)
			table.insert(t1, connection)
		end

		table.insert(t1, ReplicatedFirst.FinishedReplicating:Connect(handleFinishedReplicating))
		table.insert(t1, ReplicatedFirst.RemoveDefaultLoadingGuiSignal:Connect(function() -- line: 173
			-- upvalues: dismiss (copy)
			dismiss()
		end))

		if ReplicatedFirst:IsFinishedReplicating() then
			handleFinishedReplicating()
		end

		if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
			dismiss()
		end

		return function() -- line: 186
			-- upvalues: u42 (ref), u46 (ref), u43 (ref), u44 (ref), u45 (ref), t1 (copy)
			u42 = true

			if u46 then
				task.cancel(u46)
			end

			if u43 then
				task.cancel(u43)
			end

			if u44 then
				task.cancel(u44)
			end

			if u45 and coroutine.status(u45) ~= "dead" then
				task.cancel(u45)
			end

			for _, v55 in t1 do
				v55:Disconnect()
			end
		end
	end, {})
	React.useEffect(function() -- line: 205
		-- upvalues: ContextActionService (copy), v33 (copy)
		local u51 = false

		ContextActionService:BindCoreAction("CancelGameLoad", function(_, p4) -- line: 207
			-- upvalues: u51 (ref), v33 (copy)
			if p4 == Enum.UserInputState.Begin then
				u51 = true

				return
			end

			if p4 == Enum.UserInputState.End and u51 then
				u51 = false

				if v33.current then
					v33.current(false)
				end
			end
		end, false, Enum.KeyCode.ButtonB)

		return function() -- line: 218
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("CancelGameLoad")
		end
	end, {})

	local v37 = React.useMemo(function() -- line: 222
		-- upvalues: ReducedMotion (copy)
		return {
			reducedMotion = ReducedMotion
		}
	end, { ReducedMotion })
	local v38 = React.useCallback(function() -- line: 225
		-- upvalues: v33 (copy)
		if v33.current then
			v33.current(true)
		end
	end, {})

	if not v24 then
		return nil
	end

	local v39 = if not FFlagIncreaseLoadingScreenOrder then Constants.DISPLAY_ORDER else Constants.DISPLAY_ORDER + 1

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		DisplayOrder = v39,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Foundation = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark,
			preferences = v37
		}, {
			Localization = React.createElement(Localization.LocalizationProvider, {
				localization = v36
			}, {
				View = React.createElement(TiltLoadingScreenView, {
					isMobile = v34.isMobile,
					chromeReveal = v29.reveal,
					animation = v35,
					gameData = v34.gameData,
					thumbnailUrl = v34.thumbnailUrl,
					isAutoTranslated = v34.isAutoTranslated,
					statusPanel = v34.statusPanel,
					onCancel = v38
				})
			})
		})
	})
end

return TiltLoadingScreenContainer
