local v = {
	"ThumbnailCharacterRotation",
	"ThumbnailHorizontalOffset",
	"ThumbnailKeyframe",
	"ThumbnailVerticalOffset",
	"ThumbnailZoom",
	"ThumbnailTime",
	"ThumbnailFieldOfView"
}

local function createEmoteSchema()
	local emoteSchema = { ClassName = "Animation", _children = {} }

	for _, name in v do
		table.insert(emoteSchema._children, {
			Name = name,
			ClassName = "NumberValue",
			_optional = true
		})
	end

	return emoteSchema
end

return createEmoteSchema
