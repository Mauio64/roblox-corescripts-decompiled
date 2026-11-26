local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local AppTabBarRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppTabBarRodux")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactUtils").Hooks.RoactRodux.useDispatch
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local setTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible
local analytics = MomentsCommon.Analytics
local funnelEventNames = analytics.FunnelEventNames

local createGalleryCaptureSource = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Capture/createGalleryCaptureSource")
local isStudio = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/isStudio")
local hasGalleryApi = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Capture/hasGalleryApi")
local logCreationEntryResolved = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/logCreationEntryResolved")
local FFlagMomentsCreationEntryOutcome = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreationEntryOutcome")

local function useCreationEntry(p2)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	local v5 = useDispatch()
	local v6 = p2 == nil or p2.manageTabBarVisibility ~= false

	local v7 = isStudio()
	local v8 = hasGalleryApi()
	local v9 = v7 or not v8
	local v10 = React.useCallback(function()
		local v11

		if FFlagMomentsCreationEntryOutcome then
			v11 = analytics.SessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
		else
			v11 = nil
		end

		if v9 then
			setState(true)

			if FFlagMomentsCreationEntryOutcome then
				logCreationEntryResolved.log(logCreationEntryResolved.Outcome.GalleryUnavailable, v11)
			end
		elseif ref2.current then
			if FFlagMomentsCreationEntryOutcome then
				logCreationEntryResolved.log(logCreationEntryResolved.Outcome.RequestInFlight, v11)
			end
		else
			ref2.current = true
			task.spawn(function()
				ref.current = createGalleryCaptureSource(nil, function(list, p3, p4)
					ref2.current = false

					if p3 and #list == 0 then
						setState2(true)
					else
						setState(true)
					end

					if FFlagMomentsCreationEntryOutcome then
						logCreationEntryResolved.log(logCreationEntryResolved.resolveGalleryOutcome(p3, #list, p4), v11)
					end
				end)
			end)
		end
	end, { v9 })

	React.useEffect(function()
		if v6 and state then
			v5(setTabBarVisible(false))
		end

		return function()
			if v6 and state then
				v5(setTabBarVisible(true))
			end
		end
	end, { state, v5, v6 })

	local v11 = React.useCallback(function()
		ref.current = nil
		setState(false)
	end, {})

	local v12 = React.useCallback(function()
		ref.current = nil
		setState2(false)
	end, {})

	local v13 = {
		isCreating = state,
		showFtux = nil,
		captureSource = 0,
		onCreatePressed = 0,
		onExitCreation = 0,
		onExitFtux = 0
	}

	if v9 then
		state2 = false
	end

	v13.showFtux = state2
	local v14 = if not v9 then ref.current else nil
	v13.captureSource = v14
	v13.onCreatePressed = v10
	v13.onExitCreation = v11
	v13.onExitFtux = v12
	return v13
end

return useCreationEntry
