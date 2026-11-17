local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local GalleryButtonContentView = require(script.Parent.GalleryButtonContentView)
require(parent.Types)

local useGalleryButtonContentViewModel = require(script.Parent.useGalleryButtonContentViewModel)

local function GalleryButtonContent(p)
	local v = useGalleryButtonContentViewModel(p.latestCapture)

	return React.createElement(GalleryButtonContentView, v)
end

return React.memo(GalleryButtonContent)
