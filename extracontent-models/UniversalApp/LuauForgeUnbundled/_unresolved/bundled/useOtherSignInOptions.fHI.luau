local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFm")
local localizationRoactContext = require("@luauforge/bundled/fFn").LocalizationRoactContext
local onCloseCallbackReason = require("@luauforge/bundled/fFp").Enums.OnCloseCallbackReason

local authButtonShown = module2.Events.authButtonShown
local authButtonClick = module2.Events.authButtonClick
local authModalShown = module2.Events.authModalShown
local authClientError = module2.Events.authClientError
local authOperationTiming = module2.Events.authOperationTiming
local eventStreamConstants = module2.EventStreamConstants

require("@luauforge/bundled/fFr")
local module3 = require("@luauforge/bundled/fHh")
local module4 = require("@luauforge/bundled/fFv")
local fFlagEnableAccountSwitchSsoLogin = require("@luauforge/bundled/fFu").FFlagEnableAccountSwitchSsoLogin

local function localizeText(object)
	local success, result = pcall(function()
		return object:Format("Authentication.Login.Label.OtherSignInOptions")
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return result
	end

	return "Other sign-in options"
end

local function useOtherSignInOptions(p2, callback, props)
	local eventContext = props.eventContext
	local eventOrigin = props.eventOrigin
	local v5 = module.useContext(localizationRoactContext)
	local state, setState = module.useState({})
	local state2, setState2 = module.useState(false)
	local ref = module.useRef(false)
	local ref2 = module.useRef(nil)
	local ref3 = module.useRef(true)

	local function setIsOpen(current)
		ref.current = current
		setState2(current)
	end

	module.useEffect(function()
		ref3.current = true
		return function()
			ref3.current = false
			local current = ref2.current

			if current ~= nil then
				current.cancel()
			end
		end
	end, {})

	module.useEffect(function()
		if p2 or not fFlagEnableAccountSwitchSsoLogin and props.isUserAuthenticated() then
			return
		end

		local flag = false

		task.spawn(function()
			local capabilities = props.getCapabilities()

			if flag then
				return
			end

			local v6 = {}

			if capabilities.google then
				table.insert(v6, "google")
			end

			if capabilities.apple then
				table.insert(v6, "apple")
			end

			setState(v6)
		end)

		return function()
			flag = true
		end
	end, { p2 })

	local v6 = not p2 and #state > 0

	module.useEffect(function()
		if v6 then
			authButtonShown(
				eventContext,
				eventStreamConstants.Button.OtherSignInOptions,
				"visible",
				eventOrigin
			)
		end
	end, { v6 })

	if module4 then
		module.useEffect(function()
			if state2 then
				for k, v7 in state do
					local v10 = if v7 == "google" then eventStreamConstants.Button.GoogleSso else eventStreamConstants.Button.AppleSso
					authButtonShown(eventContext, v10, "visible", eventOrigin)
				end
			end
		end, { state2 })
	end

	if not v6 then
		return nil
	end

	local function onActivated(p3)
		local current = ref2.current

		if current == nil then
			local v9

			if p3 == "google" then
				v9 = eventStreamConstants.Button.GoogleSso
			else
				v9 = eventStreamConstants.Button.AppleSso
			end

			local v10 = if module4 then props.modalField else nil
			authButtonClick(eventContext, v9, v10, nil, nil, eventOrigin)

			local lastTime = os.clock()
			local authenticate = props.authenticate(p3)
			ref2.current = authenticate
			authenticate.promise:andThen(function(p4)
				authOperationTiming(
					eventContext,
					os.clock() - lastTime,
					`externalIdentity.{p3}.{p4.status}`
				)

				if p4.status == "failed" then
					authClientError(
						eventContext,
						`externalIdentity.{p3}.{p4.errorClass or "unknown"}`,
						nil,
						eventOrigin
					)
				elseif module4 and p4.status == "unavailable" then
					authClientError(eventContext, `externalIdentity.{p3}.unavailable`, nil, eventOrigin)
				end

				if ref2.current ~= authenticate then
					return
				end

				ref2.current = nil

				if not ref3.current then
					return
				end

				if p4.status == "success" then
					ref.current = false
					setState2(false)
				elseif p4.status == "failed" or module3 and p4.status == "busy" then
					ref.current = false
					setState2(false)

					callback()
				end
			end)
		else
			current.cancel()
			current.promise:andThen(function(p4)
				if ref3.current and ref.current and p4.status ~= "success" and ref2.current == nil then
					onActivated(p3)
				end
			end)
		end
	end

	local function close(p3)
		if module4 then
			local v9 = if p3 == onCloseCallbackReason.BackdropClick then eventStreamConstants.Button.DismissSheet else eventStreamConstants.Button.DismissCornerX
			authButtonClick(eventContext, v9, props.modalField, nil, nil, eventOrigin)

			authModalShown(
				eventContext,
				eventStreamConstants.ActionType.Dismiss,
				props.modalField,
				eventOrigin
			)
		end

		local current = ref2.current

		if current ~= nil then
			current.cancel()
		end

		ref.current = false
		setState2(false)
	end

	local success, result = pcall(function()
		return v5:Format("Authentication.Login.Label.OtherSignInOptions")
	end)

	local v7 = (not success or typeof(result) ~= "string" or result == "") and "Other sign-in options"
		or result

	local v8 = {
		text = v7,
		open = function()
			local shown = if module4 then eventStreamConstants.ActionType.Shown else nil
			authButtonClick(
				eventContext,
				eventStreamConstants.Button.OtherSignInOptions,
				shown,
				nil,
				nil,
				eventOrigin
			)

			authModalShown(eventContext, shown, props.modalField, eventOrigin)
			ref.current = true
			setState2(true)
		end,
		dialog = 0
	}

	local v9 = if state2 then module.createElement(require("@luauforge/bundled/fHJ"), {
		title = v7,
		providers = state,
		onActivated = onActivated,
		onClose = close,
		size = props.dialogSize
	}) else nil
	v8.dialog = v9
	return v8
end

return useOtherSignInOptions
