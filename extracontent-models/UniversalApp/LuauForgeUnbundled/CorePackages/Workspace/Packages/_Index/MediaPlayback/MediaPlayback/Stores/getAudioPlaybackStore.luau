local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/types")
local createAudioPlaybackStore = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Stores/getAudioPlaybackStore/createAudioPlaybackStore")

return Signals.createComputed(createAudioPlaybackStore)
