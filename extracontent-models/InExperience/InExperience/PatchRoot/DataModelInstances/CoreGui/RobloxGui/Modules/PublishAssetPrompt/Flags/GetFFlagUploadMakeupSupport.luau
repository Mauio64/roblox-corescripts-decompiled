game:DefineFastFlag("UploadMakeupSupport", false)

local GetFFlagSingleUploadMakeupSupport = require(script.Parent.GetFFlagSingleUploadMakeupSupport)

return function() -- line: 5
	-- upvalues: GetFFlagSingleUploadMakeupSupport (copy)
	return GetFFlagSingleUploadMakeupSupport() and game:GetFastFlag("UploadMakeupSupport")
end
