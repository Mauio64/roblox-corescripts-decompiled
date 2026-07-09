local t1 = {
	back = "back",
	close = "close",
	none = "none"
}
local t2 = {
	FailedToLoad = "FailedToLoad",
	LoadedFromCache = "LoadedFromCache",
	LoadedFromNetwork = "LoadedFromNetwork"
}
local t3 = {
	Protobuf = "protobuf",
	ProtobufJson = "protobuf-json"
}
local t4 = {
	Loading = "Loading",
	Error = "Error",
	Resolved = "Resolved"
}

return {
	NavButtonType = t1,
	SduiRequestStatus = t2,
	SduiResponseType = t3,
	UiStatus = t4
}
