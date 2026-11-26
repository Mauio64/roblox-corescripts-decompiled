local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fdz")
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local transferRobuxFlow = module.TransferRobuxFlow
local transferDirection = module.Enums.TransferDirection
local getFFlagCurrencyTransferUseRoactNetworking = module.GetFFlagCurrencyTransferUseRoactNetworking

local function CurrencyTransferUniversalAppWrapper(p2)
	local v5 = useNavigation()
	local v6

	if getFFlagCurrencyTransferUseRoactNetworking() then
		v6 = useRoactService(RoactServiceTags.RoactNetworking)
	end

	local v7 = useNavigationProps(function(p3, data)
		local v8 = {
			direction = data.direction,
			recipientUserId = data.recipientUserId,
			transferId = data.transferId,
			transferOrigination = data.transferOrigination,
			onPromptOptimisticHide = 0,
			onPromptDismissCommitted = 0,
			homepagePromptId = 0
		}
		local v9 = if SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then data.onPromptOptimisticHide else nil
		v8.onPromptOptimisticHide = v9

		local v10 = if SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then data.onPromptDismissCommitted else nil
		v8.onPromptDismissCommitted = v10

		local v11 = if SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then data.homepagePromptId else nil
		v8.homepagePromptId = v11
		return v8
	end)

	local direction = v7.direction
	local v8

	if direction and string.lower(direction) == "receive" then
		v8 = transferDirection.Receive
	else
		v8 = transferDirection.Send
	end

	local recipientUserId = v7.recipientUserId

	if type(recipientUserId) == "string" then
		recipientUserId = tonumber(recipientUserId)
	end

	local v9 = v7.onPromptOptimisticHide
	local v10 = v7.onPromptDismissCommitted

	if
		SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction
		and v10 == nil
		and v8 == transferDirection.Receive
	then
		local callbacks = module.IncomingTransferHomepagePromptDismiss.createCallbacks({
			networking = v6,
			promptId = v7.homepagePromptId
		})

		v9 = callbacks.optimisticHide
		v10 = callbacks.commitDismiss
	end

	local createElement = React.createElement
	local v12 = {
		direction = v8,
		recipientUserId = recipientUserId,
		transferId = v7.transferId,
		transferOrigination = v7.transferOrigination,
		networkImpl = v6,
		onClose = function()
			v5.pop()
		end,
		onPromptOptimisticHide = 0,
		onPromptDismissCommitted = 0
	}

	if not SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then
		v9 = nil
	end

	v12.onPromptOptimisticHide = v9

	if not SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction then
		v10 = nil
	end

	v12.onPromptDismissCommitted = v10
	return createElement(transferRobuxFlow, v12)
end

return CurrencyTransferUniversalAppWrapper
