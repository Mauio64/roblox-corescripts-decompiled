require(script:FindFirstAncestor("WhatsNew").Types)

return {
	registerAnchorReady = function(p1, s1: string) -- line: 3
		p1.registerAnchor(s1, Instance.new("Frame"))
		p1.setAnchorReady(s1, true)
	end,
	registerNestedWhatsNewAnchors = function(p2) -- line: 8
		p2.registerAnchor("gameMenuTilt", Instance.new("Frame"))
		p2.setAnchorReady("gameMenuTilt", true)
		p2.registerAnchor("inGameSideSheetA", Instance.new("Frame"))
		p2.setAnchorReady("inGameSideSheetA", true)
		p2.registerAnchor("inGameSideSheetB", Instance.new("Frame"))
		p2.setAnchorReady("inGameSideSheetB", true)
		p2.registerAnchor("LeaveRespawn", Instance.new("Frame"))
		p2.setAnchorReady("LeaveRespawn", true)
	end,
	registerDoubleNestedAnchors = function(p3) -- line: 15
		p3.registerAnchor("gameMenuTilt", Instance.new("Frame"))
		p3.setAnchorReady("gameMenuTilt", true)
		p3.registerAnchor("settingsGatewayAnchor", Instance.new("Frame"))
		p3.setAnchorReady("settingsGatewayAnchor", true)
		p3.registerAnchor("settingsTipAnchor", Instance.new("Frame"))
		p3.setAnchorReady("settingsTipAnchor", true)
	end
}
