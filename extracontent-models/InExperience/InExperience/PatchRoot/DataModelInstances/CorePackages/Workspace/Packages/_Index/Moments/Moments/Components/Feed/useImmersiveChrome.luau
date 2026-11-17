local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local MomentsCommon = require(parent.MomentsCommon)

local useSignalState = SignalsReact.useSignalState

require(script.Parent.FeedTypes)
local immersiveChromeMachine = require(script.Parent.immersiveChromeMachine)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local GetFIntMomentsImmersiveHideAfterAdvances = require(Moments.Flags.GetFIntMomentsImmersiveHideAfterAdvances)
local GetFIntMomentsImmersiveShownDwellMs = require(Moments.Flags.GetFIntMomentsImmersiveShownDwellMs)
local GetFIntMomentsImmersiveHiddenCooldownMs = require(Moments.Flags.GetFIntMomentsImmersiveHiddenCooldownMs)
local GetFFlagMomentsPersistHeaderOnProfilePeek = require(Moments.Flags.GetFFlagMomentsPersistHeaderOnProfilePeek)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local function defaultFireEvent(flag: boolean, trigger, p: number)
	local v

	if flag then
		v = EventNames.MomentsChromeRestored
	else
		v = EventNames.MomentsChromeAutoHidden
	end

	fireAnalyticsEvent(v, { trigger = trigger, index = tostring(p) })
end

local function useImmersiveChrome(data)
	local pager = data.pager
	local active = data.active
	local getActiveIsPlaying = data.getActiveIsPlaying
	local getIsScrolling = data.getIsScrolling
	local inputAllowed = data.inputAllowed
	local reducedMotion = data.reducedMotion
	local coveringOverlay = data.coveringOverlay == true

	local v = React.useMemo(function()
		return data.store or GetImmersiveChromeStore(false)
	end, {})

	local current2 = data.featureEnabledOverride == nil or data.featureEnabledOverride

	local ref = React.useRef(1)
	local ref2 = React.useRef(current2)
	ref2.current = current2
	local ref3 = React.useRef(data.fireEvent or defaultFireEvent)
	ref3.current = data.fireEvent or defaultFireEvent

	local v2 = React.useMemo(function()
		local config = data.config
			or {
				hideAfterAdvances = GetFIntMomentsImmersiveHideAfterAdvances(),
				shownDwellMs = GetFIntMomentsImmersiveShownDwellMs(),
				hiddenCooldownMs = GetFIntMomentsImmersiveHiddenCooldownMs()
			}

		local now = data.now or function()
			return os.clock() * 1000
		end

		return immersiveChromeMachine(config, {
			now = now,
			setChromeVisible = function(flag: boolean, p)
				v.setChromeVisible(flag)

				if ref2.current then
					ref3.current(flag, p, ref.current)
				end
			end
		})
	end, {})

	React.useEffect(function()
		return (Signals.createEffect(function(p)
			local count = pager.getCount(p)
			local currentIndex = pager.getCurrentIndex(p)
			local activeIsPlaying = getActiveIsPlaying(p)
			local isScrolling = getIsScrolling(p)
			ref.current = currentIndex

			v2.setCount(count)
			v2.onActiveUpdate(currentIndex, activeIsPlaying, isScrolling)
		end))
	end, { pager, getActiveIsPlaying, getIsScrolling, v2 })

	local v3 = useSignalState(v.getOverlayCovering)

	local fFlagMomentsPersistHeaderOnProfilePeek = GetFFlagMomentsPersistHeaderOnProfilePeek()
	local v4

	if fFlagMomentsPersistHeaderOnProfilePeek then
		v4 = coveringOverlay
	else
		v4 = v3 or coveringOverlay
	end

	local ref4 = React.useRef(false)

	React.useEffect(function()
		if fFlagMomentsPersistHeaderOnProfilePeek then
			if v3 and not active then
				ref4.current = true
			elseif active then
				ref4.current = false
			end
		end

		local v5 = not active

		if v5 then
			local current = fFlagMomentsPersistHeaderOnProfilePeek and ref4.current
			v5 = not current
		end

		local v6 = v5 or not inputAllowed or reducedMotion or not current2
		local setForceShow = v2.setForceShow

		if v6 then
			v6 = not (v3 or coveringOverlay)
		end

		setForceShow(v6)
		v2.setForceHide(v4)
	end, {
		active,
		inputAllowed,
		reducedMotion,
		current2,
		v3,
		coveringOverlay,
		v4,
		fFlagMomentsPersistHeaderOnProfilePeek,
		v2
	})

	React.useEffect(function()
		v.setRevealHandler(v2.reveal)
		return function()
			v.setRevealHandler(nil)
		end
	end, { v, v2 })

	React.useEffect(function()
		return function()
			v.setChromeVisible(true)
		end
	end, { v })
end

return useImmersiveChrome
