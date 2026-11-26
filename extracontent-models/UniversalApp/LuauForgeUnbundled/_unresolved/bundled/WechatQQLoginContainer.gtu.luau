local module = require("@luauforge/bundled/gtr")
local module2 = require("@luauforge/bundled/gtv")
local useLocalization = require("@luauforge/bundled/gtw").Hooks.useLocalization
local module3 = require("@luauforge/bundled/gtx")

local view = module2.View
local image = module2.Image
local text = module2.Text

local function WechatQQLoginContainer(p2)
	local v5 = useLocalization({
		antiAddictionText = "Luobu.Authentication.Login.Label.AntiAddictionText",
		logInTextWeChat = "Authentication.Login.Action.WeChatLogin",
		logInTextQQ = "Authentication.Login.Action.QQLogin",
		networkLicense = "Luobu.Authentication.Login.Label.NetworkLicense"
	})

	return module.createElement(
		view,
		{
			tag = "size-full col align-x-center align-y-center gap-xxlarge padding-large"
		},
		{
			Logo = module.createElement(image, {
				tag = "gui-object-defaults",
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_luobu.png",
				Size = UDim2.new(0.7, 0, 0.7, 0),
				ZIndex = 1,
				LayoutOrder = 1,
				sizeConstraint = {
					MaxSize = Vector2.new(460, 58880 / 519)
				},
				aspectRatio = 4.0546875
			}),
			ContentContainer = module.createElement(view, {
				tag = "col align-x-center align-y-center auto-xy gap-medium",
				LayoutOrder = 2,
				sizeConstraint = {
					MinSize = Vector2.new(0, 0),
					MaxSize = Vector2.new(360, 1e999)
				}
			}, {
				AntiAddictionText = module.createElement(text, {
					Text = v5.antiAddictionText,
					tag = "auto-y gui-object-defaults size-full-0 text-align-x-left text-align-y-center text-wrap text-label-small padding-bottom-large",
					textStyle = { Transparency = 0.5 },
					LayoutOrder = 1
				}),
				WechatButton = module.createElement(module3, {
					text = v5.logInTextWeChat,
					iconImage = "rbxasset://textures/ui/LuaApp/graphic/Auth/wechatlogo.png",
					backgroundColor = "#00e87e",
					onActivated = function() end,
					layoutOrder = 2
				}),
				QQButton = module.createElement(module3, {
					text = v5.logInTextQQ,
					iconImage = "rbxasset://textures/ui/LuaApp/graphic/Auth/qqlogo.png",
					backgroundColor = "#2bb1ff",
					onActivated = function() end,
					layoutOrder = 3
				}),
				NetworkLicense = module.createElement(text, {
					Text = v5.networkLicense,
					tag = "auto-y gui-object-defaults size-full-0 text-align-x-left text-align-y-center text-wrap text-label-small padding-bottom-large",
					textStyle = { Transparency = 0.5 },
					LayoutOrder = 4
				})
			})
		}
	)
end

return WechatQQLoginContainer
