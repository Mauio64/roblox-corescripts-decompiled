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
local _ = Traversal.useHistoryItems
local useLocalization = Localization.Hooks.useLocalization
local _ = Traversal.Flags.FFlagUseTeleportTraversalHistory
local _ = Traversal.Flags.FFlagUseLocalTraversalHistory
local FFlagAddTraversalBackButtonAnimation = Traversal.Flags.FFlagAddTraversalBackButtonAnimation
local v26 = game:DefineFastFlag("FixTraversalBackButtonAnimation", false)

local function TraversalBackButton(_: {[any]: any}) -- line: 36
	-- upvalues: useTokens (copy), React (copy), TeleportService (copy), Constants (copy), SettingsShowSignal (copy), TraversalTelemetry (copy), useLocalization (copy), getGameInfoStore (copy), DataHydrationTypes (copy), SignalsReact (copy), v26 (copy), FFlagAddTraversalBackButtonAnimation (copy), ReactOtter (copy), UserGameSettings (copy), View (copy), TeleportBackButton (copy)
	local v29 = useTokens()
	local v30 = React.useRef(nil)
	local v31, v32 = TeleportService:GetThirdPartyTeleportInfo(false)

	if v31 <= Constants.NO_UNIVERSE_ID or v32 <= Constants.NO_PLACE_ID then
		return nil
	end

	local v33, v34 = React.useState(false)

	React.useEffect(function() -- line: 46
		-- upvalues: SettingsShowSignal (copy), v34 (copy)
		local v49 = SettingsShowSignal:connect(function(p1) -- line: 47
			-- upvalues: v34 (copy)
			v34(p1)
		end)

		return function() -- line: 50
			-- upvalues: v49 (copy)
			v49:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 55
		-- upvalues: v33 (copy), TraversalTelemetry (copy), v31 (copy)
		if v33 then
			TraversalTelemetry.sendBackButtonActionEvent({
				integration_id = "back_button",
				event_type = "impression",
				destination_universe_id = v31
			})
		end
	end, {
		v33,
		v31
	})

	local v35 = useLocalization({
		defaultBackButtonText = "CoreScripts.TopBar.Traversal.BackButtonDefault"
	})
	local v36 = React.useCallback(function(p2) -- line: 69
		-- upvalues: getGameInfoStore (copy), v31 (copy), DataHydrationTypes (copy), v35 (copy)
		local v51 = getGameInfoStore(p2).getAndFetchGameInfo((tostring(v31)))
		local v52 = v51.data(p2)
		local v53 = v51.status(p2)

		if not v52 or v53 ~= DataHydrationTypes.DataStatus.Ready then
			return v35.defaultBackButtonText
		end

		return v52.name
	end, {
		v31,
		getGameInfoStore
	})
	local v37 = SignalsReact.useSignalState(v36)
	local u38 = nil

	if v26 then
		u38 = React.useRef(nil)
	end

	local v39 = v29.Size.Size_2500 * 2
	local u40 = nil
	local u41 = nil
	local u42 = nil
	local v43 = nil
	local u44 = nil
	local v45 = nil
	local v46 = nil

	if FFlagAddTraversalBackButtonAnimation then
		u40 = React.useRef(nil)
		u41 = React.useRef(nil)

		if v26 then
			u42 = React.useRef(nil)
		end

		local v47 = React.useMemo(function() -- line: 100
			-- upvalues: v29 (copy)
			return {
				duration = v29.Time.Time_300,
				easingStyle = v29.Ease.StandardOut
			}
		end, { v29 })
		local v48

		v43, v48 = ReactOtter.useAnimatedBinding(0, function(n1: number) -- line: 106
			-- upvalues: u40 (ref), v26 (copy), u42 (ref), u41 (ref)
			u40.current = nil

			if v26 then
				if not u42.current and u41.current and n1 == 1 then
					u42.current = u41.current
				end

				if n1 == 0 then
					u41.current = 0

					return
				end
			else
				u41.current = nil
			end
		end)
		u44 = v48
		React.useEffect(function() -- line: 119
			-- upvalues: v33 (copy), v26 (copy), u38 (ref), v37 (copy), u42 (ref), v30 (copy), u44 (ref), ReactOtter (copy), v47 (copy)
			if v33 then
				if v26 then
					if u38.current ~= v37 then
						u42.current = nil
						u38.current = v37

						if v30.current then
							u44(ReactOtter.ease(0.99, v47))
						end
					else
						u44(ReactOtter.ease(1, v47))
					end
				else
					u44(ReactOtter.ease(1, v47))
				end
			else
				u44(ReactOtter.ease(0, v47))
			end

			if v26 and u38.current == nil then
				u38.current = v37
			end
		end, {
			v33,
			v47,
			v37
		})
		v45 = React.useCallback(function(n2: number) -- line: 142
			-- upvalues: v26 (copy), u42 (ref), v33 (copy), v30 (copy), u40 (ref), u41 (ref), v39 (copy)
			if v26 then
				if u42.current then
					return UDim2.new(0, n2 * u42.current, 0, 0)
				end

				local v57

				if v33 and v30.current then
					local AbsoluteSizeX = v30.current.AbsoluteSize.X

					if not u40.current then
						u40.current = v30.current.AbsoluteSize.X
					end

					if u41.current and AbsoluteSizeX <= u41.current then
						return UDim2.new(0, if not v26 then u41.current else AbsoluteSizeX, 0, 0)
					end

					if u40.current and AbsoluteSizeX ~= u40.current then
						u41.current = AbsoluteSizeX
					end

					v57 = n2 * v39
				else
					v57 = n2 * (u41.current or v39)
				end

				return UDim2.new(0, v57, 0, 0)
			end

			if v33 and v30.current then
				local AbsoluteSizeX = v30.current.AbsoluteSize.X

				if not u40.current then
					u40.current = v30.current.AbsoluteSize.X
				end

				if u41.current and AbsoluteSizeX <= u41.current then
					return UDim2.new(0, u41.current, 0, 0)
				end

				if u40.current and AbsoluteSizeX ~= u40.current then
					u41.current = AbsoluteSizeX
				end
			end

			local v59 = n2 * v39

			return UDim2.new(0, v59, 0, 0)
		end, { v33 })
		v46 = React.useCallback(function(p3) -- line: 182
			-- upvalues: v33 (copy)
			return p3 > 0 or v33
		end, { v33 })
	end

	if FFlagAddTraversalBackButtonAnimation and not UserGameSettings.ReducedMotion then
		return React.createElement(View, {
			tag = "auto-y",
			ZIndex = -1,
			Visible = v43:map(v46),
			Size = v43:map(v45)
		}, {
			TraversalBackButton = React.createElement(TeleportBackButton, {
				text = v37,
				textLimitWidth = v39,
				ref = v30
			})
		})
	end

	return v33 and React.createElement(View, {
		tag = "auto-xy shrink"
	}, {
		TraversalBackButton = React.createElement(TeleportBackButton, {
			text = v37,
			textLimitWidth = v39,
			ref = v30
		})
	})
end

return React.memo(TraversalBackButton)
