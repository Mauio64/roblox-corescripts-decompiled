local function isBuildCreationSource(p2): boolean
	return p2 ~= nil and p2.creationSource == "build"
end

return isBuildCreationSource
