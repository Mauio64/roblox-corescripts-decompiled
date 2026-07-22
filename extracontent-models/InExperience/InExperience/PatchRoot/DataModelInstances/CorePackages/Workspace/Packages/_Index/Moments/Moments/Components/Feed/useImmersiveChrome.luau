local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local Signals = require(MomentsParent.Signals)
local SignalsReact = require(MomentsParent.SignalsReact)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local useSignalState = SignalsReact.useSignalState

require(script.Parent.FeedTypes)

local immersiveChromeMachine = require(script.Parent.immersiveChromeMachine)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local FFlagMomentsImmersiveChrome = require(Moments.Flags.FFlagMomentsImmersiveChrome)
local GetFIntMomentsImmersiveHideAfterAdvances = require(Moments.Flags.GetFIntMomentsImmersiveHideAfterAdvances)
local GetFIntMomentsImmersiveShownDwellMs = require(Moments.Flags.GetFIntMomentsImmersiveShownDwellMs)
local GetFIntMomentsImmersiveHiddenCooldownMs = require(Moments.Flags.GetFIntMomentsImmersiveHiddenCooldownMs)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local function defaultFireEvent(b1: boolean, p1, n1: number) -- line: 73
	-- upvalues: EventNames (copy), fireAnalyticsEvent (copy)
	local v22 = if not b1 then EventNames.MomentsChromeAutoHidden else EventNames.MomentsChromeRestored

	fireAnalyticsEvent(v22, {
		trigger = p1,
		index = tostring(n1)
	})
end
local function useImmersiveChrome(t1: {[any]: any}) -- line: 81
	-- upvalues: React (copy), GetImmersiveChromeStore (copy), FFlagMomentsImmersiveChrome (copy), defaultFireEvent (copy), GetFIntMomentsImmersiveHideAfterAdvances (copy), GetFIntMomentsImmersiveShownDwellMs (copy), GetFIntMomentsImmersiveHiddenCooldownMs (copy), immersiveChromeMachine (copy), Signals (copy), useSignalState (copy)
	local pager = t1.pager
	local active = t1.active
	local getActiveIsPlaying = t1.getActiveIsPlaying
	local getIsScrolling = t1.getIsScrolling
	local inputAllowed = t1.inputAllowed
	local reducedMotion = t1.reducedMotion
	local v30 = React.useMemo(function() -- line: 91
		-- upvalues: t1 (copy), GetImmersiveChromeStore (copy)
		return t1.store or GetImmersiveChromeStore(false)
	end, {})
	local v31 = if t1.featureEnabledOverride == nil then FFlagMomentsImmersiveChrome else t1.featureEnabledOverride
	local v32 = React.useRef(1)
	local v33 = React.useRef(v31)

	v33.current = v31

	local v34 = React.useRef(t1.fireEvent or defaultFireEvent)

	v34.current = t1.fireEvent or defaultFireEvent

	local v35 = React.useMemo(function() -- line: 110
		-- upvalues: t1 (copy), GetFIntMomentsImmersiveHideAfterAdvances (copy), GetFIntMomentsImmersiveShownDwellMs (copy), GetFIntMomentsImmersiveHiddenCooldownMs (copy), immersiveChromeMachine (copy), v30 (copy), v33 (copy), v34 (copy), v32 (copy)
		local v37 = t1.config or {
			hideAfterAdvances = GetFIntMomentsImmersiveHideAfterAdvances(),
			shownDwellMs = GetFIntMomentsImmersiveShownDwellMs(),
			hiddenCooldownMs = GetFIntMomentsImmersiveHiddenCooldownMs()
		}
		local v38 = t1.now or function() -- line: 117
			return os.clock() * 1000
		end

		return immersiveChromeMachine(v37, {
			now = v38,
			setChromeVisible = function(b2: boolean, p2) -- line: 122
				-- upvalues: v30 (copy), v33 (copy), v34 (copy), v32 (copy)
				v30.setChromeVisible(b2)

				if v33.current then
					v34.current(b2, p2, v32.current)
				end
			end
		})
	end, {})

	React.useEffect(function() -- line: 133
		-- upvalues: Signals (copy), pager (copy), getActiveIsPlaying (copy), getIsScrolling (copy), v32 (copy), v35 (copy)
		return (Signals.createEffect(function(p3) -- line: 134
			-- upvalues: pager (copy), getActiveIsPlaying (copy), getIsScrolling (copy), v32 (copy), v35 (copy)
			local v43 = pager.getCount(p3)
			local v44 = pager.getCurrentIndex(p3)
			local v45 = getActiveIsPlaying(p3)
			local v46 = getIsScrolling(p3)

			v32.current = v44
			v35.setCount(v43)
			v35.onActiveUpdate(v44, v45, v46)
		end))
	end, {
		pager,
		getActiveIsPlaying,
		getIsScrolling,
		v35
	})

	local v36 = useSignalState(v30.getOverlayCovering)

	React.useEffect(function() -- line: 158
		-- upvalues: active (copy), inputAllowed (copy), reducedMotion (copy), v31 (copy), v35 (copy), v36 (copy)
		local v39 = not active or (not inputAllowed or (reducedMotion or not v31))

		v35.setForceShow(v39 and not v36)
		v35.setForceHide(v36)
	end, {
		active,
		inputAllowed,
		reducedMotion,
		v31,
		v36,
		v35
	})
	React.useEffect(function() -- line: 167
		-- upvalues: v30 (copy), v35 (copy)
		v30.setRevealHandler(v35.reveal)

		return function() -- line: 169
			-- upvalues: v30 (copy)
			v30.setRevealHandler(nil)
		end
	end, {
		v30,
		v35
	})
	React.useEffect(function() -- line: 175
		-- upvalues: v30 (copy)
		return function() -- line: 176
			-- upvalues: v30 (copy)
			v30.setChromeVisible(true)
		end
	end, { v30 })
end

return useImmersiveChrome
