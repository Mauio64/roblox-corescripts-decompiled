local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent.Parent.Parent

local SetAllowInventoryReadAccess = require(parent.Thunks.SetAllowInventoryReadAccess)

local extended = Roact.PureComponent:extend("AllowInventoryReadAccessPrompt")

extended.validateProps = t.strictInterface({
	gameName = t.string,
	screenSize = t.Vector2,
	setAvatarReadAccessAllowed = t.callback,
	setAvatarReadAccessDenied = t.callback
})

function extended.render(p)
	return Roact.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptText", {
			RBX_NAME = p.props.gameName
		}),
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = p.props.setAvatarReadAccessDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptNo")
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p.props.setAvatarReadAccessAllowed,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptYes")
					},
					isDefaultChild = false
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = p.props.screenSize
	})
end

local function mapStateToProps(p)
	return { gameName = p.gameName, screenSize = p.screenSize }
end

local function mapDispatchToProps(callback)
	return {
		setAvatarReadAccessDenied = function()
			return callback(SetAllowInventoryReadAccess(false))
		end,
		setAvatarReadAccessAllowed = function()
			return callback(SetAllowInventoryReadAccess(true))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
