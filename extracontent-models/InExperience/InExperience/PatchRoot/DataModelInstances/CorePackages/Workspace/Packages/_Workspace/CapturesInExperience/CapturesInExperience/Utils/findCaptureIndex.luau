local parent = script.Parent.Parent

require(parent.Types)

local getCaptureObject = require(parent.Utils.getCaptureObject)

local function findCaptureIndex(items, p, p2: string?)
	local localId = p.LocalId

	for k, item in items do
		if p2 and typeof(item) == "table" and item.filePath == p2 then
			return k
		end

		local captureObject = getCaptureObject(item)

		if localId and captureObject and captureObject.LocalId == localId then
			return k
		end
	end

	return nil
end

return findCaptureIndex
