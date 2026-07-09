local WechatQQAuth = script:FindFirstAncestor("WechatQQAuth")
local WechatQQAuthParent = WechatQQAuth.Parent
local React = require(WechatQQAuthParent.React)
local Foundation = require(WechatQQAuthParent.Foundation)
local useLocalization = require(WechatQQAuthParent.Localization).Hooks.useLocalization
local WechatQQButton = require(WechatQQAuth.Components.WechatQQButton)
local View = Foundation.View
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text

local function WechatQQLoginContainer(_: {[any]: any}) -- line: 30
	-- upvalues: useLocalization (copy), React (copy), View (copy), FoundationImage (copy), FoundationText (copy), WechatQQButton (copy)
	local v12 = useLocalization({
		antiAddictionText = "Luobu.Authentication.Login.Label.AntiAddictionText",
		logInTextWeChat = "Authentication.Login.Action.WeChatLogin",
		logInTextQQ = "Authentication.Login.Action.QQLogin",
		networkLicense = "Luobu.Authentication.Login.Label.NetworkLicense"
	})

	return React.createElement(View, {
		tag = "size-full col align-x-center align-y-center gap-xxlarge padding-large"
	}, {
		Logo = React.createElement(FoundationImage, {
			tag = "gui-object-defaults",
			Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/logo_white_luobu.png",
			ZIndex = 1,
			LayoutOrder = 1,
			aspectRatio = 4.0546875,
			Size = UDim2.new(0.7, 0, 0.7, 0),
			sizeConstraint = {
				MaxSize = Vector2.new(460, 113.44894026974951)
			}
		}),
		ContentContainer = React.createElement(View, {
			tag = "col align-x-center align-y-center auto-xy gap-medium",
			LayoutOrder = 2,
			sizeConstraint = {
				MinSize = Vector2.new(0, 0),
				MaxSize = Vector2.new(360, 1e999)
			}
		}, {
			AntiAddictionText = React.createElement(FoundationText, {
				tag = "auto-y gui-object-defaults size-full-0 text-align-x-left text-align-y-center text-wrap text-label-small padding-bottom-large",
				LayoutOrder = 1,
				Text = v12.antiAddictionText,
				textStyle = {
					Transparency = 0.5
				}
			}),
			WechatButton = React.createElement(WechatQQButton, {
				iconImage = "rbxasset://textures/ui/LuaApp/graphic/Auth/wechatlogo.png",
				backgroundColor = "#00e87e",
				layoutOrder = 2,
				text = v12.logInTextWeChat,
				onActivated = function() -- line: 40
				end
			}),
			QQButton = React.createElement(WechatQQButton, {
				iconImage = "rbxasset://textures/ui/LuaApp/graphic/Auth/qqlogo.png",
				backgroundColor = "#2bb1ff",
				layoutOrder = 3,
				text = v12.logInTextQQ,
				onActivated = function() -- line: 44
				end
			}),
			NetworkLicense = React.createElement(FoundationText, {
				tag = "auto-y gui-object-defaults size-full-0 text-align-x-left text-align-y-center text-wrap text-label-small padding-bottom-large",
				LayoutOrder = 4,
				Text = v12.networkLicense,
				textStyle = {
					Transparency = 0.5
				}
			})
		})
	})
end

return WechatQQLoginContainer
