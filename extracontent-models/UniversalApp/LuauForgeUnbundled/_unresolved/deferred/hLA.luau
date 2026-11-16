local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/fvl")
local module2 = require("@luauforge/deferred/hLB")
local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("TencentNoticePopup")

extended.validateProps = t.strictInterface({
	noticeList = t.table,
	closePrompt = t.callback
})

function extended.render(p2)
	return Roact.createElement(module2, {
		noticeList = p2.props.noticeList,
		onActivated = p2.props.closePrompt,
		settings = {
			widePopupWidth = 540,
			widePopupHeight = 268,
			headerHeight = 38,
			bottomHeight = 72,
			compactHeightToWidthRatio = 1.37614
		}
	})
end

return (RoactRodux.connect(nil, function(callback)
	return {
		closePrompt = function()
			callback(module())
		end
	}
end)(extended))
