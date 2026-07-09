local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local Signals = require(MediaPlayback.Parent.Signals)

require(script.types)

local createAudioPlaybackStore = require(script.createAudioPlaybackStore)

return Signals.createComputed(createAudioPlaybackStore)
