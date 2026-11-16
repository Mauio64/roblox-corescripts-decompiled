local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local module = require("@luauforge/deferred/fxh")
local module2 = require("@luauforge/deferred/fxn")
local module3 = require("@luauforge/deferred/fxo")
local useDispatch = require("@luauforge/deferred/fxp").Hooks.RoactRodux.useDispatch
local navigateBack = require("@luauforge/deferred/fxq").Thunks.NavigateBack
local useNavigation = require("@luauforge/deferred/fxr").useNavigation
local androidTVExitButtonManager = require("@luauforge/deferred/fxs").AndroidTVExitButtonManager
local module4 = require("@luauforge/deferred/fxt")
local fFlagAndroidTVExitWithB = module4.FFlagAndroidTVExitWithB
local fFlagInternalOnlyStratusBugReportEnabled = module4.FFlagInternalOnlyStratusBugReportEnabled
local fFlagLuaAppStratusBugReportAfterConnect = module4.FFlagLuaAppStratusBugReportAfterConnect
local fFlagLuaAppStratusPassUniverseId = module4.FFlagLuaAppStratusPassUniverseId
local fFlagSignalsNavP3Dispatch = module4.FFlagSignalsNavP3Dispatch
local module5 = require("@luauforge/deferred/fxu")
local fFlagLuaAppCloudClientPlayButtonOffer = module4.FFlagLuaAppCloudClientPlayButtonOffer

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/fxv").NavigationCommands else nil

local module6 = require("@luauforge/deferred/fxw")
local module7 = require("@luauforge/deferred/fxy")
local module8 = require("@luauforge/deferred/fxU")
require("@luauforge/deferred/fxj")

local signal = module2.createSignal(false)

local v5 = { routes = {} }

local function getStackState(callback)
	if callback == nil then
		return nil
	end

	local v6 = callback()

	if v6 == nil then
		return v5
	end

	return v6.state
end

local function useCloudClientStreamScreenViewModel()
	local v6 = useNavigation()
	local param = v6.getParam("placeId")

	local v7 = if fFlagLuaAppStratusPassUniverseId then v6.getParam("universeId") else nil

	local param2 = v6.getParam("launchSource")
	local param3 = v6.getParam("extraParams")

	local v8 = if fFlagLuaAppCloudClientPlayButtonOffer then v6.getParam("reservationToken") else nil

	local v9 = if fFlagLuaAppCloudClientPlayButtonOffer then v6.getParam("offerKind") else nil
	local key = if v6.state ~= nil then v6.state.key else nil
	local dangerouslyGetParent = v6._dangerouslyGetParent
	local v10 = useDispatch()

	local state, setState = module.useState(nil)
	local useSignalState = module3.useSignalState
	local v11 = if state then state.getIsLoading else signal
	local v12 = useSignalState(v11)
	local useSignalState2 = module3.useSignalState
	local v13 = if state then state.getIsConnected else signal
	local v14 = useSignalState2(v13)
	local v15, v16 = module.useBinding(0)

	local ref = module.useRef(nil)
	local ref2 = module.useRef(nil)

	local v17 = module.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v10(navigateBack(true))
		end
	end, { v10 })

	module.useLayoutEffect(function()
		local v18 = {
			navigateBack = v17,
			getStackState = function()
				local v19 = dangerouslyGetParent

				if v19 == nil then
					return nil
				end

				local v20 = v19()

				if v20 == nil then
					return v5
				end

				return v20.state
			end
		}

		local v19 = module7.attach(key, {
			placeId = param,
			universeId = v7,
			launchSource = param2,
			extraParams = param3,
			reservationToken = v8,
			offerKind = v9
		}, v18)

		setState(v19)

		if v19 == nil then
			return nil
		end

		return function()
			module7.detach(v19, v18)
		end
	end, {
		dangerouslyGetParent,
		key,
		param,
		v7,
		param2,
		param3,
		v8,
		v9,
		v17
	})

	module.useEffect(function()
		if state == nil then
			return nil
		end

		local v18 = state
		local function requestNavigateBack()
			module7.requestNavigateBack(v18)
		end
		local showLeaveConfirmationConnection = GuiService.ShowLeaveConfirmation:Connect(requestNavigateBack)
		local v19

		if fFlagAndroidTVExitWithB then
			v19 = androidTVExitButtonManager.register(requestNavigateBack)
		else
			v19 = nil
		end

		return function()
			showLeaveConfirmationConnection:Disconnect()

			if v19 then
				v19()
			end
		end
	end, { state })

	module.useEffect(function()
		if not v12 then
			return
		end

		local v18 = 0
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			v18 = (v18 + dt * 180) % 360
			v16(v18)
		end)
		return function()
			heartbeatConnection:Disconnect()
		end
	end, { v12 })
	local v18 = state ~= nil
	local v19 = module8(ref, ref2, v18)

	local v20 = {
		isActive = v18,
		displayOrder = module6.SURFACE_DISPLAY_ORDER + 1,
		rootRef = v19,
		inputBlockerRef = ref2,
		isInputBlockerModal = not module5,
		isLoading = v12,
		spinnerRotation = v15,
		showBugReport = 0
	}

	if not fFlagLuaAppStratusBugReportAfterConnect then
		v14 = fFlagInternalOnlyStratusBugReportEnabled
	end

	v20.showBugReport = v14
	return v20
end

return useCloudClientStreamScreenViewModel
