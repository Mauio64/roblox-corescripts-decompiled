local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useScreenSize = EconomyCommonCoreScriptHooks.useScreenSize
local useCloseOnEscapeEffect = require(BulkPurchaseApp.Hooks.useCloseOnEscapeEffect)
local FFlagBulkPurchaseCloseOnEscape = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseCloseOnEscape)

local Scrim = require(script.Parent.Scrim)

local function AlertPrompt(props)
	if FFlagBulkPurchaseCloseOnEscape then
		useCloseOnEscapeEffect("BulkPurchaseCloseAlertPrompt", props.onDismiss)
	end

	local screenSize = useScreenSize()

	return React.createElement(Scrim, {}, React.createElement(InteractiveAlert, {
		title = props.title,
		bodyText = props.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = props.onDismiss, text = props.dismissCTA },
					isDefaultChild = true
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		middleContent = props.middleContent
	}))
end

return AlertPrompt
