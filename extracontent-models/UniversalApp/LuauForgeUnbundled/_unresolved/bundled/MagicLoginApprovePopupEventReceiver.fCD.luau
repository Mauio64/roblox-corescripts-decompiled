local HttpService = game:GetService("HttpService")
local v5 = game:GetService("AccountService")
local v6 = game:GetEngineFeature("MagicLogin")

local useEffect = require("@luauforge/bundled/fCE").useEffect
local useDispatch = require("@luauforge/bundled/fCF").Hooks.RoactRodux.useDispatch
local logger = require("@luauforge/bundled/fCu").Logger
local module = require("@luauforge/bundled/fCC")
local setCentralOverlay = require("@luauforge/bundled/fCt").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/fCG").CentralOverlayType
local messageBus = require("@luauforge/bundled/fCH").MessageBus
local module2 = require("@luauforge/bundled/fCI")

local function MagicLoginApprovePopupEventReceiver(data): nil
	local useDispatch2 = data.useDispatch or useDispatch()

	v5 = data.AccountService or v5
	v6 = data.MagicLoginEngineFeature or v6

	useEffect(function()
		local magicLoginEventConnection, subscriber

		if v5 and v6 then
			magicLoginEventConnection = v5.MagicLoginEvent:Connect(function(p2)
				local success, result = pcall(HttpService.JSONDecode, HttpService, p2)

				if success then
					if result.magicLoginActionKey == module.CONNECTION_INIT then
						useDispatch2(setCentralOverlay(centralOverlayType.MagicLoginApprovePopup, {
							endpointName = result.endpointName,
							endpointType = result.endpointType,
							authenticationDigits = result.authenticationDigits,
							authCode = result.code
						}))
					end
				else
					logger:warning("Magic login Failed to parse JSON data from string: " .. p2)
				end
			end)

			subscriber = messageBus.Subscriber.new()

			subscriber:subscribe(
				{
					mid = messageBus.getMessageId("Game", "onGameLeave"),
					validateParams = module2.table
				},
				function(p2)
					v5:MagicLogin(module.START_ADVERTISEMENT)
				end
			)

			subscriber:subscribe(
				{
					mid = messageBus.getMessageId("Game", "launchSuccess"),
					validateParams = module2.table
				},
				function(p2)
					v5:MagicLogin(module.STOP_ADVERTISEMENT)
				end
			)
		else
			magicLoginEventConnection = nil
			subscriber = nil
		end

		return function()
			if magicLoginEventConnection then
				magicLoginEventConnection:Disconnect()
			end

			if subscriber then
				subscriber:unsubscribeFromAllMessages()
			end
		end
	end, {})

	return nil
end

return MagicLoginApprovePopupEventReceiver
