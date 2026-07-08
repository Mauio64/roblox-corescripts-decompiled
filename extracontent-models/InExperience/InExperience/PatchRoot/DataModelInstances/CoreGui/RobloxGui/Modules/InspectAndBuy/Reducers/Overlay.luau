local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local OpenOverlay = require(ParentParent.Actions.OpenOverlay)
local CloseOverlay = require(ParentParent.Actions.CloseOverlay)
local t1 = {
	overlay = nil,
	overlayProps = {}
}

return Rodux.createReducer(t1, {
	[OpenOverlay.name] = function(_, p2) -- line: 25
		return {
			overlay = p2.overlay,
			overlayProps = p2.overlayProps
		}
	end,
	[CloseOverlay.name] = function(_, _) -- line: 33
		return {
			overlay = nil,
			overlayProps = {}
		}
	end
})
