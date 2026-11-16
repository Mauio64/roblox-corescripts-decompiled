local QRCodeDisplay = script:FindFirstAncestor("QRCodeDisplay")
require(QRCodeDisplay.Common.ECLevels)

return function(p)
	return (tonumber(p))
end
