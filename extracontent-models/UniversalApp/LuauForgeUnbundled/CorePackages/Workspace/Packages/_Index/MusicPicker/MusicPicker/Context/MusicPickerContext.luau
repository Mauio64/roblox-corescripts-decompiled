local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")

require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

return (React.createContext({
	previewingId = nil,
	togglePreview = function() end,
	savedIds = {},
	toggleSaved = function() end
}))
