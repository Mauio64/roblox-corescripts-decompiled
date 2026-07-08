local t1 = {
	"ThumbnailCharacterRotation",
	"ThumbnailHorizontalOffset",
	"ThumbnailKeyframe",
	"ThumbnailVerticalOffset",
	"ThumbnailZoom",
	"ThumbnailTime",
	"ThumbnailFieldOfView"
}

local function createEmoteSchema() -- line: 15
	-- upvalues: t1 (copy)
	local t2 = {
		ClassName = "Animation",
		_children = {}
	}

	for _, v5 in t1 do
		table.insert(t2._children, {
			ClassName = "NumberValue",
			_optional = true,
			Name = v5
		})
	end

	return t2
end

return createEmoteSchema
