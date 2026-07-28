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
local FFlagEnableTiltLoadingScreen = require(Parent.SharedFlags).FFlagEnableTiltLoadingScreen
local FFlagIncreaseLoadingScreenOrder = require(Parent.SharedFlags).FFlagIncreaseLoadingScreenOrder
local ContextActionService = game:GetService("ContextActionService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ANIMATION = Constants.ANIMATION
local v19 = Motion.createState({
	reveal = 1
}, {
	default = Motion.transition({
		duration = ANIMATION.chromeFadeIn
	})
})
local v20 = Motion.createState({
	reveal = 0
}, {
	default = Motion.transition({
		duration = ANIMATION.closeDur
	})
})

require(script.Parent.Types)

local function TiltLoadingScreenContainer(p1) -- line: 40
	-- upvalues: FFlagEnableTiltLoadingScreen (copy), React (copy), ReplicatedFirst (copy), UserGameSettings (copy), Motion (copy), v19 (copy), useTiltLoadingScreenViewModel (copy), useLoadingScreenAnimation (copy), InExperienceLocales (copy), LocalizationService (copy), v20 (copy), ANIMATION (copy), Players (copy), ContextActionService (copy), FFlagIncreaseLoadingScreenOrder (copy), Constants (copy), Foundation (copy), Localization (copy), TiltLoadingScreenView (copy)
	if not FFlagEnableTiltLoadingScreen then
		return nil
	end

	local v23, v24 = React.useState(function() -- line: 45
		-- upvalues: ReplicatedFirst (copy)
		return not ReplicatedFirst:IsDefaultLoadingGuiRemoved()
	end)
	local v25, v26 = React.useState(false)
	local ReducedMotion = UserGameSettings.ReducedMotion
	local v28, v29 = Motion.useMotion(v19)
	local v30 = React.useRef(v29)

	v30.current = v29

	local v31 = React.useRef(p1.onDismissComplete)

	v31.current = p1.onDismissComplete

	local v32 = React.useRef(p1.onCancel)

	v32.current = p1.onCancel

	local v33 = useTiltLoadingScreenViewModel(p1.placeId)
	local v34 = useLoadingScreenAnimation({
		reducedMotion = ReducedMotion,
		contentReady = v33.gameData ~= nil,
		isDismissing = v25
	})
	local v35 = React.useMemo(function() -- line: 63
		-- upvalues: InExperienceLocales (copy), LocalizationService (copy)
		return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function() -- line: 67
		-- upvalues: v26 (copy), v30 (copy), v20 (copy), ANIMATION (copy), ReplicatedFirst (copy), v24 (copy), v31 (copy), UserGameSettings (copy), Players (copy)
		local t1 = {}
		local u40 = false
		local u41 = false
		local u42 = nil
		local u43 = nil
		local u44 = nil

		local function dismiss() -- line: 75
			-- upvalues: u40 (ref), v26 (copy), u42 (ref), u41 (ref), v30 (copy), v20 (copy), u43 (ref), ANIMATION (copy), ReplicatedFirst (copy), v24 (copy), v31 (copy), UserGameSettings (copy)
			if u40 then
				return
			end

			u40 = true
			v26(true)

			local function fadeChrome() -- line: 82
				-- upvalues: u42 (ref), u41 (ref), v30 (copy), v20 (copy), u43 (ref), ANIMATION (copy), ReplicatedFirst (copy), v24 (copy), v31 (copy)
				u42 = nil

				if u41 then
					return
				end

				v30.current(v20, {
					onAnimationComplete = function(p2) -- line: 88
						-- upvalues: u41 (ref), u43 (ref), ANIMATION (copy), ReplicatedFirst (copy), v24 (copy), v31 (copy)
						if p2 ~= true or u41 then
							return
						end

						u43 = task.delay(ANIMATION.endPause, function() -- line: 92
							-- upvalues: u43 (ref), u41 (ref), ReplicatedFirst (copy), v24 (copy), v31 (copy)
							u43 = nil

							if u41 then
								return
							end

							ReplicatedFirst:SetDefaultLoadingGuiRemoved()
							v24(false)

							if v31.current then
								v31.current()
							end
						end)
					end
				})
			end

			if UserGameSettings.ReducedMotion then
				fadeChrome()

				return
			end

			u42 = task.delay(ANIMATION.closeDur, fadeChrome)
		end
		local function waitForCharacterAndDismiss() -- line: 114
			-- upvalues: u44 (ref), Players (copy), u41 (ref), dismiss (copy)
			if u44 then
				return
			end

			u44 = task.spawn(function() -- line: 118
				-- upvalues: Players (copy), u44 (ref), u41 (ref), dismiss (copy)
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

				u44 = nil

				if u41 then
					return
				end

				dismiss()
			end)
		end
		local function handleFinishedReplicating() -- line: 137
			-- upvalues: u44 (ref), Players (copy), u41 (ref), dismiss (copy), t1 (copy)
			if game:IsLoaded() then
				if u44 then
					return
				end

				u44 = task.spawn(function() -- line: 118
					-- upvalues: Players (copy), u44 (ref), u41 (ref), dismiss (copy)
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

					u44 = nil

					if u41 then
						return
					end

					dismiss()
				end)

				return
			end

			local connection = nil

			connection = game.Loaded:Connect(function() -- line: 142
				-- upvalues: connection (ref), u44 (ref), Players (copy), u41 (ref), dismiss (copy)
				connection:Disconnect()

				if u44 then
					return
				end

				u44 = task.spawn(function() -- line: 118
					-- upvalues: Players (copy), u44 (ref), u41 (ref), dismiss (copy)
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

					u44 = nil

					if u41 then
						return
					end

					dismiss()
				end)
			end)
			table.insert(t1, connection)
		end

		table.insert(t1, ReplicatedFirst.FinishedReplicating:Connect(handleFinishedReplicating))
		table.insert(t1, ReplicatedFirst.RemoveDefaultLoadingGuiSignal:Connect(function() -- line: 153
			-- upvalues: dismiss (copy)
			dismiss()
		end))

		if ReplicatedFirst:IsFinishedReplicating() then
			handleFinishedReplicating()
		end

		if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
			dismiss()
		end

		return function() -- line: 166
			-- upvalues: u41 (ref), u42 (ref), u43 (ref), u44 (ref), t1 (copy)
			u41 = true

			if u42 then
				task.cancel(u42)
			end

			if u43 then
				task.cancel(u43)
			end

			if u44 and coroutine.status(u44) ~= "dead" then
				task.cancel(u44)
			end

			for _, v52 in t1 do
				v52:Disconnect()
			end
		end
	end, {})
	React.useEffect(function() -- line: 182
		-- upvalues: ContextActionService (copy), v32 (copy)
		local u48 = false

		ContextActionService:BindCoreAction("CancelGameLoad", function(_, p4) -- line: 184
			-- upvalues: u48 (ref), v32 (copy)
			if p4 == Enum.UserInputState.Begin then
				u48 = true

				return
			end

			if p4 == Enum.UserInputState.End and u48 then
				u48 = false

				if v32.current then
					v32.current(false)
				end
			end
		end, false, Enum.KeyCode.ButtonB)

		return function() -- line: 195
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("CancelGameLoad")
		end
	end, {})

	local v36 = React.useMemo(function() -- line: 199
		-- upvalues: ReducedMotion (copy)
		return {
			reducedMotion = ReducedMotion
		}
	end, { ReducedMotion })
	local v37 = React.useCallback(function() -- line: 202
		-- upvalues: v32 (copy)
		if v32.current then
			v32.current(true)
		end
	end, {})

	if not v23 then
		return nil
	end

	local v38 = if not FFlagIncreaseLoadingScreenOrder then Constants.DISPLAY_ORDER else Constants.DISPLAY_ORDER + 1

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		DisplayOrder = v38,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Foundation = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark,
			preferences = v36
		}, {
			Localization = React.createElement(Localization.LocalizationProvider, {
				localization = v35
			}, {
				View = React.createElement(TiltLoadingScreenView, {
					isMobile = v33.isMobile,
					chromeReveal = v28.reveal,
					animation = v34,
					gameData = v33.gameData,
					thumbnailUrl = v33.thumbnailUrl,
					isAutoTranslated = v33.isAutoTranslated,
					onCancel = v37
				})
			})
		})
	})
end

return TiltLoadingScreenContainer
