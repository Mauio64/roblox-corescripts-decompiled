local function getTextLengthIfValidUtf8(p: string)
	if utf8.len(p) == nil then
		return nil
	end

	return utf8.len(utf8.nfcnormalize(p))
end

return getTextLengthIfValidUtf8
