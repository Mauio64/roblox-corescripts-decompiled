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
local ParentParent = script.Parent.Parent.Parent
local SetAllowInventoryReadAccess = require(ParentParent.Thunks.SetAllowInventoryReadAccess)
local v12 = Roact.PureComponent:extend("AllowInventoryReadAccessPrompt")

v12.validateProps = t.strictInterface({
	gameName = t.string,
	screenSize = t.Vector2,
	setAvatarReadAccessAllowed = t.callback,
	setAvatarReadAccessDenied = t.callback
})

function v12.render(p1) -- line: 31
	-- upvalues: Roact (copy), InteractiveAlert (copy), RobloxTranslator (copy), ButtonType (copy)
	return Roact.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptText", {
			RBX_NAME = p1.props.gameName
		}),
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p1.props.setAvatarReadAccessDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptNo")
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p1.props.setAvatarReadAccessAllowed,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.InventoryReadAccessPromptYes")
					}
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = p1.props.screenSize
	})
end

local function mapStateToProps(p2) -- line: 65
	return {
		gameName = p2.gameName,
		screenSize = p2.screenSize
	}
end
local function mapDispatchToProps(p3) -- line: 72
	-- upvalues: SetAllowInventoryReadAccess (copy)
	return {
		setAvatarReadAccessDenied = function() -- line: 74
			-- upvalues: p3 (copy), SetAllowInventoryReadAccess (copy)
			return p3(SetAllowInventoryReadAccess(false))
		end,
		setAvatarReadAccessAllowed = function() -- line: 78
			-- upvalues: p3 (copy), SetAllowInventoryReadAccess (copy)
			return p3(SetAllowInventoryReadAccess(true))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v12)
