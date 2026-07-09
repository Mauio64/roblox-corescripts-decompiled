local WechatQQAuth = script:FindFirstAncestor("WechatQQAuth")
local WechatQQAuthParent = WechatQQAuth.Parent
local React = require(WechatQQAuthParent.React)
local AuthCommon = require(WechatQQAuthParent.AuthCommon)
local BackgroundFill = AuthCommon.Components.BackgroundFill
local AuthBackgroundContainer = AuthCommon.Components.AuthBackgroundContainer
local AuthBackgroundGate = AuthCommon.Components.AuthBackgroundGate
local FullscreenPageWithSafeArea = require(WechatQQAuthParent.AppBlox).FullscreenPageWithSafeArea
local WechatQQLoginContainer = require(WechatQQAuth.Components.WechatQQLoginContainer)
local Foundation = require(WechatQQAuthParent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local vector2 = Vector2.new(0.98, 0.98)
local v14 = React.PureComponent:extend("WechatQQLoginPage")

function v14.init(_) -- line: 23
end
function v14.didMount(_) -- line: 25
end
function v14.willUnmount(_) -- line: 27
end
function v14.render(_) -- line: 29
	-- upvalues: React (copy), FullscreenPageWithSafeArea (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), BackgroundFill (copy), View (copy), WechatQQLoginContainer (copy), vector2 (copy), FoundationImage (copy)
	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		renderFullscreenBackground = function(_) -- line: 32
			-- upvalues: React (copy), AuthBackgroundGate (copy), AuthBackgroundContainer (copy), BackgroundFill (copy)
			return React.createElement(AuthBackgroundGate, {
				renderTreatment = function() -- line: 34
					-- upvalues: React (copy), AuthBackgroundContainer (copy)
					return React.createElement(AuthBackgroundContainer, {})
				end,
				renderLegacy = function() -- line: 37
					-- upvalues: React (copy), BackgroundFill (copy)
					return React.createElement(BackgroundFill, {
						Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg",
						AspectRatio = 1
					})
				end
			})
		end
	}, {
		MainWrapper = React.createElement(View, {
			tag = "size-full-full"
		}, {
			ContentContainer = React.createElement(WechatQQLoginContainer, {}),
			AgeRatingContainer = React.createElement(View, {
				tag = "auto-xy anchor-bottom-right bg-system-contrast radius-small",
				Position = UDim2.new(vector2.X, 0, vector2.Y, 0)
			}, {
				AgeRatingImage = React.createElement(FoundationImage, {
					tag = "gui-object-defaults size-1200-1600",
					Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/ic_aged_rating.png"
				})
			})
		})
	})
end

return v14
