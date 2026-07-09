local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local InteractiveAlert = require(Parent.UIBlox).App.Dialog.Alert.InteractiveAlert
local useScreenSize = require(Parent.EconomyCommonCoreScriptHooks).useScreenSize
local Scrim = require(script.Parent.Scrim)

local function AlertPrompt(t1: {[any]: any}) -- line: 18
	-- upvalues: useScreenSize (copy), React (copy), Scrim (copy), InteractiveAlert (copy)
	local v8 = useScreenSize()

	return React.createElement(Scrim, {}, React.createElement(InteractiveAlert, {
		title = t1.title,
		bodyText = t1.bodyText,
		buttonStackInfo = {
			buttons = {{
				isDefaultChild = true,
				props = {
					onActivated = t1.onDismiss,
					text = t1.dismissCTA
				}
			}}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v8,
		middleContent = t1.middleContent
	}))
end

return AlertPrompt
