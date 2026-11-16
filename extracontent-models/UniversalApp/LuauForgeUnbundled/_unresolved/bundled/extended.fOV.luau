local module = require("@luauforge/bundled/fOW")
local authBackgroundContainer = require("@luauforge/bundled/fOX").Components.AuthBackgroundContainer
local fullscreenPageWithSafeArea = require("@luauforge/bundled/fOY").FullscreenPageWithSafeArea
local module2 = require("@luauforge/bundled/fOZ")
local module3 = require("@luauforge/bundled/fPa")

local view = module3.View
local image = module3.Image

local vector2 = Vector2.new(0.98, 0.98)

local extended = module.PureComponent:extend("WechatQQLoginPage")

function extended.init(p2) end

function extended.didMount(p2) end

function extended.willUnmount(p2) end

function extended.render(p2)
	return module.createElement(fullscreenPageWithSafeArea, {
		includeStatusBar = true,
		renderFullscreenBackground = function(p3)
			return module.createElement(authBackgroundContainer, {})
		end
	}, {
		MainWrapper = module.createElement(view, { tag = "size-full-full" }, {
			ContentContainer = module.createElement(module2, {}),
			AgeRatingContainer = module.createElement(
				view,
				{
					tag = "auto-xy anchor-bottom-right bg-system-contrast radius-small",
					Position = UDim2.new(vector2.X, 0, vector2.Y, 0)
				},
				{
					AgeRatingImage = module.createElement(image, {
						tag = "gui-object-defaults size-1200-1600",
						Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/ic_aged_rating.png"
					})
				}
			)
		})
	})
end

return extended
