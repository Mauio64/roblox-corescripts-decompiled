local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local AccountService = game:GetService("AccountService")
local EngineFeature = game:GetEngineFeature("MagicLogin")
local useEffect = require(LoginV2Parent.React).useEffect
local useDispatch = require(LoginV2Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local Logger = require(LoginV2Parent.Loggers).Logger
local Constants = require(LoginV2.Components.Constants)
local SetCentralOverlay = require(LoginV2Parent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(LoginV2Parent.RobloxAppEnums).CentralOverlayType
local MessageBus = require(LoginV2Parent.MessageBus).MessageBus
local t = require(LoginV2Parent.t)

local function MagicLoginApprovePopupEventReceiver(t1: {[any]: any}) -- line: 25
	-- upvalues: useDispatch (copy), AccountService (ref), EngineFeature (ref), useEffect (copy), HttpService (copy), Constants (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Logger (copy), MessageBus (copy), t (copy)
	local v16 = t1.useDispatch or useDispatch()

	AccountService = t1.AccountService or AccountService
	EngineFeature = t1.MagicLoginEngineFeature or EngineFeature
	useEffect(function() -- line: 31
		-- upvalues: AccountService (ref), EngineFeature (ref), HttpService (copy), Constants (copy), v16 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Logger (copy), MessageBus (copy), t (copy)
		local connection = nil
		local u18 = nil

		if AccountService and EngineFeature then
			connection = AccountService.MagicLoginEvent:Connect(function(p1) -- line: 36
				-- upvalues: HttpService (copy), Constants (copy), v16 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Logger (copy)
				local ok, result = pcall(HttpService.JSONDecode, HttpService, p1)

				if ok then
					if result.magicLoginActionKey == Constants.CONNECTION_INIT then
						v16(SetCentralOverlay(CentralOverlayType.MagicLoginApprovePopup, {
							endpointName = result.endpointName,
							endpointType = result.endpointType,
							authenticationDigits = result.authenticationDigits,
							authCode = result.code
						}))

						return
					end
				else
					Logger:warning("Magic login Failed to parse JSON data from string: " .. p1)
				end
			end)
			u18 = MessageBus.Subscriber.new()
			u18:subscribe({
				mid = MessageBus.getMessageId("Game", "onGameLeave"),
				validateParams = t.table
			}, function(_) -- line: 57
				-- upvalues: AccountService (ref), Constants (copy)
				AccountService:MagicLogin(Constants.START_ADVERTISEMENT)
			end)
			u18:subscribe({
				mid = MessageBus.getMessageId("Game", "launchSuccess"),
				validateParams = t.table
			}, function(_) -- line: 64
				-- upvalues: AccountService (ref), Constants (copy)
				AccountService:MagicLogin(Constants.STOP_ADVERTISEMENT)
			end)
		end

		return function() -- line: 68
			-- upvalues: connection (ref), u18 (ref)
			if connection then
				connection:Disconnect()
			end

			if u18 then
				u18:unsubscribeFromAllMessages()
			end
		end
	end, {})

	return nil
end

return MagicLoginApprovePopupEventReceiver
