local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local OpenOverlay = require(parent.Actions.OpenOverlay)
local CloseOverlay = require(parent.Actions.CloseOverlay)

return Rodux.createReducer({ overlay = nil, overlayProps = {} }, {
	[OpenOverlay.name] = function(_, p)
		return { overlay = p.overlay, overlayProps = p.overlayProps }
	end,
	[CloseOverlay.name] = function(_, _)
		return { overlay = nil, overlayProps = {} }
	end
})
