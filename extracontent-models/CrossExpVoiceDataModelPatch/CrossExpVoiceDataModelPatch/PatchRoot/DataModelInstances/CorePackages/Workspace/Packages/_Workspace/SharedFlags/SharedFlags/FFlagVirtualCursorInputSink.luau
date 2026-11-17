local defineFastFlag = game:DefineFastFlag("VirtualCursorInputSink", false)
local engineFeature = game:GetEngineFeature("InputSink")

return defineFastFlag and engineFeature
