local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local AppTabBarRodux = require(parent.AppTabBarRodux)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local MomentsCommon = require(parent.MomentsCommon)

local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible
local Analytics = MomentsCommon.Analytics
local FunnelEventNames = Analytics.FunnelEventNames

local createGalleryCaptureSource = require(Moments.Capture.createGalleryCaptureSource)
local isStudio = require(parent.MomentsCommon.isStudio)
local hasGalleryApi = require(Moments.Capture.hasGalleryApi)
local logCreationEntryResolved = require(Moments.Analytics.logCreationEntryResolved)
local FFlagMomentsCreationEntryOutcome = require(Moments.Flags.FFlagMomentsCreationEntryOutcome)

local function useCreationEntry(p)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	local v = useDispatch()
	local v2 = p == nil or p.manageTabBarVisibility ~= false

	local studio = isStudio()
	local galleryApi = hasGalleryApi()
	local v3 = studio or not galleryApi
	local onCreatePressed = React.useCallback(function()
		local v4

		if FFlagMomentsCreationEntryOutcome then
			v4 = Analytics.SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
		else
			v4 = nil
		end

		if v3 then
			setState(true)

			if FFlagMomentsCreationEntryOutcome then
				logCreationEntryResolved.log(logCreationEntryResolved.Outcome.GalleryUnavailable, v4)
			end
		elseif ref2.current then
			if FFlagMomentsCreationEntryOutcome then
				logCreationEntryResolved.log(logCreationEntryResolved.Outcome.RequestInFlight, v4)
			end
		else
			ref2.current = true
			task.spawn(function()
				ref.current = createGalleryCaptureSource(nil, function(list, p2, p3)
					ref2.current = false

					if p2 and #list == 0 then
						setState2(true)
					else
						setState(true)
					end

					if FFlagMomentsCreationEntryOutcome then
						logCreationEntryResolved.log(logCreationEntryResolved.resolveGalleryOutcome(p2, #list, p3), v4)
					end
				end)
			end)
		end
	end, { v3 })

	React.useEffect(function()
		if v2 and state then
			v(SetTabBarVisible(false))
		end

		return function()
			if v2 and state then
				v(SetTabBarVisible(true))
			end
		end
	end, { state, v, v2 })

	local onExitCreation = React.useCallback(function()
		ref.current = nil
		setState(false)
	end, {})

	local onExitFtux = React.useCallback(function()
		ref.current = nil
		setState2(false)
	end, {})

	local v4 = {
		isCreating = state,
		showFtux = nil,
		captureSource = 0,
		onCreatePressed = 0,
		onExitCreation = 0,
		onExitFtux = 0
	}

	if v3 then
		state2 = false
	end

	v4.showFtux = state2
	local captureSource

	if not v3 then
		captureSource = ref.current
	end

	v4.captureSource = captureSource
	v4.onCreatePressed = onCreatePressed
	v4.onExitCreation = onExitCreation
	v4.onExitFtux = onExitFtux
	return v4
end

return useCreationEntry
