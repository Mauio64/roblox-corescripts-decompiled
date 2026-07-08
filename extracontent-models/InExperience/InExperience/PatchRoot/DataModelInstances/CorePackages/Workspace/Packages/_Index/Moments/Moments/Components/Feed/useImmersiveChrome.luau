local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local Signals = require(MomentsParent.Signals)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local useSignalState = SignalsReact.useSignalState

require(script.Parent.FeedTypes)

local immersiveChromeMachine = require(script.Parent.immersiveChromeMachine)
local navBarChromeAdapter = require(Moments.Utils.navBarChromeAdapter)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local GetFFlagMomentsImmersiveChrome = require(Moments.Flags.GetFFlagMomentsImmersiveChrome)
local GetFIntMomentsImmersiveHideAfterAdvances = require(Moments.Flags.GetFIntMomentsImmersiveHideAfterAdvances)
local GetFIntMomentsImmersiveShownDwellMs = require(Moments.Flags.GetFIntMomentsImmersiveShownDwellMs)
local GetFIntMomentsImmersiveHiddenCooldownMs = require(Moments.Flags.GetFIntMomentsImmersiveHiddenCooldownMs)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local function defaultFireEvent(b1: boolean, p1, n1: number) -- line: 79
	-- upvalues: EventNames (copy), fireAnalyticsEvent (copy)
	local v23 = if not b1 then EventNames.MomentsChromeAutoHidden else EventNames.MomentsChromeRestored

	fireAnalyticsEvent(v23, {
		trigger = p1,
		index = tostring(n1)
	})
end
local function useImmersiveChrome(t1: {[any]: any}) -- line: 87
	-- upvalues: React (copy), navBarChromeAdapter (copy), GetImmersiveChromeStore (copy), GetFFlagMomentsImmersiveChrome (copy), defaultFireEvent (copy), GetFIntMomentsImmersiveHideAfterAdvances (copy), GetFIntMomentsImmersiveShownDwellMs (copy), GetFIntMomentsImmersiveHiddenCooldownMs (copy), immersiveChromeMachine (copy), Signals (copy), useSignalState (copy)
	local pager = t1.pager
	local active = t1.active
	local getActiveIsPlaying = t1.getActiveIsPlaying
	local getIsScrolling = t1.getIsScrolling
	local inputAllowed = t1.inputAllowed
	local reducedMotion = t1.reducedMotion
	local v31 = React.useMemo(function() -- line: 98
		-- upvalues: t1 (copy), navBarChromeAdapter (copy)
		return t1.navBarChrome or navBarChromeAdapter()
	end, {})
	local v32 = React.useMemo(function() -- line: 102
		-- upvalues: t1 (copy), GetImmersiveChromeStore (copy)
		return t1.store or GetImmersiveChromeStore(false)
	end, {})
	local v33 = ((if t1.featureEnabledOverride == nil then GetFFlagMomentsImmersiveChrome() else t1.featureEnabledOverride)) and v31.isEnabled
	local v34 = React.useRef(1)
	local v35 = React.useRef(v33)

	v35.current = v33

	local v36 = React.useRef(t1.fireEvent or defaultFireEvent)

	v36.current = t1.fireEvent or defaultFireEvent

	local v37 = React.useMemo(function() -- line: 123
		-- upvalues: t1 (copy), GetFIntMomentsImmersiveHideAfterAdvances (copy), GetFIntMomentsImmersiveShownDwellMs (copy), GetFIntMomentsImmersiveHiddenCooldownMs (copy), immersiveChromeMachine (copy), v32 (copy), v31 (copy), v35 (copy), v36 (copy), v34 (copy)
		local v39 = t1.config or {
			hideAfterAdvances = GetFIntMomentsImmersiveHideAfterAdvances(),
			shownDwellMs = GetFIntMomentsImmersiveShownDwellMs(),
			hiddenCooldownMs = GetFIntMomentsImmersiveHiddenCooldownMs()
		}
		local v40 = t1.now or function() -- line: 130
			return os.clock() * 1000
		end

		return immersiveChromeMachine(v39, {
			now = v40,
			setChromeVisible = function(b2: boolean, p2) -- line: 135
				-- upvalues: v32 (copy), v31 (copy), v35 (copy), v36 (copy), v34 (copy)
				v32.setChromeVisible(b2)
				v31.setVisible(b2)

				if v35.current then
					v36.current(b2, p2, v34.current)
				end
			end
		})
	end, {})

	React.useEffect(function() -- line: 147
		-- upvalues: Signals (copy), pager (copy), getActiveIsPlaying (copy), getIsScrolling (copy), v34 (copy), v37 (copy)
		return (Signals.createEffect(function(p3) -- line: 148
			-- upvalues: pager (copy), getActiveIsPlaying (copy), getIsScrolling (copy), v34 (copy), v37 (copy)
			local v45 = pager.getCount(p3)
			local v46 = pager.getCurrentIndex(p3)
			local v47 = getActiveIsPlaying(p3)
			local v48 = getIsScrolling(p3)

			v34.current = v46
			v37.setCount(v45)
			v37.onActiveUpdate(v46, v47, v48)
		end))
	end, {
		pager,
		getActiveIsPlaying,
		getIsScrolling,
		v37
	})

	local v38 = useSignalState(v32.getOverlayCovering)

	React.useEffect(function() -- line: 172
		-- upvalues: active (copy), inputAllowed (copy), reducedMotion (copy), v33 (copy), v37 (copy), v38 (copy)
		local v41 = not active or (not inputAllowed or (reducedMotion or not v33))

		v37.setForceShow(v41 and not v38)
		v37.setForceHide(v38)
	end, {
		active,
		inputAllowed,
		reducedMotion,
		v33,
		v38,
		v37
	})
	React.useEffect(function() -- line: 181
		-- upvalues: v32 (copy), v37 (copy)
		v32.setRevealHandler(v37.reveal)

		return function() -- line: 183
			-- upvalues: v32 (copy)
			v32.setRevealHandler(nil)
		end
	end, {
		v32,
		v37
	})
	React.useEffect(function() -- line: 190
		-- upvalues: v32 (copy), v31 (copy)
		return function() -- line: 191
			-- upvalues: v32 (copy), v31 (copy)
			v32.setChromeVisible(true)
			v31.dispose()
		end
	end, {
		v32,
		v31
	})
end

return useImmersiveChrome
