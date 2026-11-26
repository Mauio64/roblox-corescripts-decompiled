local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local useSignalState = SignalsReact.useSignalState

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local immersiveChromeMachine = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/immersiveChromeMachine")
local GetImmersiveChromeStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetImmersiveChromeStore")
local GetFIntMomentsImmersiveHideAfterAdvances = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFIntMomentsImmersiveHideAfterAdvances")
local GetFIntMomentsImmersiveShownDwellMs = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFIntMomentsImmersiveShownDwellMs")
local GetFIntMomentsImmersiveHiddenCooldownMs = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFIntMomentsImmersiveHiddenCooldownMs")
local GetFFlagMomentsPersistHeaderOnProfilePeek = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagMomentsPersistHeaderOnProfilePeek")

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent

local function defaultFireEvent(p2, p3, p4)
	local v5 = if p2 then eventNames.MomentsChromeRestored else eventNames.MomentsChromeAutoHidden
	fireAnalyticsEvent(v5, { trigger = p3, index = tostring(p4) })
end

local function useImmersiveChrome(data)
	local pager = data.pager
	local active = data.active
	local getActiveIsPlaying = data.getActiveIsPlaying
	local getIsScrolling = data.getIsScrolling
	local inputAllowed = data.inputAllowed
	local reducedMotion = data.reducedMotion
	local coveringOverlay = data.coveringOverlay == true

	local v5 = React.useMemo(function()
		return data.store or GetImmersiveChromeStore(false)
	end, {})

	local v6 = data.featureEnabledOverride == nil or data.featureEnabledOverride

	local ref = React.useRef(1)
	local ref2 = React.useRef(v6)
	ref2.current = v6
	local ref3 = React.useRef(data.fireEvent or defaultFireEvent)
	ref3.current = data.fireEvent or defaultFireEvent

	local v7 = React.useMemo(function()
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
			setChromeVisible = function(p2, p3)
				v5.setChromeVisible(p2)

				if ref2.current then
					ref3.current(p2, p3, ref.current)
				end
			end
		})
	end, {})

	React.useEffect(function()
		return (Signals.createEffect(function(p2)
			local count = pager.getCount(p2)
			local currentIndex = pager.getCurrentIndex(p2)
			local activeIsPlaying = getActiveIsPlaying(p2)
			local isScrolling = getIsScrolling(p2)
			ref.current = currentIndex

			v7.setCount(count)
			v7.onActiveUpdate(currentIndex, activeIsPlaying, isScrolling)
		end))
	end, { pager, getActiveIsPlaying, getIsScrolling, v7 })

	local v8 = useSignalState(v5.getOverlayCovering)

	local v9 = GetFFlagMomentsPersistHeaderOnProfilePeek()
	local v10 = if v9 then coveringOverlay else v8 or coveringOverlay
	local ref4 = React.useRef(false)

	React.useEffect(function()
		if v9 then
			if v8 and not active then
				ref4.current = true
			elseif active then
				ref4.current = false
			end
		end

		local v11 = not active

		if v11 then
			local current = v9 and ref4.current
			v11 = not current
		end

		local v12 = v11 or not inputAllowed or reducedMotion or not v6
		local setForceShow = v7.setForceShow

		if v12 then
			v12 = not (v8 or coveringOverlay)
		end

		setForceShow(v12)
		v7.setForceHide(v10)
	end, {
		active,
		inputAllowed,
		reducedMotion,
		v6,
		v8,
		coveringOverlay,
		v10,
		v9,
		v7
	})

	React.useEffect(function()
		v5.setRevealHandler(v7.reveal)
		return function()
			v5.setRevealHandler(nil)
		end
	end, { v5, v7 })

	React.useEffect(function()
		return function()
			v5.setChromeVisible(true)
		end
	end, { v5 })
end

return useImmersiveChrome
