local CorePackages = game:GetService("CorePackages")
local TeleportService = game:GetService("TeleportService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local Localization = require(CorePackages.Workspace.Packages.Localization)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local Traversal = CoreScriptsRoactCommon.Traversal
local DataHydrationTypes = DataHydration.DataHydrationTypes
local getGameInfoStore = DataHydration.Game.getGameInfoStore
local Constants = Traversal.Constants
local TeleportBackButton = Traversal.TeleportBackButton
local TraversalTelemetry = Traversal.TraversalTelemetry
local useHistoryItems = Traversal.useHistoryItems
local useLocalization = Localization.Hooks.useLocalization

local FFlagUseTeleportTraversalHistory = Traversal.Flags.FFlagUseTeleportTraversalHistory
local FFlagUseLocalTraversalHistory = Traversal.Flags.FFlagUseLocalTraversalHistory
local FFlagAddTraversalBackButtonAnimation = Traversal.Flags.FFlagAddTraversalBackButtonAnimation
local defineFastFlag = game:DefineFastFlag("FixTraversalBackButtonAnimation", false)

local function TraversalBackButton(_)
	local v = useTokens()
	local ref = React.useRef(nil)
	local thirdPartyTeleportInfo, v2 = TeleportService:GetThirdPartyTeleportInfo(false)

	if thirdPartyTeleportInfo <= Constants.NO_UNIVERSE_ID or v2 <= Constants.NO_PLACE_ID then
		return nil
	end

	local state, setState = React.useState(false)
	React.useEffect(function()
		local connection = SettingsShowSignal:connect(function(p)
			setState(p)
		end)
		return function()
			connection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if state then
			TraversalTelemetry.sendBackButtonActionEvent({
				integration_id = "back_button",
				destination_universe_id = thirdPartyTeleportInfo,
				event_type = "impression"
			})
		end
	end, { state, thirdPartyTeleportInfo })

	local v3 = useLocalization({
		defaultBackButtonText = "CoreScripts.TopBar.Traversal.BackButtonDefault"
	})

	local v4 = React.useCallback(function(p)
		local fetchGameInfo = getGameInfoStore(p).getAndFetchGameInfo((tostring(thirdPartyTeleportInfo)))
		local data = fetchGameInfo.data(p)
		local status = fetchGameInfo.status(p)

		if data and status == DataHydrationTypes.DataStatus.Ready then
			return data.name
		end

		return v3.defaultBackButtonText
	end, { thirdPartyTeleportInfo, getGameInfoStore })
	local v5 = SignalsReact.useSignalState(v4)
	local ref2

	if defineFastFlag then
		ref2 = React.useRef(nil)
	else
		ref2 = nil
	end

	local textLimitWidth = v.Size.Size_2500 * 2
	local ref3 = nil
	local ref4 = nil
	local ref5 = nil
	local v6 = nil
	local v7 = nil
	local v8, v9

	if FFlagAddTraversalBackButtonAnimation then
		ref3 = React.useRef(nil)
		ref4 = React.useRef(nil)

		if defineFastFlag then
			ref5 = React.useRef(nil)
		end

		local v10 = React.useMemo(function()
			return { duration = v.Time.Time_300, easingStyle = v.Ease.StandardOut }
		end, { v })
		local v11
		v6, v11 = ReactOtter.useAnimatedBinding(0, function(p: number)
			ref3.current = nil

			if defineFastFlag then
				if not ref5.current and ref4.current and p == 1 then
					ref5.current = ref4.current
				end

				if p == 0 then
					ref4.current = 0
				end
			else
				ref4.current = nil
			end
		end)
		v7 = v11

		React.useEffect(function()
			if state then
				if defineFastFlag then
					if ref2.current == v5 then
						v7(ReactOtter.ease(1, v10))
					else
						ref5.current = nil
						ref2.current = v5

						if ref.current then
							v7(ReactOtter.ease(0.99, v10))
						end
					end
				else
					v7(ReactOtter.ease(1, v10))
				end
			else
				v7(ReactOtter.ease(0, v10))
			end

			if defineFastFlag and ref2.current == nil then
				ref2.current = v5
			end
		end, { state, v10, v5 })
		v8 = React.useCallback(function(p: number)
			if defineFastFlag then
				if ref5.current then
					return UDim2.new(0, p * ref5.current, 0, 0)
				end

				local v12

				if not (state and ref.current) then
					v12 = p * (ref4.current or textLimitWidth)

					return UDim2.new(0, v12, 0, 0)
				end

				local current = ref.current.AbsoluteSize.X

				if not ref3.current then
					ref3.current = ref.current.AbsoluteSize.X
				end

				if ref4.current and current <= ref4.current then
					if not defineFastFlag then
						current = ref4.current
					end

					return UDim2.new(0, current, 0, 0)
				end

				if ref3.current and ref3.current ~= current then
					ref4.current = current
				end

				v12 = p * textLimitWidth

				return UDim2.new(0, v12, 0, 0)
			else
				if state and ref.current then
					local x = ref.current.AbsoluteSize.X

					if not ref3.current then
						ref3.current = ref.current.AbsoluteSize.X
					end

					if ref4.current and x <= ref4.current then
						return UDim2.new(0, ref4.current, 0, 0)
					end

					if ref3.current and ref3.current ~= x then
						ref4.current = x
					end
				end

				local v12 = p * textLimitWidth
				return UDim2.new(0, v12, 0, 0)
			end
		end, { state })
		v9 = React.useCallback(function(p)
			return p > 0 or state
		end, { state })
	end

	if FFlagAddTraversalBackButtonAnimation and not UserGameSettings.ReducedMotion then
		return React.createElement(View, {
			tag = "auto-y",
			Visible = v6:map(v9),
			Size = v6:map(v8),
			ZIndex = -1
		}, {
			TraversalBackButton = React.createElement(TeleportBackButton, {
				text = v5,
				textLimitWidth = textLimitWidth,
				ref = ref
			})
		})
	end

	return state and React.createElement(View, { tag = "auto-xy shrink" }, {
		TraversalBackButton = React.createElement(TeleportBackButton, {
			text = v5,
			textLimitWidth = textLimitWidth,
			ref = ref
		})
	})
end

return React.memo(TraversalBackButton)
