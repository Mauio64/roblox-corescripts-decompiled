local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local NoticePageControl = require(Modules.Luobu.Components.TencentNoticePopup.NoticePageControl)
local t = require(CorePackages.Packages.t)
local v8 = Roact.PureComponent:extend("TencentNoticePopup")

v8.validateProps = t.strictInterface({
	noticeList = t.table,
	closePrompt = t.callback
})

function v8.render(p1) -- line: 16
	-- upvalues: Roact (copy), NoticePageControl (copy)
	local t1 = {
		widePopupWidth = 540,
		widePopupHeight = 268,
		headerHeight = 38,
		bottomHeight = 72,
		compactHeightToWidthRatio = 1.37614
	}

	return Roact.createElement(NoticePageControl, {
		noticeList = p1.props.noticeList,
		onActivated = p1.props.closePrompt,
		settings = t1
	})
end

return (RoactRodux.connect(nil, function(p2) -- line: 31
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closePrompt = function() -- line: 33
			-- upvalues: p2 (copy), CloseCentralOverlay (copy)
			p2(CloseCentralOverlay())
		end
	}
end)(v8))
