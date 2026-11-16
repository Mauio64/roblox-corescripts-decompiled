local MusicPicker = script:FindFirstAncestor("MusicPicker")
local parent = MusicPicker.Parent

local React = require(parent.React)

require(MusicPicker.Types.MusicPickerTypes)

return (React.createContext({
	previewingId = nil,
	togglePreview = function() end,
	savedIds = {},
	toggleSaved = function() end
}))
